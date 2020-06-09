# coding: utf-8

import sys

if sys.version_info < (3, 7):
    raise RuntimeError("A python version 3.7 or newer is required")

import os
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
from subprocess import check_call, call
from contextlib import contextmanager
from base64 import b64encode
import logging


################################################################################
# Logging

class StderrLogFormatter(logging.Formatter):
    def formatMessage(self, record):
        self._style._fmt = self._style.default_format \
            if record.name == 'root' else self._fmt
        return super().formatMessage(record)


log_handler = logging.StreamHandler()
log_handler.setFormatter(StderrLogFormatter("%(name)s: %(message)s"))
logging.basicConfig(level=logging.INFO, handlers=(log_handler,))
logger = logging.getLogger()

cmd_logger = logging.getLogger('cmd')
cmd_log_handler = logging.StreamHandler()
cmd_log_handler.setFormatter(StderrLogFormatter("> %(message)s"))
cmd_logger.addHandler(cmd_log_handler)
cmd_logger.propagate = False


################################################################################
# Debug helpers

def dump_env(command_name):
    with open('{}.env'.format(command_name), 'a') as f:
        json.dump(dict(os.environ), f, indent=2)


def dump_query(command_name, query):
    with open('{}.query'.format(command_name), 'a') as f:
        json.dump(query, f, indent=2)


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


################################################################################
# Packaging functions

def emit_dir_files(base_dir):
    for root, dirs, files in os.walk(base_dir):
        if root != '.':
            yield os.path.normpath(root)
        for name in files:
            path = os.path.normpath(os.path.join(root, name))
            if os.path.isfile(path):
                yield path


def make_zipfile(zip_filename, *base_dirs, timestamp=None,
                 compression=zipfile.ZIP_DEFLATED):
    """
    Create a zip file from all the files under 'base_dir'.
    The output zip file will be named 'base_name' + ".zip".  Returns the
    name of the output zip file.
    """

    # An extended version of a write method
    # from the original zipfile.py library module
    def write(self, filename, arcname=None,
              compress_type=None, compresslevel=None,
              date_time=None):
        """Put the bytes from filename into the archive under the name
        arcname."""
        if not self.fp:
            raise ValueError(
                "Attempt to write to ZIP archive that was already closed")
        if self._writing:
            raise ValueError(
                "Can't write to ZIP archive while an open writing handle exists"
            )

        zinfo = zipfile.ZipInfo.from_file(
            filename, arcname, strict_timestamps=self._strict_timestamps)

        if date_time:
            zinfo.date_time = date_time

        if zinfo.is_dir():
            zinfo.compress_size = 0
            zinfo.CRC = 0
        else:
            if compress_type is not None:
                zinfo.compress_type = compress_type
            else:
                zinfo.compress_type = self.compression

            if compresslevel is not None:
                zinfo._compresslevel = compresslevel
            else:
                zinfo._compresslevel = self.compresslevel

        if zinfo.is_dir():
            with self._lock:
                if self._seekable:
                    self.fp.seek(self.start_dir)
                zinfo.header_offset = self.fp.tell()  # Start of header bytes
                if zinfo.compress_type == zipfile.ZIP_LZMA:
                    # Compressed data includes an end-of-stream (EOS) marker
                    zinfo.flag_bits |= 0x02

                self._writecheck(zinfo)
                self._didModify = True

                self.filelist.append(zinfo)
                self.NameToInfo[zinfo.filename] = zinfo
                self.fp.write(zinfo.FileHeader(False))
                self.start_dir = self.fp.tell()
        else:
            with open(filename, "rb") as src, self.open(zinfo, 'w') as dest:
                shutil.copyfileobj(src, dest, 1024 * 8)

    def str_int_to_timestamp(s):
        min_zip_ts = datetime.datetime(1980, 1, 1).timestamp()
        ts = int(s)
        if ts < min_zip_ts:
            return min_zip_ts
        deg = len(str(int(s))) - 9
        if deg < 0:
            ts = ts * 10 ** deg
        return ts

    logger = logging.getLogger('zip')

    date_time = None
    if timestamp is not None:
        if isinstance(timestamp, str):
            if timestamp.isnumeric():
                timestamp = str_int_to_timestamp(timestamp)
            else:
                timestamp = float(timestamp)
        elif isinstance(timestamp, int):
            timestamp = str_int_to_timestamp(str(timestamp))

        date_time = datetime.datetime.fromtimestamp(timestamp).timetuple()[:6]
        if date_time[0] < 1980:
            raise ValueError('ZIP does not support timestamps before 1980')

    archive_dir = os.path.dirname(zip_filename)

    if archive_dir and not os.path.exists(archive_dir):
        logger.info("creating %s", archive_dir)
        os.makedirs(archive_dir)

    logger.info("creating '%s' archive", zip_filename)

    with zipfile.ZipFile(zip_filename, "w", compression) as zf:
        for base_dir in base_dirs:
            logger.info("adding content of directory '%s'", base_dir)
            with cd(base_dir, silent=True):
                for path in emit_dir_files('.'):
                    logger.info("adding '%s'", path)
                    write(zf, path, path, date_time=date_time)
    return zip_filename


################################################################################
# Docker building

def docker_build_command(build_root, docker_file=None, tag=None):
    """"""
    docker_cmd = ['docker', 'build']
    if docker_file:
        docker_cmd.extend(['--file', docker_file])
    if tag:
        docker_cmd.extend(['--tag', tag])
    docker_cmd.append(build_root)

    logger.info(shlex_join(docker_cmd))
    log_handler.flush()
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

    logger.info(shlex_join(docker_cmd))
    log_handler.flush()
    return docker_cmd


################################################################################
# Commands

def prepare_command(args):
    """
    Generates a content hash of the source_path, which is used to determine if
    the Lambda code has changed, ignoring file modification and access times.

    Outputs a filename and a command to run if the archive needs to be built.
    """

    def list_files(top_path):
        """
        Returns a sorted list of all files in a directory.
        """

        results = []

        for root, dirs, files in os.walk(top_path):
            for file_name in files:
                results.append(os.path.join(root, file_name))

        results.sort()
        return results

    def generate_content_hash(source_paths):
        """
        Generate a content hash of the source paths.
        """

        sha256 = hashlib.sha256()

        for source_path in source_paths:
            if os.path.isdir(source_path):
                source_dir = source_path
                for source_file in list_files(source_dir):
                    update_hash(sha256, source_dir, source_file)
            else:
                source_dir = os.path.dirname(source_path)
                source_file = source_path
                update_hash(sha256, source_dir, source_file)

        return sha256

    def update_hash(hash_obj, file_root, file_path):
        """
        Update a hashlib object with the relative path and contents of a file.
        """

        relative_path = os.path.relpath(file_path, file_root)
        hash_obj.update(relative_path.encode())

        with open(file_path, 'rb') as open_file:
            while True:
                data = open_file.read(1024)
                if not data:
                    break
                hash_obj.update(data)

    args.dump_env and dump_env('prepare_command')

    # Load the query.
    query_data = json.load(sys.stdin)
    args.dump_input and dump_query('prepare_command', query_data)
    query = datatree('prepare_query', **query_data)

    tf_paths = query.paths
    runtime = query.runtime
    function_name = query.function_name
    artifacts_dir = query.artifacts_dir
    hash_extra_paths = query.hash_extra_paths
    source_path = query.source_path
    hash_extra = query.hash_extra

    # Compacting docker vars
    docker = query.docker
    if docker:
        docker = {k: v for k, v in docker.items() if v} or True

    # Validate the query.
    if not os.path.exists(source_path):
        abort('source_path must be set.')

    # Expand a Terraform path.<cwd|root|module> references
    content_hash_paths = [source_path] + hash_extra_paths
    content_hash_paths = [p.format(path=tf_paths) for p in content_hash_paths]

    # Generate a hash based on file names and content. Also use the
    # runtime value, build command, and content of the build paths
    # because they can have an effect on the resulting archive.
    content_hash = generate_content_hash(content_hash_paths)
    content_hash.update(runtime.encode())
    content_hash.update(hash_extra.encode())
    content_hash = content_hash.hexdigest()

    # Generate a unique filename based on the hash.
    filename = os.path.join(artifacts_dir, '{}.zip'.format(content_hash))

    # Compute timestamp trigger
    was_missing = False
    filename_path = os.path.join(os.getcwd(), filename)
    if os.path.exists(filename_path):
        st = os.stat(filename_path)
        timestamp = st.st_mtime_ns
    else:
        timestamp = timestamp_now_ns()
        was_missing = True

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

    def list_files(top_path):
        """
        Returns a sorted list of all files in a directory.
        """

        results = []

        for root, dirs, files in os.walk(top_path):
            for file_name in files:
                file_path = os.path.join(root, file_name)
                relative_path = os.path.relpath(file_path, top_path)
                results.append(relative_path)

        results.sort()
        return results

    def create_zip_file(source_dir, target_file):
        """
        Creates a zip file from a directory.
        """

        target_dir = os.path.dirname(target_file)
        if not os.path.exists(target_dir):
            os.makedirs(target_dir)
        make_zipfile(target_file, source_dir)

    args.dump_env and dump_env('build_command')

    args.dump_input and print(
        args.filename,
        args.runtime,
        args.source_path,
        file=open('build_command.args', 'a'))

    with open(args.build_plan_file) as f:
        query_data = json.load(f)
    query = datatree('build_query', **query_data)

    runtime = query.runtime
    filename = query.filename
    source_path = query.source_path

    timestamp = args.zip_file_timestamp
    artifacts_dir = query.artifacts_dir
    docker = query.docker

    if os.path.exists(filename):
        logger.info('Reused: %s', shlex.quote(filename))
        return

    working_dir = os.getcwd()

    # Create a temporary directory for building the archive,
    # so no changes will be made to the source directory.
    with tempdir() as temp_dir:
        # Find all source files.
        if os.path.isdir(source_path):
            source_dir = source_path
            source_files = list_files(source_path)
        else:
            source_dir = os.path.dirname(source_path)
            source_files = [os.path.basename(source_path)]

        # Copy them into the temporary directory.
        with cd(source_dir):
            for file_name in source_files:
                target_path = os.path.join(temp_dir, file_name)
                target_dir = os.path.dirname(target_path)
                if not os.path.exists(target_dir):
                    cmd_logger.info('mkdir -p %s', shlex.quote(target_dir))
                    os.makedirs(target_dir)
                cmd_logger.info('cp -t %s %s',
                                shlex.quote(target_dir),
                                shlex.quote(file_name))
                shutil.copyfile(file_name, target_path)
                shutil.copymode(file_name, target_path)
                shutil.copystat(file_name, target_path)

        # Install dependencies into the temporary directory.
        if runtime.startswith('python'):
            requirements = os.path.join(temp_dir, 'requirements.txt')
            if os.path.exists(requirements):
                with cd(temp_dir):
                    if runtime.startswith('python3'):
                        pip_command = ['pip3']
                    else:
                        pip_command = ['pip2']
                    pip_command.extend([
                        'install',
                        '--prefix=',
                        '--target=.',
                        '--requirement=requirements.txt',
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
                        log_handler.flush()
                        check_call(pip_command)

        # Zip up the temporary directory and write it to the target filename.
        # This will be used by the Lambda function as the source code package.
        create_zip_file(temp_dir, filename)
        os.utime(filename, ns=(timestamp, timestamp))
        logger.info('Created: %s', shlex.quote(filename))
        if logger.level <= logging.DEBUG:
            with open(filename, 'rb') as f:
                logger.info('Base64sha256: %s', source_code_hash(f.read()))


def add_hidden_commands(sub_parsers):
    sp = sub_parsers

    def hidden_parser(name, **kwargs):
        p = sp.add_parser(name, **kwargs)
        sp._choices_actions.pop()  # XXX: help=argparse.SUPPRESS - doesn't work
        return p

    p = hidden_parser('docker', help='Run docker build')
    p.set_defaults(command=lambda args: call(docker_run_command(
        args.build_root, args.docker_command, args.runtime, interactive=True)))
    p.add_argument('build_root', help='A docker build root folder')
    p.add_argument('docker_command', help='A docker container command',
                   metavar='command', nargs=argparse.REMAINDER)
    p.add_argument('-r', '--runtime', help='A docker image runtime',
                   default='python3.8')

    p = hidden_parser('docker-image', help='Run docker build')
    p.set_defaults(command=lambda args: call(docker_build_command(
        args.build_root, args.docker_file, args.tag)))
    p.add_argument('-t', '--tag', help='A docker image tag')
    p.add_argument('build_root', help='A docker build root folder')
    p.add_argument('docker_file', help='A docker file path',
                   nargs=argparse.OPTIONAL)

    def zip_cmd(args):
        make_zipfile(args.zipfile, *args.dir, timestamp=args.timestamp)
        logger.info('-' * 80)
        subprocess.call(['zipinfo', args.zipfile])
    p = hidden_parser('zip', help='Zip folder with provided files timestamp')
    p.set_defaults(command=zip_cmd)
    p.add_argument('zipfile', help='Path to a zip file')
    p.add_argument('dir', nargs=argparse.ONE_OR_MORE,
                   help='Path to a directory for packaging')
    p.add_argument('-t', '--timestamp', type=int,
                   help='A timestamp to override for all zip members')


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
    p.add_argument('-t', '--timestamp',
                   dest='zip_file_timestamp', type=int, required=True,
                   help='A zip file timestamp generated by the prepare command')
    p.add_argument('build_plan_file', metavar='PLAN_FILE',
                   help='A build plan file provided by the prepare command')
    add_hidden_commands(sp)
    return ap


def main():
    ns = argparse.Namespace(
        dump_input=bool(os.environ.get('TF_DUMP_INPUT')),
        dump_env=bool(os.environ.get('TF_DUMP_ENV')),
    )
    p = args_parser()
    args = p.parse_args(namespace=ns)
    exit(args.command(args))


if __name__ == '__main__':
    main()
