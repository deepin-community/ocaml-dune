chdir
-----

.. highlight:: dune

.. dune:action:: chdir
   :param: <dir> <DSL>

   Run an action in a different directory.

   Example::

     (chdir src
      (run ./build.exe))
