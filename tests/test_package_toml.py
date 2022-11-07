from package import get_build_system_from_pyproject_toml


def test_get_build_system_from_pyproject_toml_inexistent():
    assert (
        get_build_system_from_pyproject_toml("fixtures/inexistent/pyproject.toml")
        is None
    )


def test_get_build_system_from_pyproject_toml_unknown():
    assert (
        get_build_system_from_pyproject_toml("fixtures/pyproject-unknown.toml") is None
    )


def test_get_build_system_from_pyproject_toml_poetry():
    assert (
        get_build_system_from_pyproject_toml(
            "examples/fixtures/python3.9-app-poetry/pyproject.toml"
        )
        == "poetry"
    )
