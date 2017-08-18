#!/usr/bin/env python2.7
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
