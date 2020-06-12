# coding: utf-8

import sys

if sys.version_info < (3, 7):
    raise RuntimeError("A python version 3.7 or newer is required")

import os
import time
import stat
import json
import shlex
import shutil
import hashlib
import zipfile
import argparse
import datetime
import tempfile
import platform
import subprocess
from subprocess import check_call
from contextlib import contextmanager
from base64 import b64encode
import logging

PY38 = sys.version_info >= (3, 8)

################################################################################
# Logging

DEBUG2 = 9
DEBUG3 = 8

log_handler = None
logger = logging.getLogger()
cmd_logger = logging.getLogger('cmd')


def configure_logging(use_tf_stderr=False):
    global log_handler

    logging.addLevelName(DEBUG2, 'DEBUG2')
    logging.addLevelName(DEBUG3, 'DEBUG3')

    class LogFormatter(logging.Formatter):
        default_format = '%(message)s'
        formats = {
            'root': default_format,
            'build': default_format,
            'prepare': '[{}] %(name)s: %(message)s'.format(os.getpid()),
            'cmd': '> %(message)s',
            '': '%(name)s: %(message)s'
        }

        def formatMessage(self, record):
            prefix = record.name.rsplit('.')
            self._style._fmt = self.formats.get(prefix[0], self.formats[''])
            return super().formatMessage(record)

    tf_stderr_fd = 5
    log_stream = sys.stderr
    if use_tf_stderr:
        try:
            if os.isatty(tf_stderr_fd):
                log_stream = os.fdopen(tf_stderr_fd, mode='w')
        except OSError:
            pass

    log_handler = logging.StreamHandler(stream=log_stream)
    log_handler.setFormatter(LogFormatter())

    logger.addHandler(log_handler)
    logger.setLevel(logging.INFO)


################################################################################
# Backports

def shlex_join(split_command):
    """Return a shell-escaped string from *split_command*."""
    return ' '.join(shlex.quote(arg) for arg in split_command)


################################################################################
# Common functions

def abort(message):
    """Exits with an error message."""
    logger.error(message)
    sys.exit(1)


@contextmanager
def cd(path, silent=False):
    """Changes the working directory."""
    cwd = os.getcwd()
    if not silent:
        cmd_logger.info('cd %s', shlex.quote(path))
    try:
        os.chdir(path)
        yield
    finally:
        os.chdir(cwd)


@contextmanager
def tempdir():
    """Creates a temporary directory and then deletes it afterwards."""
    prefix = 'terraform-aws-lambda-'
    path = tempfile.mkdtemp(prefix=prefix)
    cmd_logger.info('mktemp -d %sXXXXXXXX # %s', prefix, shlex.quote(path))
    try:
        yield path
    finally:
        shutil.rmtree(path)


def list_files(top_path, logger=None):
    """
    Returns a sorted list of all files in a directory.
    """

    if logger:
        logger = logger.getChild('ls')

    results = []

    for root, dirs, files in os.walk(top_path):
        for file_name in files:
            file_path = os.path.join(root, file_name)
            relative_path = os.path.relpath(file_path, top_path)
            results.append(relative_path)
            if logger:
                logger.debug(relative_path)

    results.sort()
    return results


def dataclass(name, **fields):
    typ = type(name, (object,), {
        '__slots__': fields.keys(),
        '__getattr__': lambda *_: None,
    })
    for k, v in fields.items():
        setattr(typ, k, v)
    return typ


def datatree(name, **fields):
    def decode_json(v):
        if v and isinstance(v, str) and v[0] in '"[{':
            try:
                return json.loads(v)
            except json.JSONDecodeError:
                pass
        return v

    return dataclass(name, **dict(((
        k, datatree(k, **v) if isinstance(v, dict) else decode_json(v))
        for k, v in fields.items())))()


def timestamp_now_ns():
    timestamp = datetime.datetime.now().timestamp()
    timestamp = int(timestamp * 10 ** 7) * 10 ** 2
    return timestamp


def source_code_hash(bytes):
    return b64encode(hashlib.sha256(bytes).digest()).decode()


def yesno_bool(val):
    if val is None:
        return
    if isinstance(val, bool):
        return val
    if isinstance(val, int):
        return bool(val)
    if isinstance(val, str):
        if val.isnumeric():
            return bool(int(val))
        val = val.lower()
        if val in ('true', 'yes', 'y'):
            return True
        elif val in ('false', 'no', 'n'):
            return False
        else:
            raise ValueError("Unsupported value: %s" % val)
    return False


################################################################################
# Packaging functions

def emit_dir_content(base_dir):
    for root, dirs, files in os.walk(base_dir):
        if root != base_dir:
            yield os.path.normpath(root)
        for name in files:
            yield os.path.normpath(os.path.join(root, name))


def generate_content_hash(source_paths,
                          hash_func=hashlib.sha256, logger=None):
    """
    Generate a content hash of the source paths.
    """

    if logger:
        logger = logger.getChild('hash')

    hash_obj = hash_func()

    for source_path in source_paths:
        if os.path.isdir(source_path):
            source_dir = source_path
            for source_file in list_files(source_dir, logger=logger):
                update_hash(hash_obj, source_dir, source_file)
                if logger:
                    logger.debug(os.path.join(source_dir, source_file))
        else:
            source_dir = os.path.dirname(source_path)
            source_file = os.path.relpath(source_path, source_dir)
            update_hash(hash_obj, source_dir, source_file)
            if logger:
                logger.debug(source_path)

    return hash_obj


def update_hash(hash_obj, file_root, file_path):
    """
    Update a hashlib object with the relative path and contents of a file.
    """

    relative_path = os.path.join(file_root, file_path)
    hash_obj.update(relative_path.encode())

    with open(relative_path, 'rb') as open_file:
        while True:
            data = open_file.read(1024 * 8)
            if not data:
                break
            hash_obj.update(data)


class ZipWriteStream:
    """"""

    def __init__(self, zip_filename,
                 compress_type=zipfile.ZIP_DEFLATED,
                 compresslevel=None,
                 timestamp=None):

        self.timestamp = timestamp
        self.filename = zip_filename

        if not (self.filename and isinstance(self.filename, str)):
            raise ValueError('Zip file path must be provided')

        self._tmp_filename = None
        self._compress_type = compress_type
        self._compresslevel = compresslevel
        self._zip = None

        self._logger = logging.getLogger('zip')

    def open(self):
        if self._tmp_filename:
            raise zipfile.BadZipFile("ZipStream object can't be reused")
        self._ensure_base_path(self.filename)
        self._tmp_filename = '{}.tmp'.format(self.filename)
        self._logger.info("creating '%s' archive", self.filename)
        self._zip = zipfile.ZipFile(self._tmp_filename, "w",
                                    self._compress_type)
        return self

    def close(self, failed=False):
        if failed:
            os.unlink(self._tmp_filename)
        else:
            os.replace(self._tmp_filename, self.filename)
        self._zip = None

    def __enter__(self):
        return self.open()

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.close(failed=exc_type is not None)

    def _ensure_open(self):
        if self._zip is not None:
            return True
        if self._tmp_filename:
            raise zipfile.BadZipFile("ZipWriteStream object can't be reused")
        raise zipfile.BadZipFile('ZipWriteStream should be opened first')

    def _ensure_base_path(self, zip_filename):
        archive_dir = os.path.dirname(zip_filename)

        if archive_dir and not os.path.exists(archive_dir):
            self._logger.info("creating %s", archive_dir)
            os.makedirs(archive_dir)

    def write_dirs(self, *base_dirs, prefix=None, timestamp=None):
        """
        Writes a directory content to a prefix inside of a zip archive
        """
        self._ensure_open()
        for base_dir in base_dirs:
            self._logger.info("adding content of directory '%s'", base_dir)
            for path in emit_dir_content(base_dir):
                arcname = os.path.relpath(path, base_dir)
                self._logger.info("adding '%s'", arcname)
                zinfo = self._make_zinfo_from_file(path, arcname)
                if timestamp is None:
                    timestamp = self.timestamp
                date_time = self._timestamp_to_date_time(timestamp)
                if date_time:
                    self._update_zinfo(zinfo, date_time=date_time)
                self._write_zinfo(zinfo, path)

    def write_files(self, files_stream, prefix=None, timestamp=None):
        """
        Expects just files stream, directories will be created automatically
        """
        self._ensure_open()
        raise NotImplementedError

    def write_file(self, file_path, prefix=None, name=None, timestamp=None):
        """
        Reads a file and writes it to a prefix
        or a full qualified name in a zip archive
        """
        self._ensure_open()
        raise NotImplementedError

    def write_file_obj(self, file_path, data, prefix=None, timestamp=None):
        """
        Write a data to a zip archive by a full qualified file path
        """
        self._ensure_open()
        raise NotImplementedError

    def _write_zinfo(self, zinfo, filename,
                     compress_type=None, compresslevel=None):
        self._ensure_open()

        zip = self._zip

        if not zip.fp:
            raise ValueError(
                "Attempt to write to ZIP archive that was already closed")
        if zip._writing:
            raise ValueError(
                "Can't write to ZIP archive while an open writing handle exists"
            )

        if zinfo.is_dir():
            zinfo.compress_size = 0
            zinfo.CRC = 0
        else:
            if compress_type is not None:
                zinfo.compress_type = compress_type
            else:
                zinfo.compress_type = self._compress_type

            if compresslevel is not None:
                zinfo._compresslevel = compresslevel
            else:
                zinfo._compresslevel = self._compresslevel

        if zinfo.is_dir():
            with zip._lock:
                if zip._seekable:
                    zip.fp.seek(zip.start_dir)
                zinfo.header_offset = zip.fp.tell()  # Start of header bytes
                if zinfo.compress_type == zipfile.ZIP_LZMA:
                    # Compressed data includes an end-of-stream (EOS) marker
                    zinfo.flag_bits |= 0x02

                zip._writecheck(zinfo)
                zip._didModify = True

                zip.filelist.append(zinfo)
                zip.NameToInfo[zinfo.filename] = zinfo
                zip.fp.write(zinfo.FileHeader(False))
                zip.start_dir = zip.fp.tell()
        else:
            with open(filename, "rb") as src, zip.open(zinfo, 'w') as dest:
                shutil.copyfileobj(src, dest, 1024 * 8)

    def _make_zinfo_from_file(self, filename, arcname=None):
        if PY38:
            zinfo_func = zipfile.ZipInfo.from_file
            strict_timestamps = self._zip._strict_timestamps
        else:
            zinfo_func = self._zinfo_from_file
            strict_timestamps = True

        return zinfo_func(filename, arcname,
                          strict_timestamps=strict_timestamps)

    @staticmethod
    def _update_zinfo(zinfo, date_time):
        zinfo.date_time = date_time

    # Borrowed from python 3.8 zipfile.py library
    # due to the need of strict_timestamps functionality.
    @staticmethod
    def _zinfo_from_file(filename, arcname=None, *, strict_timestamps=True):
        """Construct an appropriate ZipInfo for a file on the filesystem.

        filename should be the path to a file or directory on the filesystem.

        arcname is the name which it will have within the archive (by default,
        this will be the same as filename, but without a drive letter and with
        leading path separators removed).
        """
        if isinstance(filename, os.PathLike):
            filename = os.fspath(filename)
        st = os.stat(filename)
        isdir = stat.S_ISDIR(st.st_mode)
        mtime = time.localtime(st.st_mtime)
        date_time = mtime[0:6]
        if not strict_timestamps and date_time[0] < 1980:
            date_time = (1980, 1, 1, 0, 0, 0)
        elif not strict_timestamps and date_time[0] > 2107:
            date_time = (2107, 12, 31, 23, 59, 59)
        # Create ZipInfo instance to store file information
        if arcname is None:
            arcname = filename
        arcname = os.path.normpath(os.path.splitdrive(arcname)[1])
        while arcname[0] in (os.sep, os.altsep):
            arcname = arcname[1:]
        if isdir:
            arcname += '/'
        zinfo = zipfile.ZipInfo(arcname, date_time)
        zinfo.external_attr = (st.st_mode & 0xFFFF) << 16  # Unix attributes
        if isdir:
            zinfo.file_size = 0
            zinfo.external_attr |= 0x10  # MS-DOS directory flag
        else:
            zinfo.file_size = st.st_size

        return zinfo

    @staticmethod
    def _timestamp_to_date_time(timestamp):
        def str_int_to_timestamp(s):
            min_zip_ts = datetime.datetime(1980, 1, 1).timestamp()
            ts = int(s)
            if ts < min_zip_ts:
                return min_zip_ts
            deg = len(str(int(s))) - 9
            if deg < 0:
                ts = ts * 10 ** deg
            return ts

        date_time = None
        if timestamp is not None:
            if isinstance(timestamp, str):
                if timestamp.isnumeric():
                    timestamp = str_int_to_timestamp(timestamp)
                else:
                    timestamp = float(timestamp)
            elif isinstance(timestamp, int):
                timestamp = str_int_to_timestamp(str(timestamp))

            date_time = datetime.datetime.fromtimestamp(timestamp).timetuple()
            date_time = date_time[:6]
            if date_time[0] < 1980:
                raise ValueError('ZIP does not support timestamps before 1980')
        return date_time


################################################################################
# Building

@contextmanager
def install_pip_requirements(query, zip_stream, requirements_file):
    runtime = query.runtime
    artifacts_dir = query.artifacts_dir
    docker = query.docker

    working_dir = os.getcwd()

    if os.path.exists(requirements_file):
        logger.info('Installing python requirements: %s', requirements_file)
        with tempdir() as temp_dir:
            requirements_filename = os.path.basename(requirements_file)
            target_file = os.path.join(temp_dir, requirements_filename)
            shutil.copyfile(requirements_file, target_file)

            # Install dependencies into the temporary directory.
            with cd(temp_dir):
                if runtime.startswith('python3'):
                    pip_command = ['pip3']
                else:
                    pip_command = ['pip2']
                pip_command.extend([
                    'install', '--no-compile',
                    '--prefix=', '--target=.',
                    '--requirement={}'.format(requirements_filename),
                ])
                if docker:
                    pip_cache_dir = docker.docker_pip_cache
                    if pip_cache_dir:
                        if isinstance(pip_cache_dir, str):
                            pip_cache_dir = os.path.abspath(
                                os.path.join(working_dir, pip_cache_dir))
                        else:
                            pip_cache_dir = os.path.abspath(os.path.join(
                                working_dir, artifacts_dir, 'cache/pip'))

                    chown_mask = '{}:{}'.format(os.getuid(), os.getgid())
                    shell_command = [shlex_join(pip_command), '&&',
                                     shlex_join(['chown', '-R',
                                                 chown_mask, '.'])]
                    shell_command = [' '.join(shell_command)]
                    check_call(docker_run_command(
                        '.', shell_command, runtime, shell=True,
                        pip_cache_dir=pip_cache_dir
                    ))
                else:
                    cmd_logger.info(shlex_join(pip_command))
                    log_handler and log_handler.flush()
                    check_call(pip_command)

                os.remove(target_file)
                yield temp_dir


def docker_build_command(build_root, docker_file=None, tag=None):
    """"""
    docker_cmd = ['docker', 'build']
    if docker_file:
        docker_cmd.extend(['--file', docker_file])
    if tag:
        docker_cmd.extend(['--tag', tag])
    docker_cmd.append(build_root)

    cmd_logger.info(shlex_join(docker_cmd))
    log_handler and log_handler.flush()
    return docker_cmd


def docker_run_command(build_root, command, runtime,
                       image=None, shell=None, interactive=False,
                       pip_cache_dir=None):
    """"""
    docker_cmd = ['docker', 'run', '--rm']

    if interactive:
        docker_cmd.append('-it')

    bind_path = os.path.abspath(build_root)
    docker_cmd.extend(['-v', "{}:/var/task:z".format(bind_path)])

    home = os.environ['HOME']
    docker_cmd.extend([
        # '-v', '{}/.ssh/id_rsa:/root/.ssh/id_rsa:z'.format(home),
        '-v', '{}/.ssh/known_hosts:/root/.ssh/known_hosts:z'.format(home),
    ])

    if platform.system() == 'Darwin':
        # https://docs.docker.com/docker-for-mac/osxfs/#ssh-agent-forwarding
        docker_cmd.extend([
            '--mount', 'type=bind,'
                       'src=/run/host-services/ssh-auth.sock,'
                       'target=/run/host-services/ssh-auth.sock',
            '-e', 'SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock',
        ])
    elif platform.system() == 'Linux':
        sock = os.environ['SSH_AUTH_SOCK']  # TODO: Handle missing env var
        docker_cmd.extend([
            '-v', '{}:/tmp/ssh_sock:z'.format(sock),
            '-e', 'SSH_AUTH_SOCK=/tmp/ssh_sock',
        ])
        if pip_cache_dir:
            pip_cache_dir = os.path.abspath(pip_cache_dir)
            docker_cmd.extend([
                '-v', '{}:/root/.cache/pip:z'.format(pip_cache_dir),
            ])
    else:
        raise RuntimeError("Unsupported platform for docker building")

    if not image:
        image = 'lambci/lambda:build-{}'.format(runtime)

    docker_cmd.append(image)

    assert isinstance(command, list)
    if shell:
        if not isinstance(shell, str):
            shell = '/bin/sh'
        docker_cmd.extend([shell, '-c'])
    docker_cmd.extend(command)

    cmd_logger.info(shlex_join(docker_cmd))
    log_handler and log_handler.flush()
    return docker_cmd


################################################################################
# Commands

def prepare_command(args):
    """
    Generates a content hash of the source_path, which is used to determine if
    the Lambda code has changed, ignoring file modification and access times.

    Outputs a filename and a command to run if the archive needs to be built.
    """

    logger = logging.getLogger('prepare')

    # Load the query.
    query_data = json.load(sys.stdin)

    if logger.isEnabledFor(DEBUG3):
        logger.debug('ENV: %s', json.dumps(dict(os.environ), indent=2))
    if logger.isEnabledFor(DEBUG2):
        logger.debug('QUERY: %s', json.dumps(query_data, indent=2))

    query = datatree('prepare_query', **query_data)

    tf_paths = query.paths
    runtime = query.runtime
    function_name = query.function_name
    artifacts_dir = query.artifacts_dir
    hash_extra_paths = query.hash_extra_paths
    source_path = query.source_path
    hash_extra = query.hash_extra
    recreate_missing_package = yesno_bool(args.recreate_missing_package)

    # Compacting docker vars
    docker = query.docker
    if docker:
        docker = {k: v for k, v in docker.items() if v} or True

    # Validate the query.
    if not os.path.exists(source_path):
        abort('source_path must be set.')

    # Expand a Terraform path.<cwd|root|module> references
    hash_extra_paths = [p.format(path=tf_paths) for p in hash_extra_paths]
    content_hash_paths = [source_path] + hash_extra_paths

    # Generate a hash based on file names and content. Also use the
    # runtime value, build command, and content of the build paths
    # because they can have an effect on the resulting archive.
    logger.debug("Computing content hash on files...")
    content_hash = generate_content_hash(content_hash_paths, logger=logger)
    content_hash.update(runtime.encode())
    content_hash.update(hash_extra.encode())
    content_hash = content_hash.hexdigest()

    # Generate a unique filename based on the hash.
    filename = os.path.join(artifacts_dir, '{}.zip'.format(content_hash))

    # Compute timestamp trigger
    was_missing = False
    filename_path = os.path.join(os.getcwd(), filename)
    if recreate_missing_package:
        if os.path.exists(filename_path):
            st = os.stat(filename_path)
            timestamp = st.st_mtime_ns
        else:
            timestamp = timestamp_now_ns()
            was_missing = True
    else:
        timestamp = "<WARNING: Missing lambda zip artifacts " \
                    "wouldn't be restored>"

    # Replace variables in the build command with calculated values.
    build_data = {
        'filename': filename,
        'runtime': runtime,
        'source_path': source_path,
        'artifacts_dir': artifacts_dir,
    }
    if docker:
        build_data['docker'] = docker

    build_plan = json.dumps(build_data)
    build_plan_filename = os.path.join(artifacts_dir,
                                       '{}.plan.json'.format(content_hash))
    if not os.path.exists(artifacts_dir):
        os.makedirs(artifacts_dir)
    with open(build_plan_filename, 'w') as f:
        f.write(build_plan)

    # Output the result to Terraform.
    json.dump({
        'filename': filename,
        'build_plan': build_plan,
        'build_plan_filename': build_plan_filename,
        'timestamp': str(timestamp),
        'was_missing': 'true' if was_missing else 'false',
    }, sys.stdout, indent=2)
    sys.stdout.write('\n')


def build_command(args):
    """
    Builds a zip file from the source_dir or source_file.
    Installs dependencies with pip automatically.
    """

    logger = logging.getLogger('build')

    if logger.isEnabledFor(DEBUG3):
        logger.debug('ENV: %s', json.dumps(dict(os.environ), indent=2))
    if logger.isEnabledFor(DEBUG2):
        logger.debug('CMD: python3 %s', shlex_join(sys.argv))

    with open(args.build_plan_file) as f:
        query_data = json.load(f)
    query = datatree('build_query', **query_data)

    runtime = query.runtime
    filename = query.filename
    source_path = query.source_path
    _timestamp = args.zip_file_timestamp

    timestamp = 0
    if _timestamp.isnumeric():
        timestamp = int(_timestamp)

    if os.path.exists(filename) and not args.force:
        logger.info('Reused: %s', shlex.quote(filename))
        return

    # Zip up the temporary directory and write it to the target filename.
    # This will be used by the Lambda function as the source code package.
    with ZipWriteStream(filename) as zs:
        if os.path.isdir(source_path):
            if runtime.startswith('python'):
                with install_pip_requirements(
                    query, zs, os.path.join(source_path, 'requirements.txt')
                ) as rd:
                    rd and zs.write_dirs(rd, timestamp=0)  # XXX: temp ts=0
            zs.write_dirs(source_path)
        else:
            zs.write_file(source_path)

    os.utime(filename, ns=(timestamp, timestamp))
    logger.info('Created: %s', shlex.quote(filename))
    if logger.isEnabledFor(logging.DEBUG):
        with open(filename, 'rb') as f:
            logger.info('Base64sha256: %s', source_code_hash(f.read()))


def add_hidden_commands(sub_parsers):
    sp = sub_parsers

    def hidden_parser(name, **kwargs):
        p = sp.add_parser(name, **kwargs)
        sp._choices_actions.pop()  # XXX: help=argparse.SUPPRESS - doesn't work
        return p

    p = hidden_parser('docker', help='Run docker build')
    p.set_defaults(command=lambda args: subprocess.call(docker_run_command(
        args.build_root, args.docker_command, args.runtime, interactive=True)))
    p.add_argument('build_root', help='A docker build root folder')
    p.add_argument('docker_command', help='A docker container command',
                   metavar='command', nargs=argparse.REMAINDER)
    p.add_argument('-r', '--runtime', help='A docker image runtime',
                   default='python3.8')

    p = hidden_parser('docker-image', help='Run docker build')
    p.set_defaults(command=lambda args: subprocess.call(docker_build_command(
        args.build_root, args.docker_file, args.tag)))
    p.add_argument('-t', '--tag', help='A docker image tag')
    p.add_argument('build_root', help='A docker build root folder')
    p.add_argument('docker_file', help='A docker file path',
                   nargs=argparse.OPTIONAL)

    def zip_cmd(args):
        if args.verbose:
            logger.setLevel(logging.DEBUG)
        with ZipWriteStream(args.zipfile) as zs:
            zs.write_dirs(*args.dir, timestamp=args.timestamp)
        if logger.isEnabledFor(logging.DEBUG):
            zipinfo = shutil.which('zipinfo')
            if zipinfo:
                logger.debug('-' * 80)
                subprocess.call([zipinfo, args.zipfile])
            logger.debug('-' * 80)
            logger.debug('Source code hash: %s',
                         source_code_hash(open(args.zipfile, 'rb').read()))

    p = hidden_parser('zip', help='Zip folder with provided files timestamp')
    p.set_defaults(command=zip_cmd)
    p.add_argument('zipfile', help='Path to a zip file')
    p.add_argument('dir', nargs=argparse.ONE_OR_MORE,
                   help='Path to a directory for packaging')
    p.add_argument('-t', '--timestamp', type=int,
                   help='A timestamp to override for all zip members')
    p.add_argument('-v', '--verbose', action='store_true')

    p = hidden_parser('hash', help='Generate content hash for a file')
    p.set_defaults(
        command=lambda args: print(source_code_hash(args.file.read())))
    p.add_argument('file', help='Path to a file', type=argparse.FileType('rb'))


def args_parser():
    ap = argparse.ArgumentParser()
    ap.set_defaults(command=lambda _: ap.print_usage())
    sp = ap.add_subparsers(metavar="COMMAND")

    p = sp.add_parser('prepare',
                      help='compute a filename hash for a zip archive')
    p.set_defaults(command=prepare_command)

    p = sp.add_parser('build',
                      help='build and pack to a zip archive')
    p.set_defaults(command=build_command)
    p.add_argument('--force', action='store_true',
                   help='Force rebuilding even if a zip artifact exists')
    p.add_argument('-t', '--timestamp',
                   dest='zip_file_timestamp', required=True,
                   help='A zip file timestamp generated by the prepare command')
    p.add_argument('build_plan_file', metavar='PLAN_FILE',
                   help='A build plan file provided by the prepare command')
    add_hidden_commands(sp)
    return ap


def main():
    ns = argparse.Namespace(
        recreate_missing_package=os.environ.get(
            'TF_RECREATE_MISSING_LAMBDA_PACKAGE', True),
        log_level=os.environ.get('TF_LAMBDA_PACKAGE_LOG_LEVEL', 'INFO'),
    )
    p = args_parser()
    args = p.parse_args(namespace=ns)

    if args.command is prepare_command:
        configure_logging(use_tf_stderr=True)
    else:
        configure_logging()

    if args.log_level:
        ll = logging._nameToLevel.get(args.log_level)
        if ll and logging._checkLevel(ll):
            logging.root.setLevel(args.log_level)

    exit(args.command(args))


if __name__ == '__main__':
    main()
