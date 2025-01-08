import os
from unittest.mock import MagicMock, Mock

from package import BuildPlanManager


def test_zip_source_path_sh_work_dir():
    zs = Mock()
    zs.write_dirs = MagicMock()

    bpm = BuildPlanManager(args=Mock())

    bpm.execute(
        build_plan=[
            [
                ["sh", "cd $(mktemp -d)\n echo pip install"],
                ["zip:embedded", ".", "./python"],
            ]
        ],
        zip_stream=zs,
        query=None,
    )

    zs.write_dirs.assert_called_once()

    zip_source_path = zs.write_dirs.call_args_list[0][0][0]
    assert zip_source_path != f"{os.getcwd()}"


def test_zip_source_path():
    zs = Mock()
    zs.write_dirs = MagicMock()

    bpm = BuildPlanManager(args=Mock())

    bpm.execute(
        build_plan=[
            [
                ["sh", "echo pip install"],
                ["zip:embedded", ".", "./python"],
            ]
        ],
        zip_stream=zs,
        query=None,
    )

    zs.write_dirs.assert_called_once()

    zip_source_path = zs.write_dirs.call_args_list[0][0][0]
    assert zip_source_path == f"{os.getcwd()}"
