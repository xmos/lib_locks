:orphan:

################################
lib_locks: Locks for concurrency
################################

:vendor: XMOS
:version: 2.3.2
:scope: General Use
:description: Access to hardware and software locks for concurrent C programs
:category: General Purpose
:keywords: locks
:devices: xcore.ai, xcore-200

*******
Summary
*******

This library provides access to hardware and software locks for use in concurrent C programs.
However, it is generally not safe to use these for marshaling within XC, due to the assumptions
XC makes about safe concurrent data access.

********
Features
********

* Hardware locks: fast and power efficient but there are a limited number per tile
* Software locks: slower but an unlimited number can be used

************
Known issues
************

* None

****************
Development repo
****************

* `lib_locks <https://www.github.com/xmos/lib_locks>`_

**************
Required tools
**************

* XMOS XTC Tools: 15.3.1

*********************************
Required libraries (dependencies)
*********************************

* None

*************************
Related application notes
*************************

* None

*******
Support
*******

This package is supported by XMOS Ltd. Issues can be raised against the software at
`www.xmos.com/support <https://www.xmos.com/support>`_
