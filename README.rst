Lock handling Library
=====================

Overview
--------

This library provides access to hardware and software locks for use in
concurrent C programs. In general it is not safe to use these to
marshall within XC due to the assumptions XC
makes about safe concurrent data access.

Two types of locks are provided. Hardware locks are fast and power
efficient but there are a limited number per tile. Software locks are
slower but you can use an unlimited number of them.

Software version and dependencies
.................................

.. libdeps::
