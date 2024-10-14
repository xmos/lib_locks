:orphan:

################################
lib_locks: Lock handling library
################################

:vendor: XMOS
:version: 2.3.1
:scope: General Use
:description: Lock handling library
:category: General Purpose
:keywords: hardware locks, software locks, locks
:devices: xcore.ai, xcore-200

********
Overview
********

This library provides access to hardware and software locks for use in concurrent C programs. In
general it is not safe to use these to marshall within XC due to the assumptions XC makes about
safe concurrent data access.

********
Features
********

  * Hardware locks: fast and power efficient but there are a limited number per tile
  * Software locks: slower but an unlimited number can be used

************
Known Issues
************

  * None

**************
Required Tools
**************

  * XMOS XTC Tools: 15.3.0

*********************************
Required Libraries (dependencies)
*********************************

  * None

*************************
Related Application Notes
*************************

  * None

*******
Support
*******

This package is supported by XMOS Ltd. Issues can be raised against the software at www.xmos.com/support
