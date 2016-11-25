import xmostest
import os


def do_slave_test(lock_type):
    resources = xmostest.request_resource("xsim")

    binary = 'locks_test/bin/{}/locks_test_{}.xe'.format(lock_type, lock_type)

    tester = xmostest.ComparisonTester(open('locks.expect'),
                                     'lib_locks', 'locks_sim_tests',
                                     'locks_test', {'lock_type' : lock_type})

    tester.set_min_testlevel('smoke')

    xmostest.run_on_simulator(resources['xsim'], binary,
                              simargs=['--xscope', '-offline xscope.xmt'],
                              tester = tester)

def runtest():
    do_slave_test('SW')
    do_slave_test('HW')
