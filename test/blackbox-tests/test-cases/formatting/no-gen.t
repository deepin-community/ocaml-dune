See issue 7454

  $ cat >parser_raw.mly <<EOF
  > %token EOL
  > %start <unit> prog
  > %%
  > prog:
  >   | EOL { () } 
  >   | EOL; prog { () } 
  > EOF

  $ cat >dune <<EOF
  > (library 
  >  (name foo)
  >  (modules parser_raw other_gen))
  > 
  > (menhir
  >  (modules parser_raw)
  >  (mode promote))
  > 
  > (rule
  >  (targets other_gen.ml)
  >  (mode promote)
  >  (action (with-stdout-to %{targets}
  >          (echo "print_int 42"))))
  > EOF

  $ cat >dune-project <<EOF
  > (lang dune 2.9)
  > (using menhir 2.0)
  > (formatting (enabled_for ocaml))
  > EOF

  $ touch .ocamlformat 

In the above project, two modules have their implementation generated: 
- [Other_gen]'s implementation is generated by a rule stanza
- [Parser_raw]'s implementation is genrated by menhir stanza

Formatting the codebase should not trigger the generation of missing modules
  $ dune build @fmt

As expected, Dune did not try to generate the missing implem for [Parser_raw] 
  $ dune_cmd exists _build/default/parser_raw.ml
  false

As expected, Dune did not try to generate the missing implem for [Other_gen]
  $ dune_cmd exists _build/default/other_gen.ml
  false

  $ dune clean

Now we add [mli] files for the two modules whose implementation is generated:

  $ touch other_gen.mli
  $ touch parser_raw.mli 

We format again.
  $ dune build @fmt
  Warning: one state end-of-stream conflict was arbitrarily resolved.
  File "parser_raw.mly", line 5, characters 4-7:
  Warning: production prog -> EOL is never reduced.
  Warning: in total, 1 production is never reduced.
  File "parser_raw.mli", line 1, characters 0-0:
  Error: Files _build/default/parser_raw.mli and
  _build/default/.formatted/parser_raw.mli differ.
  [1]

FIXME: unexpectedly, Dune generated the missing parser
  $ dune_cmd exists _build/default/parser_raw.ml
  true

As expected, Dune did not try to generate the missing implem for [Other_gen]
  $ dune_cmd exists _build/default/other_gen.ml
  false
