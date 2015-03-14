.. include:: ../../../README.rst

Hardware lock API
-----------------

.. doxygentypedef:: hwlock_t

.. doxygenfunction:: hwlock_alloc
.. doxygenfunction:: hwlock_free

|newpage|

.. doxygenfunction:: hwlock_acquire
.. doxygenfunction:: hwlock_release

Software lock API
-----------------

.. doxygentypedef:: swlock_t

.. doxygendefine:: SWLOCK_INITIAL_VALUE

.. doxygenfunction:: swlock_init
.. doxygenfunction:: swlock_try_acquire
.. doxygenfunction:: swlock_acquire
.. doxygenfunction:: swlock_release

|appendix|

Known Issues
------------

No known issues.

.. include:: ../../../CHANGELOG.rst
