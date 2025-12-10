:orphan:

################################
lib_locks: Locks for concurrency
################################

:vendor: XMOS
:version: 2.4.0
:scope: General Use
:description: Access to hardware and software locks for concurrent C programs
:category: General Purpose
:keywords: Utility
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
* Intertile lock (xcore.ai only): single lock available for guarding chip-wide access to resources

************
Known issues
************

* Intertile lock uses a MIPI D-PHY register and so cannot be used when MIPI D-PHY is enabled
* Intertile lock requires that both tiles are running at the same core frequency.
  Clocking down one tile may very rarely result in unreliable locking.

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
