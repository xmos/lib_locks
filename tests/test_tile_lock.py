# Copyright 2023-2025 XMOS LIMITED.
# This Software is subject to the terms of the XMOS Public Licence: Version 1.
"""
Runs tests for both hardware and software locks
"""
from subprocess import run
from pathlib import Path
import pytest

def test_tile_locks():
    cwd = Path(__file__). parent / "build"
    xe_path = (
        Path(__file__).parent
        / "tile_lock_test_xs3"
        / "bin"
        / "tile_lock_test_xs3.xe"
    )

    res = run(["xrun", "--id", "0", "--io", xe_path], capture_output=True, text=True, check=True)
    test_pass = True
    for line in res.stdout.splitlines():
        print(line)
        if "FAIL" in line:
            test_pass = False
    
    assert test_pass, res.stdout
