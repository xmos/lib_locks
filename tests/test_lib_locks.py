# Copyright 2023-2024 XMOS LIMITED.
# This Software is subject to the terms of the XMOS Public Licence: Version 1.
"""
Runs tests for both hardware and software locks
"""
from subprocess import run
from pathlib import Path
import pytest
import os
import shutil


@pytest.fixture(scope="session", params=("XCORE-AI-EXPLORER", "XCORE-200-EXPLORER"))
def target(request):
    this_target = request.param
    cwd = Path(__file__).parent / "locks_test"
    xmake_env = dict(**os.environ)
    xmake_env["TARGET"] = this_target
    run(["xmake"], check=True, env=xmake_env, cwd=cwd)

    # need to delete .build_* dirs when using multiple targets
    for d in cwd.glob(".build_*"):
        shutil.rmtree(d)
    return this_target


@pytest.mark.parametrize("lock_type", ("HW", "SW"))
def test_lib_locks(lock_type, target):
    expected_output = (Path(__file__).parent / "locks.expect").read_text().strip()
    xe_path = (
        Path(__file__).parent
        / "locks_test"
        / "bin"
        / lock_type
        / f"{target}_{lock_type}.xe"
    )
    res = run(["xsim", str(xe_path)], capture_output=True, text=True, check=True)

    assert (
        expected_output == res.stdout.strip()
    ), "Output of app did not match expected result"
