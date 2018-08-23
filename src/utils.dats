staload "src/filetype.sats"

fn eq_pl_type(x : !pl_type, y : !pl_type) : bool =
  case- (x, y) of
    | (happy (_), happy (_)) => true
    | (yacc (_), yacc (_)) => true
    | (coq (_), coq (_)) => true
    | (verilog (_), verilog (_)) => true

overload = with eq_pl_type

fn free_pl(pl : pl_type) : void =
  case+ pl of
    | ~unknown _ => ()
    | ~rust _ => ()
    | ~haskell _ => ()
    | ~perl _ => ()
    | ~lucius _ => ()
    | ~cassius _ => ()
    | ~hamlet _ => ()
    | ~julius _ => ()
    | ~bash _ => ()
    | ~dash _ => ()
    | ~coq _ => ()
    | ~justfile _ => ()
    | ~makefile _ => ()
    | ~yaml _ => ()
    | ~toml _ => ()
    | ~dhall _ => ()
    | ~ipkg _ => ()
    | ~ion _ => ()
    | ~mercury _ => ()
    | ~yacc _ => ()
    | ~lex _ => ()
    | ~r _ => ()
    | ~c _ => ()
    | ~cpp _ => ()
    | ~lua _ => ()
    | ~lalrpop _ => ()
    | ~header _ => ()
    | ~sixten _ => ()
    | ~java _ => ()
    | ~scala _ => ()
    | ~elixir _ => ()
    | ~erlang _ => ()
    | ~happy _ => ()
    | ~alex _ => ()
    | ~go _ => ()
    | ~html _ => ()
    | ~css _ => ()
    | ~brainfuck _ => ()
    | ~ruby _ => ()
    | ~julia _ => ()
    | ~elm _ => ()
    | ~purescript _ => ()
    | ~vimscript _ => ()
    | ~ocaml _ => ()
    | ~madlang _ => ()
    | ~agda _ => ()
    | ~idris _ => ()
    | ~futhark _ => ()
    | ~ats _ => ()
    | ~tex _ => ()
    | ~cabal _ => ()
    | ~cobol _ => ()
    | ~tcl _ => ()
    | ~verilog _ => ()
    | ~vhdl _ => ()
    | ~markdown _ => ()
    | ~python _ => ()
    | ~pony _ => ()
    | ~jupyter _ => ()
    | ~clojure _ => ()
    | ~cabal_project _ => ()
    | ~assembly _ => ()
    | ~nix _ => ()
    | ~php _ => ()
    | ~javascript _ => ()
    | ~kotlin _ => ()
    | ~fsharp _ => ()
    | ~fortran _ => ()
    | ~swift _ => ()
    | ~csharp _ => ()
    | ~nim _ => ()
    | ~cpp_header _ => ()
    | ~elisp _ => ()
    | ~plaintext _ => ()
    | ~rakefile _ => ()
    | ~llvm _ => ()
    | ~autoconf _ => ()
    | ~batch _ => ()
    | ~powershell _ => ()
    | ~m4 _ => ()
    | ~objective_c _ => ()
    | ~automake _ => ()
    | ~margaret _ => ()
    | ~carp _ => ()
    | ~shen _ => ()
    | ~greencard _ => ()
    | ~cmm _ => ()
    | ~fluid _ => ()
    | ~plutus _ => ()
    | ~j _ => ()
    | ~blodwen _ => ()
    | ~crystal _ => ()
    | ~racket _ => ()
    | ~ada _ => ()
    | ~sml _ => ()
    | ~isabelle _ => ()
    | ~fstar _ => ()
    | ~d _ => ()
    | ~factor _ => ()
    | ~scheme _ => ()

overload free with free_pl
