# coding: utf-8

import sys

if sys.version_info < (3, 6):
    raise RuntimeError("A python version 3.6 or newer is required")

import os
import re
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
import operator
import platform
import subprocess
from subprocess import check_call, check_output
from contextlib import contextmanager
from base64 import b64encode
import logging

PY38 = sys.version_info >= (3, 8)
PY37 = sys.version_info >= (3, 7)
PY36 = sys.version_info >= (3, 6)

WINDOWS = platform.system() == 'Windows'
OSX = platform.system() == 'Darwin'

################################################################################
# Logging

DEBUG2 = 9
DEBUG3 = 8
DUMP_ENV = 1

log_handler = None
log = logging.getLogger()
cmd_log = logging.getLogger('cmd')


def configure_logging(use_tf_stderr=False):
    global log_handler

    logging.addLevelName(DEBUG2, 'DEBUG2')
    logging.addLevelName(DEBUG3, 'DEBUG3')
    logging.addLevelName(DUMP_ENV, 'DUMP_ENV')

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

    log.addHandler(log_handler)
    log.setLevel(logging.INFO)


def dump_env():
    if log.isEnabledFor(DUMP_ENV):
        log.debug('ENV: %s', json.dumps(dict(os.environ), indent=2))


################################################################################
# Backports

def shlex_join(split_command):
    """Return a shell-escaped string from *split_command*."""
    return ' '.join(shlex.quote(arg) for arg in split_command)


################################################################################
# Common functions

def abort(message):
    """Exits with an error message."""
    log.error(message)
    sys.exit(1)


@contextmanager
def cd(path, silent=False):
    """Changes the working directory."""
    cwd = os.getcwd()
    if not silent:
        cmd_log.info('cd %s', shlex.quote(path))
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
    cmd_log.info('mktemp -d %sXXXXXXXX # %s', prefix, shlex.quote(path))
    try:
        yield path
    finally:
        shutil.rmtree(path)


def list_files(top_path, log=None):
    """
    Returns a sorted list of all files in a directory.
    """

    if log:
        log = log.getChild('ls')

    results = []

    for root, dirs, files in os.walk(top_path):
        for file_name in files:
            file_path = os.path.join(root, file_name)
            relative_path = os.path.relpath(file_path, top_path)
            results.append(relative_path)
            if log:
                log.debug(relative_path)

    results.sort()
    return results


def dataclass(name):
    typ = type(name, (dict,), {
        '__getattr__': lambda self, x: self.get(x),
        '__init__': lambda self, **k: self.update(k),
    })
    return typ


def datatree(name, **fields):
    def decode_json(k, v):
        if v and isinstance(v, str) and v[0] in '"[{':
            try:
                o = json.loads(v)
                if isinstance(o, dict):
                    return dataclass(k)(**o)
                return o
            except json.JSONDecodeError:
                pass
        return v

    return dataclass(name)(**dict(((
        k, datatree(k, **v) if isinstance(v, dict) else decode_json(k, v))
        for k, v in fields.items())))


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
                          hash_func=hashlib.sha256, log=None):
    """
    Generate a content hash of the source paths.
    """

    if log:
        log = log.getChild('hash')

    hash_obj = hash_func()

    for source_path in source_paths:
        if os.path.isdir(source_path):
            source_dir = source_path
            _log = log if log.isEnabledFor(DEBUG3) else None
            for source_file in list_files(source_dir, log=_log):
                update_hash(hash_obj, source_dir, source_file)
                if log:
                    log.debug(os.path.join(source_dir, source_file))
        else:
            source_dir = os.path.dirname(source_path)
            source_file = os.path.relpath(source_path, source_dir)
            update_hash(hash_obj, source_dir, source_file)
            if log:
                log.debug(source_path)

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

        self._log = logging.getLogger('zip')

    def open(self):
        if self._tmp_filename:
            raise zipfile.BadZipFile("ZipStream object can't be reused")
        self._ensure_base_path(self.filename)
        self._tmp_filename = '{}.tmp'.format(self.filename)
        self._log.info("creating '%s' archive", self.filename)
        self._zip = zipfile.ZipFile(self._tmp_filename, "w",
                                    self._compress_type)
        return self

    def close(self, failed=False):
        self._zip.close()
        self._zip = None
        if failed:
            os.unlink(self._tmp_filename)
        else:
            os.replace(self._tmp_filename, self.filename)

    def __enter__(self):
        return self.open()

    def __exit__(self, exc_type, exc_val, exc_tb):
        if exc_type is not None:
            self._log.exception("Error during zip archive creation")
            self.close(failed=True)
            raise SystemExit(1)
        self.close()

    def _ensure_open(self):
        if self._zip is not None:
            return True
        if self._tmp_filename:
            raise zipfile.BadZipFile("ZipWriteStream object can't be reused")
        raise zipfile.BadZipFile('ZipWriteStream should be opened first')

    def _ensure_base_path(self, zip_filename):
        archive_dir = os.path.dirname(zip_filename)

        if archive_dir and not os.path.exists(archive_dir):
            self._log.info("creating %s", archive_dir)
            os.makedirs(archive_dir)

    def write_dirs(self, *base_dirs, prefix=None, timestamp=None):
        """
        Writes a directory content to a prefix inside of a zip archive
        """
        self._ensure_open()
        for base_dir in base_dirs:
            self._log.info("adding content of directory: %s", base_dir)
            for path in emit_dir_content(base_dir):
                arcname = os.path.relpath(path, base_dir)
                self._write_file(path, prefix, arcname, timestamp)

    def write_files(self, files_stream, prefix=None, timestamp=None):
        """
        Expects just files stream, directories will be created automatically
        """
        self._ensure_open()
        for file_path, arcname in files_stream:
            self._write_file(file_path, prefix, arcname, timestamp)

    def write_file(self, file_path, prefix=None, name=None, timestamp=None):
        """
        Reads a file and writes it to a prefix
        or a full qualified name in a zip archive
        """
        self._ensure_open()
        self._write_file(file_path, prefix, name, timestamp)

    def _write_file(self, file_path, prefix=None, name=None, timestamp=None):
        arcname = name if name else os.path.basename(file_path)
        if prefix:
            arcname = os.path.join(prefix, arcname)
        zinfo = self._make_zinfo_from_file(file_path, arcname)
        if zinfo.is_dir():
            self._log.info("adding: %s/", arcname)
        else:
            self._log.info("adding: %s", arcname)
        if timestamp is None:
            timestamp = self.timestamp
        date_time = self._timestamp_to_date_time(timestamp)
        if date_time:
            self._update_zinfo(zinfo, date_time=date_time)
        self._write_zinfo(zinfo, file_path)

    def write_file_obj(self, file_path, data, prefix=None, timestamp=None):
        """
        Write a data to a zip archive by a full qualified archive file path
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

            if PY37:
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
        if strict_timestamps and date_time[0] < 1980:
            date_time = (1980, 1, 1, 0, 0, 0)
        elif strict_timestamps and date_time[0] > 2107:
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

def patterns_list(args, patterns):
    _filter = str.strip
    if args.pattern_comments:
        def _filter(x):
            x = x.strip()
            p = re.search("^(.*?)[ \t]*(?:[ \t]{2}#.*)?$", x).group(1).rstrip()
            if p.startswith('#'):
                return
            if p:
                return p
    if isinstance(patterns, str):
        return list(filter(None, map(_filter, patterns.splitlines())))
    return patterns


class ZipContentFilter:
    """"""

    def __init__(self, args):
        self._args = args
        self._rules = None
        self._excludes = set()
        self._log = logging.getLogger('zip')

    def compile(self, patterns):
        rules = []
        for p in patterns_list(self._args, patterns):
            self._log.debug("filter pattern: %s", p)
            if p.startswith('!'):
                r = re.compile(p[1:])
                rules.append((operator.not_, r))
            else:
                r = re.compile(p)
                rules.append((None, r))
        self._rules = rules

    def filter(self, path, prefix=None):
        path = os.path.normpath(path)
        if prefix:
            prefix = os.path.normpath(prefix)
        rules = self._rules

        def norm_path(path, root, filename=None):
            op = os.path.join(root, filename) if filename else root
            p = os.path.relpath(root, path)
            if prefix:
                p = os.path.join(prefix, p)
            if filename:
                p = os.path.normpath(os.path.join(p, filename))
                return op, p
            return op, p + os.sep

        def apply(path):
            d = True
            for r in rules:
                op, regex = r
                neg = op is operator.not_
                m = regex.fullmatch(path)
                if neg and m:
                    d = False
                elif m:
                    d = True
            if d:
                return path

        def emit_dir(dpath, opath):
            if apply(dpath):
                yield opath
            else:
                self._log.debug('skip:   %s', dpath)

        def emit_file(fpath, opath):
            if apply(fpath):
                yield opath
            else:
                self._log.debug('skip:   %s', fpath)

        if os.path.isfile(path):
            name = os.path.basename(path)
            if prefix:
                name = os.path.join(prefix, name)
            if apply(name):
                yield path
        else:
            for root, dirs, files in os.walk(path):
                o, d = norm_path(path, root)
                # log.info('od: %s %s', o, d)
                if root != path:
                    yield from emit_dir(d, o)
                for name in files:
                    o, f = norm_path(path, root, name)
                    # log.info('of: %s %s', o, f)
                    yield from emit_file(f, o)


class BuildPlanManager:
    """"""

    def __init__(self, args, log=None):
        self._args = args
        self._source_paths = None
        self._log = log or logging.root

    def hash(self, extra_paths):
        if not self._source_paths:
            raise ValueError('BuildPlanManager.plan() should be called first')

        content_hash_paths = self._source_paths + extra_paths

        # Generate a hash based on file names and content. Also use the
        # runtime value, build command, and content of the build paths
        # because they can have an effect on the resulting archive.
        self._log.debug("Computing content hash on files...")
        content_hash = generate_content_hash(content_hash_paths,
                                             log=self._log)
        return content_hash

    def plan(self, source_path, query):
        claims = source_path
        if not isinstance(source_path, list):
            claims = [source_path]

        source_paths = []
        build_plan = []

        step = lambda *x: build_plan.append(x)
        hash = source_paths.append

        def pip_requirements_step(path, prefix=None, required=False):
            requirements = path
            if os.path.isdir(path):
                requirements = os.path.join(path, 'requirements.txt')
            if not os.path.isfile(requirements):
                if required:
                    raise RuntimeError(
                        'File not found: {}'.format(requirements))
            else:
                step('pip', runtime, requirements, prefix)
                hash(requirements)

        def commands_step(path, commands):
            if not commands:
                return

            if isinstance(commands, str):
                commands = map(str.strip, commands.splitlines())

            if path:
                path = os.path.normpath(path)
            batch = []
            for c in commands:
                if isinstance(c, str):
                    if c.startswith(':zip'):
                        if path:
                            hash(path)
                        else:
                            # If path doesn't defined for a block with
                            # commands it will be set to Terraform's
                            # current working directory
                            path = query.paths.cwd
                        if batch:
                            step('sh', path, '\n'.join(batch))
                            batch.clear()
                        c = shlex.split(c)
                        if len(c) == 3:
                            _, _path, prefix = c
                            prefix = prefix.strip()
                            _path = os.path.normpath(os.path.join(path, _path))
                            step('zip:embedded', _path, prefix)
                        elif len(c) == 2:
                            prefix = None
                            _, _path = c
                            step('zip:embedded', _path, prefix)
                        elif len(c) == 1:
                            prefix = None
                            step('zip:embedded', path, prefix)
                        else:
                            raise ValueError(
                                ":zip invalid call signature, use: "
                                "':zip [path [prefix_in_zip]]'")
                    else:
                        batch.append(c)

        for claim in claims:
            if isinstance(claim, str):
                path = claim
                if not os.path.exists(path):
                    abort('source_path must be set.')
                runtime = query.runtime
                if runtime.startswith('python'):
                    pip_requirements_step(
                        os.path.join(path, 'requirements.txt'))
                step('zip', path, None)
                hash(path)

            elif isinstance(claim, dict):
                path = claim.get('path')
                patterns = claim.get('patterns')
                commands = claim.get('commands')
                if patterns:
                    step('set:filter', patterns_list(self._args, patterns))
                if commands:
                    commands_step(path, commands)
                else:
                    prefix = claim.get('prefix_in_zip')
                    pip_requirements = claim.get('pip_requirements')
                    runtime = claim.get('runtime', query.runtime)

                    if pip_requirements and runtime.startswith('python'):
                        if isinstance(pip_requirements, bool) and path:
                            pip_requirements_step(path, prefix, required=True)
                        else:
                            pip_requirements_step(pip_requirements, prefix,
                                                  required=True)
                    if path:
                        step('zip', path, prefix)
                        hash(path)
                if patterns:
                    step('clear:filter')
            else:
                raise ValueError(
                    'Unsupported source_path item: {}'.format(claim))

        self._source_paths = source_paths
        return build_plan

    def execute(self, build_plan, zip_stream, query):
        zs = zip_stream
        sh_work_dir = None
        pf = None

        for action in build_plan:
            cmd = action[0]
            if cmd.startswith('zip'):
                ts = 0 if cmd == 'zip:embedded' else None
                source_path, prefix = action[1:]
                if sh_work_dir:
                    if source_path != sh_work_dir:
                        if not os.path.isfile(source_path):
                            source_path = sh_work_dir
                if os.path.isdir(source_path):
                    if pf:
                        self._zip_write_with_filter(zs, pf, source_path, prefix,
                                                    timestamp=ts)
                    else:
                        zs.write_dirs(source_path, prefix=prefix, timestamp=ts)
                else:
                    zs.write_file(source_path, prefix=prefix, timestamp=ts)
            elif cmd == 'pip':
                runtime, pip_requirements, prefix = action[1:]
                with install_pip_requirements(query, pip_requirements) as rd:
                    if rd:
                        if pf:
                            self._zip_write_with_filter(zs, pf, rd, prefix,
                                                        timestamp=0)
                        else:
                            # XXX: timestamp=0 - what actually do with it?
                            zs.write_dirs(rd, prefix=prefix, timestamp=0)
            elif cmd == 'sh':
                r, w = os.pipe()
                side_ch = os.fdopen(r)
                path, script = action[1:]
                script = "{}\npwd >&{}".format(script, w)

                p = subprocess.Popen(script, shell=True, cwd=path,
                                     pass_fds=(w,))
                os.close(w)
                sh_work_dir = side_ch.read().strip()
                p.wait()
                log.info('WD: %s', sh_work_dir)
                side_ch.close()
            elif cmd == 'set:filter':
                patterns = action[1]
                pf = ZipContentFilter(args=self._args)
                pf.compile(patterns)
            elif cmd == 'clear:filter':
                pf = None

    @staticmethod
    def _zip_write_with_filter(zip_stream, path_filter, source_path, prefix,
                               timestamp=None):
        for path in path_filter.filter(source_path, prefix):
            if os.path.isdir(source_path):
                arcname = os.path.relpath(path, source_path)
            else:
                arcname = os.path.basename(path)
            zip_stream.write_file(path, prefix, arcname, timestamp=timestamp)


@contextmanager
def install_pip_requirements(query, requirements_file):
    # TODO:
    #  1. Emit files instead of temp_dir

    if not os.path.exists(requirements_file):
        yield
        return

    runtime = query.runtime
    artifacts_dir = query.artifacts_dir
    docker = query.docker
    docker_image_tag_id = None

    if docker:
        docker_file = docker.docker_file
        docker_image = docker.docker_image
        docker_build_root = docker.docker_build_root

        if docker_image:
            ok = False
            while True:
                output = check_output(docker_image_id_command(docker_image))
                if output:
                    docker_image_tag_id = output.decode().strip()
                    log.debug("DOCKER TAG ID: %s -> %s",
                              docker_image, docker_image_tag_id)
                    ok = True
                if ok:
                    break
                docker_cmd = docker_build_command(
                    build_root=docker_build_root,
                    docker_file=docker_file,
                    tag=docker_image,
                )
                check_call(docker_cmd)
                ok = True
        elif docker_file or docker_build_root:
            raise ValueError('docker_image must be specified '
                             'for a custom image future references')

    working_dir = os.getcwd()

    log.info('Installing python requirements: %s', requirements_file)
    with tempdir() as temp_dir:
        requirements_filename = os.path.basename(requirements_file)
        target_file = os.path.join(temp_dir, requirements_filename)
        shutil.copyfile(requirements_file, target_file)

        python_exec = runtime
        subproc_env = None

        if not docker:
            if WINDOWS:
                python_exec = 'python.exe'
            elif OSX:
                # Workaround for OSX when XCode command line tools'
                # python becomes the main system python interpreter
                os_path = '{}:/Library/Developer/CommandLineTools' \
                          '/usr/bin'.format(os.environ['PATH'])
                subproc_env = os.environ.copy()
                subproc_env['PATH'] = os_path

        # Install dependencies into the temporary directory.
        with cd(temp_dir):
            pip_command = [
                python_exec, '-m', 'pip',
                'install', '--no-compile',
                '--prefix=', '--target=.',
                '--requirement={}'.format(requirements_filename),
            ]
            if docker:
                with_ssh_agent = docker.with_ssh_agent
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
                    '.', shell_command, runtime,
                    image=docker_image_tag_id,
                    shell=True, ssh_agent=with_ssh_agent,
                    pip_cache_dir=pip_cache_dir,
                ))
            else:
                cmd_log.info(shlex_join(pip_command))
                log_handler and log_handler.flush()
                try:
                    check_call(pip_command, env=subproc_env)
                except FileNotFoundError as e:
                    raise RuntimeError(
                        "Python interpreter version equal "
                        "to defined lambda runtime ({}) should be "
                        "available in system PATH".format(runtime)
                    ) from e

            os.remove(target_file)
            yield temp_dir


def docker_image_id_command(tag):
    """"""
    docker_cmd = ['docker', 'images', '--format={{.ID}}', tag]
    cmd_log.info(shlex_join(docker_cmd))
    log_handler and log_handler.flush()
    return docker_cmd


def docker_build_command(tag=None, docker_file=None, build_root=False):
    """"""
    if not (build_root or docker_file):
        raise ValueError('docker_build_root or docker_file must be provided')

    docker_cmd = ['docker', 'build']

    if tag:
        docker_cmd.extend(['--tag', tag])
    else:
        raise ValueError('docker_image must be specified')
    if not build_root:
        build_root = os.path.dirname(docker_file)
    if docker_file:
        docker_cmd.extend(['--file', docker_file])
    docker_cmd.append(build_root)

    cmd_log.info(shlex_join(docker_cmd))
    log_handler and log_handler.flush()
    return docker_cmd


def docker_run_command(build_root, command, runtime,
                       image=None, shell=None, ssh_agent=False,
                       interactive=False, pip_cache_dir=None):
    """"""
    if platform.system() not in ('Linux', 'Darwin'):
        raise RuntimeError("Unsupported platform for docker building")

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

    if ssh_agent:
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

    if platform.system() == 'Linux':
        if pip_cache_dir:
            pip_cache_dir = os.path.abspath(pip_cache_dir)
            docker_cmd.extend([
                '-v', '{}:/root/.cache/pip:z'.format(pip_cache_dir),
            ])

    if not image:
        image = 'lambci/lambda:build-{}'.format(runtime)

    docker_cmd.append(image)

    assert isinstance(command, list)
    if shell:
        if not isinstance(shell, str):
            shell = '/bin/sh'
        docker_cmd.extend([shell, '-c'])
    docker_cmd.extend(command)

    cmd_log.info(shlex_join(docker_cmd))
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

    log = logging.getLogger('prepare')

    # Load the query.
    query_data = json.load(sys.stdin)

    dump_env()
    if log.isEnabledFor(DEBUG2):
        if log.isEnabledFor(DEBUG3):
            log.debug('QUERY: %s', json.dumps(query_data, indent=2))
        else:
            log_excludes = ('source_path', 'hash_extra_paths', 'paths')
            qd = {k: v for k, v in query_data.items() if k not in log_excludes}
            log.debug('QUERY (excerpt): %s', json.dumps(qd, indent=2))

    query = datatree('prepare_query', **query_data)

    tf_paths = query.paths
    runtime = query.runtime
    function_name = query.function_name
    artifacts_dir = query.artifacts_dir
    hash_extra_paths = query.hash_extra_paths
    source_path = query.source_path
    hash_extra = query.hash_extra
    recreate_missing_package = yesno_bool(args.recreate_missing_package)
    docker = query.docker

    bpm = BuildPlanManager(args, log=log)
    build_plan = bpm.plan(source_path, query)

    if log.isEnabledFor(DEBUG2):
        log.debug('BUILD_PLAN: %s', json.dumps(build_plan, indent=2))

    # Expand a Terraform path.<cwd|root|module> references
    hash_extra_paths = [p.format(path=tf_paths) for p in hash_extra_paths]

    content_hash = bpm.hash(hash_extra_paths)
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
        'artifacts_dir': artifacts_dir,
        'build_plan': build_plan,
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

    log = logging.getLogger('build')

    dump_env()
    if log.isEnabledFor(DEBUG2):
        log.debug('CMD: python3 %s', shlex_join(sys.argv))

    with open(args.build_plan_file) as f:
        query_data = json.load(f)
    query = datatree('build_query', **query_data)

    runtime = query.runtime
    filename = query.filename
    build_plan = query.build_plan
    _timestamp = args.zip_file_timestamp

    timestamp = 0
    if _timestamp.isnumeric():
        timestamp = int(_timestamp)

    if os.path.exists(filename) and not args.force:
        log.info('Reused: %s', shlex.quote(filename))
        return

    # Zip up the build plan and write it to the target filename.
    # This will be used by the Lambda function as the source code package.
    with ZipWriteStream(filename) as zs:
        bpm = BuildPlanManager(args, log=log)
        bpm.execute(build_plan, zs, query)

    os.utime(filename, ns=(timestamp, timestamp))
    log.info('Created: %s', shlex.quote(filename))
    if log.isEnabledFor(logging.DEBUG):
        with open(filename, 'rb') as f:
            log.info('Base64sha256: %s', source_code_hash(f.read()))


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
            log.setLevel(logging.DEBUG)
        with ZipWriteStream(args.zipfile) as zs:
            zs.write_dirs(*args.dir, timestamp=args.timestamp)
        if log.isEnabledFor(logging.DEBUG):
            zipinfo = shutil.which('zipinfo')
            if zipinfo:
                log.debug('-' * 80)
                subprocess.call([zipinfo, args.zipfile])
            log.debug('-' * 80)
            log.debug('Source code hash: %s',
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
        pattern_comments=yesno_bool(os.environ.get(
            'TF_LAMBDA_PACKAGE_PATTERN_COMMENTS', False)),
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
