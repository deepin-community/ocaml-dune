  $ . ./helpers.sh

  $ make_lockdir
  > (version 0.0.1)
  $ build_pkg test

Demonstrate that the original source shouldn't be modified:

  $ cat _build/_private/default/.pkg/test/source/foo.ml
  cat: _build/_private/default/.pkg/test/source/foo.ml: No such file or directory
  [1]