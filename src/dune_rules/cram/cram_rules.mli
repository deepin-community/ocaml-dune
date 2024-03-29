(** Rules for setting up cram tests *)

open Import

val rules
  :  sctx:Super_context.t
  -> expander:Expander.t
  -> dir:Path.Build.t
  -> Source_tree.Dir.t
  -> unit Memo.t
