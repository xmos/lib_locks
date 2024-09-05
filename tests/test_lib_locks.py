# Copyright 2023-2024 XMOS LIMITED.
# This Software is subject to the terms of the XMOS Public Licence: Version 1.
"""
Runs tests for both hardware and software locks
"""
from subprocess import run
from pathlib import Path
import pytest


@pytest.fixture(scope="session")
def cmake_configure():
    cwd = Path(__file__).parent
    run(["cmake", "-B", "build", "-G", "Unix Makefiles"], check=True)


@pytest.mark.parametrize("lock_type", ("HW", "SW"))
@pytest.mark.parametrize("target", ("xs2", "xs3"))
def test_lib_locks(cmake_configure, lock_type, target):
    cwd = Path(__file__). parent / "build"
    run(["xmake", f"locks_test_{target}_{lock_type}"], check=True, cwd=cwd)

    expected_output = (Path(__file__).parent / "locks.expect").read_text().strip()
    xe_path = (
        Path(__file__).parent
        / f"locks_test_{target}"
        / "bin"
        / lock_type
        / f"locks_test_{target}_{lock_type}.xe"
    )

    res = run(["xsim", xe_path], capture_output=True, text=True, check=True)
    assert (
        expected_output == res.stdout.strip()
    ), "Output of app did not match expected result"
