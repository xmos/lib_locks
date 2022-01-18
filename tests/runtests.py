#!/usr/bin/env python
# Copyright 2016-2021 XMOS LIMITED.
# This Software is subject to the terms of the XMOS Public Licence: Version 1.
import xmostest

if __name__ == "__main__":
    xmostest.init()

    xmostest.register_group("lib_locks",
                            "locks_sim_tests",
                            "Locks library simulator tests",
    """
Test some of the basic functionality of the locks library.
""")

    xmostest.runtests()

    xmostest.finish()
