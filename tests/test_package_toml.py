import os
from package import get_build_system_from_pyproject_toml, BuildPlanManager
from pytest import raises
from unittest.mock import MagicMock, Mock


def test_get_build_system_from_pyproject_toml_inexistent():
    assert (
        get_build_system_from_pyproject_toml("fixtures/inexistent/pyproject.toml")
        is None
    )


def test_get_build_system_from_pyproject_toml_unknown():
    assert (
        get_build_system_from_pyproject_toml("fixtures/pyproject-unknown.toml") is None
    )


def test_build_manager_sucess_command():
    bpm = BuildPlanManager(args=Mock())
    # Should not have exception raised
    bpm.execute(build_plan=[["sh", "/tmp", "pwd"]], zip_stream=None, query=None)


def test_build_manager_failing_command():
    bpm = BuildPlanManager(args=Mock())
    with raises(Exception):
        bpm.execute(
            build_plan=[["sh", "/tmp", "NOTACOMMAND"]],
            zip_stream=None,
            query=None,
        )


def test_get_build_system_from_pyproject_toml_poetry():
    assert (
        get_build_system_from_pyproject_toml(
            "examples/fixtures/python3.9-app-poetry/pyproject.toml"
        )
        == "poetry"
    )


def test_zip_source_path_sh_work_dir():
    zs = Mock()
    zs.write_dirs = MagicMock()

    bpm = BuildPlanManager(args=Mock())
    bpm._zip_write_with_filter = MagicMock()

    bpm.execute(
        build_plan=[
            ["sh", ".", "cd $(mktemp -d)\n echo pip install"],
            ["zip:embedded", ".", "./python"],
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
    bpm._zip_write_with_filter = MagicMock()

    bpm.execute(
        build_plan=[
            ["sh", ".", "echo pip install"],
            ["zip:embedded", ".", "./python"],
        ],
        zip_stream=zs,
        query=None,
    )

    zs.write_dirs.assert_called_once()

    zip_source_path = zs.write_dirs.call_args_list[0][0][0]
    assert zip_source_path == f"{os.getcwd()}"
