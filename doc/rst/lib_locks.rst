################################
lib_locks: Lock handling library
################################

************
Introduction
************

This library provides access to hardware and software locks for use in concurrent C programs. In
general it is not safe to use these to marshall within XC due to the assumptions XC makes about
safe concurrent data access.

Two types of locks are provided. Hardware locks are fast and power efficient but there are a
limited number per tile. Software locks are slower but you can use an unlimited number of them.

``lib_locks`` is intended to be used with the `XCommon CMake <https://www.xmos.com/file/xcommon-cmake-documentation/?version=latest>`_
, the `XMOS` application build and dependency management system.

*********
Basic use
*********

Declaration & allocation
========================

Before using a lock it first must be declared.

Software based locks should be initialised to a specific value::

    swlock_t swlock = SWLOCK_INITIAL_VALUE;

Hardware locks relate to a physical resource in the device and so need to be properly allocated::

    hwlock_t hwlock;

    hwlock = hwlock_alloc();

Locks are typically used to protect critical sections of code when multiple threads are involved,
so they are often declared globally for shared access.

Acquisition and release
=======================

Hardware and software based locks use a similar API for acquisition and release. For software based
locks the following is used::

    swlock_acquire(&swlock);

    // Perform critical code section..

    swlock_release(&swlock);

Similarly, for hardware based locks::

    hwlock_acquire(&hwlock);

    // Perform critical code section..

    hwlock_release(&hwlock);

In all cases these are blocking calls.

Freeing
=======

Once an application no longer requires a hardware lock it should be freed to allow the underlying
hardware resource to be reused::

    hwlock_free(hwlock);

*******************
Example application
*******************

An example is provided in `examples/app_locks_example` that demonstrates basic lock allocation, freeing,
acquiring and releasing.

|newpage|

*****************
Hardware lock API
*****************

.. doxygentypedef:: hwlock_t

.. doxygenfunction:: hwlock_alloc
.. doxygenfunction:: hwlock_free


.. doxygenfunction:: hwlock_acquire
.. doxygenfunction:: hwlock_release

|newpage|

*****************
Software lock API
*****************

.. doxygentypedef:: swlock_t

.. doxygendefine:: SWLOCK_INITIAL_VALUE

.. doxygenfunction:: swlock_init
.. doxygenfunction:: swlock_try_acquire
.. doxygenfunction:: swlock_acquire
.. doxygenfunction:: swlock_release


