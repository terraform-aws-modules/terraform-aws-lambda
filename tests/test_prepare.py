import json
import logging
import os

import package


def test_prepare(capsys, tmp_path):
    args = package.parse_args(["prepare"])
    fixture = json.load(open("fixtures/prepare_go_build.json"))

    os.chdir(tmp_path)

    (tmp_path / "Makefile").write_text("// Just a fake file")
    package._prepare_command(args, fixture, logging.getLogger(__name__))

    expected_output = {
        "filename": "builds/63feab8ff66c6a59333867ddf17c0d24d3cab828ad07d0b48c439af7034e4ac3.zip",
        "build_plan": '{"filename": "builds/63feab8ff66c6a59333867ddf17c0d24d3cab828ad07d0b48c439af7034e4ac3.zip", "runtime": "provided.al2", "artifacts_dir": "builds", "build_plan": [["sh", ".", "make LAMBDA=lambdas/my-lambda"], ["zip:embedded", "builds/lambdas/my-lambda/bootstrap", null]]}',
        "build_plan_filename": "builds/63feab8ff66c6a59333867ddf17c0d24d3cab828ad07d0b48c439af7034e4ac3.plan.json",
        "timestamp": "<WARNING: Missing lambda zip artifacts wouldn't be restored>",
        "was_missing": "false",
    }

    returned_output = json.loads(capsys.readouterr().out)
    assert expected_output == returned_output
