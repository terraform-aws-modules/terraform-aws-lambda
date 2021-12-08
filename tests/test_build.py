import subprocess

import pytest

import package


def test_failing_build_command(capsys):
    args = package.parse_args(
        ["build","--force", "-t", "timestamp", "fixtures/build_failing_command.json"]
    )
    with pytest.raises(subprocess.CalledProcessError):
        package.build_command(args)
