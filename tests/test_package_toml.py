from package import get_build_system_from_pyproject_toml, BuildPlanManager
from pytest import raises
from unittest.mock import Mock


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
            build_plan=[[["sh", "/tmp", "NOTACOMMAND"]]],
            zip_stream=None,
            query=None,
        )


def test_get_build_system_from_pyproject_toml_poetry():
    assert (
        get_build_system_from_pyproject_toml(
            "examples/fixtures/python-app-poetry/pyproject.toml"
        )
        == "poetry"
    )
