import os
from unittest.mock import MagicMock, Mock, patch

from package import BuildPlanManager


def test_sh_with_docker_basic():
    """Test shell commands execute in Docker when query.docker is set"""
    import subprocess

    zs = Mock()
    zs.write_dirs = MagicMock()

    # Mock query object with docker
    query = Mock()
    docker_mock = Mock()
    docker_mock.docker_image = "public.ecr.aws/lambda/python:3.12"
    docker_mock.with_ssh_agent = False
    docker_mock.docker_additional_options = None
    docker_mock.docker_entrypoint = None
    query.docker = docker_mock
    query.runtime = "python3.12"

    bpm = BuildPlanManager(args=Mock())

    # Mock subprocess functions
    with patch("package.check_output") as mock_check_output, patch(
        "package.subprocess.run"
    ) as mock_run:
        # Mock docker image ID lookup
        mock_check_output.return_value = b"sha256:abc123"

        # Mock successful docker execution with pwd output
        mock_result = Mock()
        mock_result.returncode = 0
        mock_result.stdout = "/var/task\n"
        mock_result.stderr = ""
        mock_run.return_value = mock_result

        bpm.execute(
            build_plan=[
                [
                    ["sh", "echo 'test command'"],
                    ["zip:embedded", ".", "."],
                ]
            ],
            zip_stream=zs,
            query=query,
        )

        # Verify docker run was called
        assert mock_run.called
        # Verify the command includes chown
        call_args = mock_run.call_args[0][0]
        assert any("chown" in str(arg) for arg in call_args)


def test_sh_with_docker_workdir_tracking():
    """Test working directory tracking when cd is used in Docker"""
    import subprocess
    import tempfile
    import shutil

    # Create a temporary directory for testing
    tmpdir = tempfile.mkdtemp()
    try:
        # Track the working directory by intercepting write_dirs call
        captured_workdir = []

        def capture_write_dirs(path, *args, **kwargs):
            captured_workdir.append(path)

        zs = Mock()
        zs.write_dirs = capture_write_dirs

        query = Mock()
        docker_mock = Mock()
        docker_mock.docker_image = "public.ecr.aws/lambda/python:3.12"
        docker_mock.with_ssh_agent = False
        docker_mock.docker_additional_options = None
        docker_mock.docker_entrypoint = None
        query.docker = docker_mock
        query.runtime = "python3.12"

        bpm = BuildPlanManager(args=Mock())

        # Create a subdirectory in tmpdir to test workdir tracking
        subdir = os.path.join(tmpdir, "subdir")
        os.makedirs(subdir, exist_ok=True)

        with patch("package.check_output") as mock_check_output, patch(
            "package.subprocess.run"
        ) as mock_run, patch("os.getcwd", return_value=tmpdir):
            mock_check_output.return_value = b"sha256:abc123"

            # Mock docker execution returning changed working directory
            mock_result = Mock()
            mock_result.returncode = 0
            mock_result.stdout = "/var/task/subdir\n"
            mock_result.stderr = ""
            mock_run.return_value = mock_result

            bpm.execute(
                build_plan=[
                    [
                        ["sh", "mkdir -p subdir && cd subdir"],
                        ["zip:embedded", ".", "."],
                    ]
                ],
                zip_stream=zs,
                query=query,
            )

            # Verify working directory was tracked and mapped from container to host
            assert len(captured_workdir) > 0
            assert "subdir" in captured_workdir[0]
    finally:
        shutil.rmtree(tmpdir, ignore_errors=True)


def test_sh_without_docker_unchanged():
    """Test shell commands still work on host when docker is not set"""
    zs = Mock()
    zs.write_dirs = MagicMock()

    # Query with no docker
    query = Mock()
    query.docker = None

    bpm = BuildPlanManager(args=Mock())

    # Should execute without errors using host execution
    bpm.execute(
        build_plan=[
            [
                ["sh", "echo 'host command'"],
                ["zip:embedded", ".", "."],
            ]
        ],
        zip_stream=zs,
        query=query,
    )

    zs.write_dirs.assert_called_once()


def test_sh_docker_error_handling():
    """Test error handling when Docker command fails"""
    import subprocess
    from pytest import raises

    zs = Mock()

    query = Mock()
    docker_mock = Mock()
    docker_mock.docker_image = "public.ecr.aws/lambda/python:3.12"
    docker_mock.with_ssh_agent = False
    docker_mock.docker_additional_options = None
    docker_mock.docker_entrypoint = None
    query.docker = docker_mock
    query.runtime = "python3.12"

    bpm = BuildPlanManager(args=Mock())

    with patch("package.check_output") as mock_check_output, patch(
        "package.subprocess.run"
    ) as mock_run:
        mock_check_output.return_value = b"sha256:abc123"

        # Mock docker execution failure
        mock_result = Mock()
        mock_result.returncode = 1
        mock_result.stdout = ""
        mock_result.stderr = "Command failed"
        mock_run.return_value = mock_result

        with raises(RuntimeError, match="Script did not run successfully in docker"):
            bpm.execute(
                build_plan=[
                    [
                        ["sh", "false"],
                    ]
                ],
                zip_stream=zs,
                query=query,
            )


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
