import os
from pathlib import Path
from unittest.mock import MagicMock, Mock

import pytest

from package import BuildPlanManager, ZipContentFilter, datatree


def test_zip_source_path_sh_work_dir():
    zs = Mock()
    zs.write_dirs = MagicMock()

    bpm = BuildPlanManager(args=Mock())

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


@pytest.fixture
def source_path(tmp_path: str) -> Path:
    """Creates a tmp stage dir for running tests."""
    tmp_path = Path(tmp_path)
    source = tmp_path / "some_dir"
    source.mkdir()
    for files in ["file.py", "file2.py", "README.md", "requirements.txt"]:
        (source / files).touch()
    yield source


def test_zip_content_filter(source_path: Path):
    """Test the zip content filter does not take all positive."""
    args = Mock()
    query_data = {
        "runtime": "python",
        "source_path": {
            "path": str(source_path),
            "patterns": [".*.py$"],
        },
    }
    query = datatree("prepare_query", **query_data)

    file_filter = ZipContentFilter(args=args)
    file_filter.compile(query.source_path.patterns)
    filtered = list(file_filter.filter(query.source_path.path))
    expected = [str(source_path / fname) for fname in ["file.py", "file2.py"]]
    assert filtered == sorted(expected)

    # Test that filtering with empty patterns returns all files.
    file_filter = ZipContentFilter(args=args)
    file_filter.compile([])
    filtered = list(file_filter.filter(query.source_path.path))
    expected = [
        str(source_path / fname)
        for fname in ["file.py", "file2.py", "README.md", "requirements.txt"]
    ]
    assert filtered == sorted(expected)


def test_generate_hash(source_path: Path):
    """Tests prepare hash generation and also packaging."""
    args = Mock()

    query_data = {
        "runtime": "python",
        "source_path": {
            "path": str(source_path),
            "patterns": ["!.*", ".*.py$"],
        },
    }
    query = datatree("prepare_query", **query_data)

    bpm = BuildPlanManager(args)
    bpm.plan(query.source_path, query)
    hash1 = bpm.hash([]).hexdigest()

    # Add a new file that does not match the pattern.
    (source_path / "file3.pyc").touch()
    bpm.plan(query.source_path, query)
    hash2 = bpm.hash([]).hexdigest()
    # Both hashes should still be the same.
    assert hash1 == hash2

    # Add a new file that does match the pattern.
    (source_path / "file4.py").touch()
    bpm.plan(query.source_path, query)
    hash3 = bpm.hash([]).hexdigest()
    # Hash should be different.
    assert hash1 != hash3
