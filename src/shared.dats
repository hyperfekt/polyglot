#include "src/cli.dats"
#include "src/count-loop.dats"
#include "src/print.dats"

staload "src/filetype.sats"
staload "libats/ML/SATS/atspre.sats"
staload "libats/ML/SATS/list0.sats"
staload "libats/ML/SATS/basis.sats"
staload EXTRA = "libats/ML/SATS/filebas.sats"
staload "libats/ML/DATS/filebas_dirent.dats"
staload "libats/libc/SATS/unistd.sats"
staload _ = "libats/ML/DATS/atspre.dats"
staload _ = "libats/ML/DATS/list0.dats"
staload _ = "libats/ML/DATS/filebas.dats"

#define nil list_nil
#define :: list_cons

val empty_file = let
  var f = @{ files = 0, blanks = 0, comments = 0, lines = 0 } : file
in
  f
end

fn to_file(s : string, pre : Option(string)) : file =
  let
    var is_comment = case+ pre of
      | Some (x) => string_is_prefix(x, s)
      | None => false
  in
    if s = "" then
      @{ lines = 1, blanks = 1, comments = 0, files = 0 }
    else
      if is_comment then
        @{ lines = 1, blanks = 0, comments = 1, files = 0 }
      else
        @{ lines = 1, blanks = 0, comments = 0, files = 0 }
  end

fn add_contents(x : source_contents, y : source_contents) : source_contents =
  let
    var next = @{ rust = x.rust + y.rust
                , haskell = x.haskell + y.haskell
                , ats = x.ats + y.ats
                , python = x.python + y.python
                , vimscript = x.vimscript + y.vimscript
                , elm = x.elm + y.elm
                , idris = x.idris + y.idris
                , madlang = x.madlang + y.madlang
                , tex = x.tex + y.tex
                , markdown = x.markdown + y.markdown
                , yaml = x.yaml + y.yaml
                , toml = x.toml + y.toml
                , cabal = x.cabal + y.cabal
                , happy = x.happy + y.happy
                , alex = x.alex + y.alex
                , go = x.go + y.go
                , html = x.html + y.html
                , css = x.css + y.css
                , verilog = x.verilog + y.verilog
                , vhdl = x.vhdl + y.vhdl
                , c = x.c + y.c
                , purescript = x.purescript + y.purescript
                , futhark = x.futhark + y.futhark
                , brainfuck = x.brainfuck + y.brainfuck
                , ruby = x.ruby + y.ruby
                , julia = x.julia + y.julia
                , perl = x.perl + y.perl
                , ocaml = x.ocaml + y.ocaml
                , agda = x.agda + y.agda
                , cobol = x.cobol + y.cobol
                , tcl = x.tcl + y.tcl
                , r = x.r + y.r
                , lua = x.lua + y.lua
                , cpp = x.cpp + y.cpp
                , lalrpop = x.lalrpop + y.lalrpop
                , header = x.header + y.header
                , sixten = x.sixten + y.sixten
                , dhall = x.dhall + y.dhall
                , ipkg = x.ipkg + y.ipkg
                , makefile = x.makefile + y.makefile
                , justfile = x.justfile + y.justfile
                , ion = x.ion + y.ion
                , bash = x.bash + y.bash
                , hamlet = x.hamlet + y.hamlet
                , cassius = x.cassius + y.cassius
                , lucius = x.lucius + y.lucius
                , julius = x.julius + y.julius
                , mercury = x.mercury + y.mercury
                , yacc = x.yacc + y.yacc
                , lex = x.lex + y.lex
                , coq = x.coq + y.coq
                , jupyter = x.jupyter + y.jupyter
                , java = x.java + y.java
                , scala = x.scala + y.scala
                , erlang = x.erlang + y.erlang
                , elixir = x.elixir + y.elixir
                , pony = x.pony + y.pony
                , clojure = x.clojure + y.clojure
                , cabal_project = x.cabal_project + y.cabal_project
                , assembly = x.assembly + y.assembly
                , nix = x.nix + y.nix
                , php = x.php + y.php
                , javascript = x.javascript + y.javascript
                , kotlin = x.kotlin + y.kotlin
                , fsharp = x.fsharp + y.fsharp
                , fortran = x.fortran + y.fortran
                , swift = x.swift + y.swift
                , csharp = x.csharp + y.csharp
                , nim = x.nim + y.nim
                , cpp_header = x.cpp_header + y.cpp_header
                , elisp = x.elisp + y.elisp
                , plaintext = x.plaintext + y.plaintext
                , rakefile = x.rakefile + y.rakefile
                , llvm = x.llvm + y.llvm
                , autoconf = x.autoconf + y.autoconf
                , batch = x.batch + y.batch
                , powershell = x.powershell + y.powershell
                , m4 = x.m4 + y.m4
                , objective_c = x.objective_c + y.objective_c
                , automake = x.automake + y.automake
                , margaret = x.margaret + y.margaret
                , carp = x.carp + y.carp
                , shen = x.shen + y.shen
                , greencard = x.greencard + y.greencard
                , cmm = x.cmm + y.cmm
                , fluid = x.fluid + y.fluid
                , plutus = x.plutus + y.plutus
                , j = x.j + y.j
                } : source_contents
  in
    next
  end

overload + with add_contents

// This is the step function used when streaming directory contents. 
fn adjust_contents(prev : source_contents, scf : pl_type) : source_contents =
  let
    var sc_r = ref<source_contents>(prev)
    val _ = case+ scf of
      | ~haskell n => sc_r -> haskell := prev.haskell + n
      | ~ats n => sc_r -> ats := prev.ats + n
      | ~rust n => sc_r -> rust := prev.rust + n
      | ~markdown n => sc_r -> markdown := prev.markdown + n
      | ~python n => sc_r -> python := prev.python + n
      | ~vimscript n => sc_r -> vimscript := prev.vimscript + n
      | ~yaml n => sc_r -> yaml := prev.yaml + n
      | ~toml n => sc_r -> toml := prev.toml + n
      | ~happy n => sc_r -> happy := prev.happy + n
      | ~alex n => sc_r -> alex := prev.alex + n
      | ~idris n => sc_r -> idris := prev.idris + n
      | ~madlang n => sc_r -> madlang := prev.madlang + n
      | ~elm n => sc_r -> elm := prev.elm + n
      | ~c n => sc_r -> c := prev.c + n
      | ~go n => sc_r -> go := prev.go + n
      | ~cabal n => sc_r -> cabal := prev.cabal + n
      | ~verilog n => sc_r -> verilog := prev.verilog + n
      | ~vhdl n => sc_r -> vhdl := prev.vhdl + n
      | ~html n => sc_r -> html := prev.html + n
      | ~css n => sc_r -> css := prev.css + n
      | ~purescript n => sc_r -> purescript := prev.purescript + n
      | ~futhark n => sc_r -> futhark := prev.futhark + n
      | ~brainfuck n => sc_r -> brainfuck := prev.brainfuck + n
      | ~ruby n => sc_r -> ruby := prev.ruby + n
      | ~julia n => sc_r -> julia := prev.julia + n
      | ~tex n => sc_r -> tex := prev.tex + n
      | ~perl n => sc_r -> perl := prev.perl + n
      | ~ocaml n => sc_r -> ocaml := prev.ocaml + n
      | ~agda n => sc_r -> agda := prev.agda + n
      | ~cobol n => sc_r -> cobol := prev.cobol + n
      | ~tcl n => sc_r -> tcl := prev.tcl + n
      | ~r n => sc_r -> r := prev.r + n
      | ~lua n => sc_r -> lua := prev.lua + n
      | ~cpp n => sc_r -> cpp := prev.cpp + n
      | ~lalrpop n => sc_r -> lalrpop := prev.lalrpop + n
      | ~header n => sc_r -> header := prev.header + n
      | ~sixten n => sc_r -> sixten := prev.sixten + n
      | ~dhall n => sc_r -> dhall := prev.dhall + n
      | ~ipkg n => sc_r -> ipkg := prev.ipkg + n
      | ~justfile n => sc_r -> justfile := prev.justfile + n
      | ~makefile n => sc_r -> makefile := prev.makefile + n
      | ~ion n => sc_r -> ion := prev.ion + n
      | ~bash n => sc_r -> bash := prev.bash + n
      | ~hamlet n => sc_r -> hamlet := prev.hamlet + n
      | ~cassius n => sc_r -> cassius := prev.cassius + n
      | ~lucius n => sc_r -> lucius := prev.lucius + n
      | ~julius n => sc_r -> julius := prev.julius + n
      | ~mercury n => sc_r -> mercury := prev.mercury + n
      | ~yacc n => sc_r -> yacc := prev.yacc + n
      | ~lex n => sc_r -> lex := prev.lex + n
      | ~coq n => sc_r -> coq := prev.coq + n
      | ~jupyter n => sc_r -> jupyter := prev.jupyter + n
      | ~java n => sc_r -> java := prev.java + n
      | ~scala n => sc_r -> scala := prev.scala + n
      | ~erlang n => sc_r -> erlang := prev.erlang + n
      | ~elixir n => sc_r -> elixir := prev.elixir + n
      | ~pony n => sc_r -> pony := prev.pony + n
      | ~clojure n => sc_r -> clojure := prev.clojure + n
      | ~cabal_project n => sc_r -> cabal_project := prev.cabal_project + n
      | ~assembly n => sc_r -> assembly := prev.assembly + n
      | ~nix n => sc_r -> nix := prev.nix + n
      | ~php n => sc_r -> php := prev.php + n
      | ~javascript n => sc_r -> javascript := prev.javascript + n
      | ~kotlin n => sc_r -> kotlin := prev.kotlin + n
      | ~fsharp n => sc_r -> fsharp := prev.fsharp + n
      | ~fortran n => sc_r -> fortran := prev.fortran + n
      | ~swift n => sc_r -> swift := prev.swift + n
      | ~csharp n => sc_r -> csharp := prev.csharp + n
      | ~nim n => sc_r -> nim := prev.nim + n
      | ~cpp_header n => sc_r -> cpp_header := prev.cpp_header + n
      | ~elisp n => sc_r -> elisp := prev.elisp + n
      | ~plaintext n => sc_r -> plaintext := prev.plaintext + n
      | ~rakefile n => sc_r -> rakefile := prev.rakefile + n
      | ~llvm n => sc_r -> llvm := prev.llvm + n
      | ~autoconf n => sc_r -> autoconf := prev.autoconf + n
      | ~batch n => sc_r -> batch := prev.batch + n
      | ~powershell n => sc_r -> powershell := prev.powershell + n
      | ~m4 n => sc_r -> m4 := prev.m4 + n
      | ~objective_c n => sc_r -> objective_c := prev.objective_c + n
      | ~automake n => sc_r -> automake := prev.automake + n
      | ~margaret n => sc_r -> margaret := prev.margaret + n
      | ~carp n => sc_r -> carp := prev.carp + n
      | ~shen n => sc_r -> shen := prev.shen + n
      | ~greencard n => sc_r -> greencard := prev.greencard + n
      | ~cmm n => sc_r -> cmm := prev.cmm + n
      | ~fluid n => sc_r -> fluid := prev.fluid + n
      | ~plutus n => sc_r -> plutus := prev.plutus + n
      | ~j n => sc_r -> j := prev.j + n
      | ~unknown _ => ()
  in
    !sc_r
  end

fun match_keywords { m : nat | m <= 10 }(keys : list(string, m), word : string) : bool =
  list_foldright_cloref(keys, lam (next, acc) =<cloref1> acc || eq_string_string(next, word), false)

// TODO use list_vt{int}(0, 1, 2, 3, 4) instead?
// helper function for check_keywords
fn step_keyword(size : file, pre : pl_type, word : string, ext : string) : pl_type =
  case+ pre of
    | unknown _ => 
      begin
        case+ ext of
          | "y" => let
            val _ = free(pre)
            var happy_keywords = "module" :: "import" :: nil
          in
            ifcase
              | match_keywords(happy_keywords, word) => happy(size)
              | let
                var yacc_keywords = "struct" :: "char" :: "int" :: nil
              in
                match_keywords(yacc_keywords, word)
              end => yacc(size)
              | _ => unknown
          end
          | "v" => let
            var _ = free(pre)
            var verilog_keywords = "endmodule" :: "posedge" :: "edge" :: "always" :: "wire" :: nil
          in
            ifcase
              | match_keywords(verilog_keywords, word) => verilog(size)
              | let
                var coq_keywords = "Qed"
                :: "Require"
                :: "Hypothesis"
                :: "Inductive" :: "Remark" :: "Lemma" :: "Proof" :: "Definition" :: "Theorem" :: nil
              in
                match_keywords(coq_keywords, word)
              end => coq(size)
              | _ => unknown
          end
          | "m" => let
            val _ = free(pre)
            var mercury_keywords = "module" :: "pred" :: nil
          in
            ifcase
              | match_keywords(mercury_keywords, word) => mercury(size)
              | let
                var objective_c_keywords = "unsigned" :: "nil" :: "nullable" :: "nonnull" :: nil
              in
                match_keywords(objective_c_keywords, word)
              end => objective_c(size)
              | _ => unknown
          end
          | _ => pre
      end
    | _ => pre

// Function to disambiguate extensions such as .v (Coq and Verilog) and .m
// (Mercury and Objective C). This should only be called when extensions are in
// conflict, as it reads the whole file.
fn check_keywords(s : string, size : file, ext : string) : pl_type =
  let
    var ref = fileref_open_opt(s, file_mode_r)
  in
    case+ ref of
      | ~Some_vt (x) => let
        var init: pl_type = unknown
        var viewstream = $EXTRA.streamize_fileref_word(x)
        var result = stream_vt_foldleft_cloptr(viewstream, init, lam (acc, next) => step_keyword(size, acc, next, ext))
        val _ = fileref_close(x)
      in
        result
      end
      | ~None_vt() => (bad_file(s) ; unknown)
  end

// Check shebang on scripts.
//
// TODO flexible parser that drops spaces as appropriate
// TODO check magic number so as to avoid checking shebang of binary file
fn check_shebang(s : string) : pl_type =
  let
    var ref = fileref_open_opt(s, file_mode_r)
    val str: string = case+ ref of
      | ~Some_vt (x) => let
        var s = strptr2string(fileref_get_line_string(x))
        val _ = fileref_close(x)
      in
        s
      end
      | ~None_vt() => (bad_file(s) ; "")
  in
    case+ str of
      | "#!/usr/bin/env ion" => ion(line_count(s, Some_vt("#")))
      | "#!/usr/bin/env bash" => bash(line_count(s, Some_vt("#")))
      | "#!/bin/bash" => bash(line_count(s, Some_vt("#")))
      | "#!python" => python(line_count(s, Some_vt("#")))
      | "#!python2" => python(line_count(s, Some_vt("#")))
      | "#!python3" => python(line_count(s, Some_vt("#")))
      | "#!/usr/bin/env python" => python(line_count(s, Some_vt("#")))
      | "#!/usr/bin/env python2" => python(line_count(s, Some_vt("#")))
      | "#!/usr/bin/env python3" => python(line_count(s, Some_vt("#")))
      | "#!/usr/bin/env perl" => perl(line_count(s, Some_vt("#")))
      | "#!/usr/bin/env perl6" => perl(line_count(s, Some_vt("#")))
      | "#!/usr/bin/perl" => perl(line_count(s, Some_vt("#")))
      | "#!/usr/bin/env stack" => haskell(line_count(s, Some_vt("--")))
      | "#!/usr/bin/env runhaskell" => haskell(line_count(s, Some_vt("--")))
      | "#!/usr/bin/env node" => javascript(line_count(s, None_vt))
      | _ => unknown
  end

// Match based on filename (for makefiles, etc.)
fn match_filename(s : string) : pl_type =
  let
    val (prf | str) = filename_get_base(s)
    var match = $UN.strptr2string(str)
    prval () = prf(str)
  in
    case+ match of
      | "Makefile" => makefile(line_count(s, Some_vt("#")))
      | "Makefile.tc" => makefile(line_count(s, Some_vt("#")))
      | "Makefile.common" => makefile(line_count(s, Some_vt("#")))
      | "Makefile.common_c" => makefile(line_count(s, Some_vt("#")))
      | "makefile" => makefile(line_count(s, Some_vt("#")))
      | "GNUmakefile" => makefile(line_count(s, Some_vt("#")))
      | "Justfile" => justfile(line_count(s, Some_vt("#")))
      | "justfile" => justfile(line_count(s, Some_vt("#")))
      | "Rakefile" => rakefile(line_count(s, None_vt))
      | "cabal.project.local" => cabal_project(line_count(s, Some_vt("--")))
      | _ => check_shebang(s)
  end

// Match based on file extension (assuming the file name is passed in as an
// argument).
fn prune_extension(s : string, file_proper : string) : pl_type =
  let
    val (prf | str) = filename_get_ext(s)
    val match: string = if strptr2ptr(str) > 0 then
      $UN.strptr2string(str)
    else
      ""
    prval () = prf(str)
  in
    case+ match of
      | "hs" => haskell(line_count(s, Some_vt("--")))
      | "cpphs" => haskell(line_count(s, Some_vt("--")))
      | "hs-boot" => haskell(line_count(s, Some_vt("--")))
      | "hsig" => haskell(line_count(s, Some_vt("--")))
      | "gc" => greencard(line_count(s, Some_vt("--")))
      | "rs" => rust(line_count(s, Some_vt("//")))
      | "tex" => tex(line_count(s, Some_vt("%")))
      | "md" => markdown(line_count(s, None_vt))
      | "markdown" => markdown(line_count(s, None_vt))
      | "dats" => ats(line_count(s, Some_vt("//")))
      | "lats" => ats(line_count(s, Some_vt("//")))
      | "hats" => ats(line_count(s, Some_vt("//")))
      | "cats" => ats(line_count(s, Some_vt("//")))
      | "sats" => ats(line_count(s, Some_vt("//")))
      | "py" => python(line_count(s, Some_vt("#")))
      | "fut" => futhark(line_count(s, Some_vt("--")))
      | "pl" => perl(line_count(s, None_vt))
      | "agda" => agda(line_count(s, Some_vt("--")))
      | "idr" => idris(line_count(s, Some_vt("--")))
      | "v" => check_keywords(s, line_count(s, Some_vt("--")), match)
      | "m" => check_keywords(s, line_count(s, None_vt), match)
      | "vhdl" => vhdl(line_count(s, None_vt))
      | "vhd" => vhdl(line_count(s, None_vt))
      | "go" => go(line_count(s, Some_vt("//")))
      | "vim" => vimscript(line_count(s, Some_vt("\"")))
      | "ml" => ocaml(line_count(s, None_vt))
      | "purs" => purescript(line_count(s, None_vt))
      | "elm" => elm(line_count(s, Some_vt("--")))
      | "mad" => madlang(line_count(s, Some_vt("#")))
      | "toml" => toml(line_count(s, Some_vt("#")))
      | "cabal" => cabal(line_count(s, Some_vt("--")))
      | "yml" => yaml(line_count(s, Some_vt("#")))
      | "yaml" => yaml(line_count(s, Some_vt("#")))
      | "y" => check_keywords(s, line_count(s, Some_vt("--")), match)
      | "ly" => happy(line_count(s, Some_vt("--")))
      | "yl" => happy(line_count(s, Some_vt("--")))
      | "ypp" => yacc(line_count(s, Some_vt("//")))
      | "x" => alex(line_count(s, Some_vt("--")))
      | "lx" => alex(line_count(s, Some_vt("--")))
      | "l" => lex(line_count(s, None_vt))
      | "lpp" => lex(line_count(s, None_vt))
      | "html" => html(line_count(s, None_vt))
      | "htm" => html(line_count(s, None_vt))
      | "css" => css(line_count(s, None_vt))
      | "vhdl" => vhdl(line_count(s, None_vt))
      | "vhd" => vhdl(line_count(s, None_vt))
      | "c" => c(line_count(s, Some_vt("//")))
      | "C" => cpp(line_count(s, Some_vt("//")))
      | "cmm" => cmm(line_count(s, Some_vt("//")))
      | "b" => brainfuck(line_count(s, None_vt))
      | "bf" => brainfuck(line_count(s, None_vt))
      | "rb" => ruby(line_count(s, None_vt))
      | "cob" => cobol(line_count(s, None_vt))
      | "cbl" => cobol(line_count(s, None_vt))
      | "cpy" => cobol(line_count(s, None_vt))
      | "ml" => ocaml(line_count(s, None_vt))
      | "tcl" => tcl(line_count(s, None_vt))
      | "fl" => fluid(line_count(s, Some_vt("#")))
      | "r" => r(line_count(s, None_vt))
      | "R" => r(line_count(s, None_vt))
      | "lua" => lua(line_count(s, Some_vt("--")))
      | "cpp" => cpp(line_count(s, Some_vt("//")))
      | "ino" => cpp(line_count(s, Some_vt("//")))
      | "cc" => cpp(line_count(s, Some_vt("//")))
      | "lalrpop" => lalrpop(line_count(s, Some_vt("//")))
      | "h" => header(line_count(s, None_vt))
      | "vix" => sixten(line_count(s, Some_vt("--")))
      | "dhall" => dhall(line_count(s, Some_vt("--")))
      | "ipkg" => ipkg(line_count(s, Some_vt("--")))
      | "mk" => makefile(line_count(s, Some_vt("#")))
      | "hamlet" => hamlet(line_count(s, None_vt))
      | "cassius" => cassius(line_count(s, None_vt))
      | "lucius" => cassius(line_count(s, None_vt))
      | "julius" => julius(line_count(s, None_vt))
      | "jl" => julia(line_count(s, None_vt))
      | "ion" => ion(line_count(s, Some_vt("#")))
      | "bash" => bash(line_count(s, Some_vt("#")))
      | "ipynb" => jupyter(line_count(s, None_vt))
      | "java" => java(line_count(s, Some_vt("//")))
      | "scala" => scala(line_count(s, None_vt))
      | "erl" => erlang(line_count(s, None_vt))
      | "hrl" => erlang(line_count(s, None_vt))
      | "ex" => elixir(line_count(s, None_vt))
      | "exs" => elixir(line_count(s, None_vt))
      | "pony" => pony(line_count(s, None_vt))
      | "clj" => clojure(line_count(s, None_vt))
      | "s" => assembly(line_count(s, Some_vt(";")))
      | "S" => assembly(line_count(s, Some_vt(";")))
      | "asm" => assembly(line_count(s, Some_vt(";")))
      | "nix" => nix(line_count(s, None_vt))
      | "php" => php(line_count(s, None_vt))
      | "local" => match_filename(s)
      | "project" => cabal_project(line_count(s, Some_vt("--")))
      | "js" => javascript(line_count(s, Some_vt("//")))
      | "jsexe" => javascript(line_count(s, Some_vt("//")))
      | "kt" => kotlin(line_count(s, None_vt))
      | "kts" => kotlin(line_count(s, None_vt))
      | "fs" => fsharp(line_count(s, None_vt))
      | "f" => fortran(line_count(s, None_vt))
      | "for" => fortran(line_count(s, None_vt))
      | "f90" => fortran(line_count(s, None_vt))
      | "f95" => fortran(line_count(s, None_vt))
      | "swift" => swift(line_count(s, None_vt))
      | "csharp" => csharp(line_count(s, None_vt))
      | "nim" => nim(line_count(s, None_vt))
      | "el" => elisp(line_count(s, Some_vt(";")))
      | "txt" => plaintext(line_count(s, None_vt))
      | "ll" => llvm(line_count(s, None_vt))
      | "in" => autoconf(line_count(s, Some_vt("#")))
      | "bat" => batch(line_count(s, None_vt))
      | "ps1" => powershell(line_count(s, None_vt))
      | "ac" => m4(line_count(s, None_vt))
      | "mm" => objective_c(line_count(s, Some_vt("//")))
      | "am" => automake(line_count(s, Some_vt("#")))
      | "mgt" => margaret(line_count(s, Some_vt("--")))
      | "carp" => carp(line_count(s, Some_vt(";")))
      | "pls" => plutus(line_count(s, None_vt))
      | "ijs" => j(line_count(s, Some_vt("NB")))
      | "" => match_filename(s)
      | "sh" => match_filename(s)
      | "yamllint" => match_filename(s)
      | _ => unknown
  end

// filter out directories containing artifacts
fn bad_dir(s : string, excludes : List0(string)) : bool =
  case+ s of
    | "." => true
    | ".." => true
    | ".pijul" => true
    | "_darcs" => true
    | ".hg" => true
    | ".git" => true
    | "target" => true
    | ".atspkg" => true
    | ".egg-info" => true
    | "nimcache" => true
    | "dist-newstyle" => true
    | "dist" => true
    | ".psc-package" => true
    | ".pulp-cache" => true
    | "bower_components" => true
    | "elm-stuff" => true
    | ".stack-work" => true
    | ".cabal-sandbox" => true
    | "node_modules" => true
    | ".lein-plugins" => true
    | ".sass-cache" => true
    | _ => list_exists_cloref(excludes, lam x => x = s || x = s + "/")

fnx step_stream(acc : source_contents, full_name : string, file_proper : string, excludes : List0(string)) :
  source_contents =
  if test_file_isdir(full_name) > 0 then
    flow_stream(full_name, acc, excludes)
  else
    adjust_contents(acc, prune_extension(full_name, file_proper))
and flow_stream(s : string, init : source_contents, excludes : List0(string)) : source_contents =
  let
    var files = $EXTRA.streamize_dirname_fname(s)
    var ffiles = stream_vt_filter_cloptr(files, lam x => not(bad_dir(x, excludes)))
  in
    if s != "." then
      stream_vt_foldleft_cloptr(ffiles, init, lam (acc, next) => step_stream(acc, s + "/" + next, next, excludes))
    else
      stream_vt_foldleft_cloptr(ffiles, init, lam (acc, next) => step_stream(acc, next, next, excludes))
  end

fn empty_contents() : source_contents =
  let
    var isc = @{ rust = empty_file
               , haskell = empty_file
               , ats = empty_file
               , python = empty_file
               , vimscript = empty_file
               , elm = empty_file
               , idris = empty_file
               , madlang = empty_file
               , tex = empty_file
               , markdown = empty_file
               , yaml = empty_file
               , toml = empty_file
               , cabal = empty_file
               , happy = empty_file
               , alex = empty_file
               , go = empty_file
               , html = empty_file
               , css = empty_file
               , verilog = empty_file
               , vhdl = empty_file
               , c = empty_file
               , purescript = empty_file
               , futhark = empty_file
               , brainfuck = empty_file
               , ruby = empty_file
               , julia = empty_file
               , perl = empty_file
               , ocaml = empty_file
               , agda = empty_file
               , cobol = empty_file
               , tcl = empty_file
               , r = empty_file
               , lua = empty_file
               , cpp = empty_file
               , lalrpop = empty_file
               , header = empty_file
               , sixten = empty_file
               , dhall = empty_file
               , ipkg = empty_file
               , makefile = empty_file
               , justfile = empty_file
               , ion = empty_file
               , bash = empty_file
               , hamlet = empty_file
               , cassius = empty_file
               , lucius = empty_file
               , julius = empty_file
               , mercury = empty_file
               , yacc = empty_file
               , lex = empty_file
               , coq = empty_file
               , jupyter = empty_file
               , java = empty_file
               , scala = empty_file
               , erlang = empty_file
               , elixir = empty_file
               , pony = empty_file
               , clojure = empty_file
               , cabal_project = empty_file
               , assembly = empty_file
               , nix = empty_file
               , php = empty_file
               , javascript = empty_file
               , kotlin = empty_file
               , fsharp = empty_file
               , fortran = empty_file
               , swift = empty_file
               , csharp = empty_file
               , nim = empty_file
               , cpp_header = empty_file
               , elisp = empty_file
               , plaintext = empty_file
               , rakefile = empty_file
               , llvm = empty_file
               , autoconf = empty_file
               , batch = empty_file
               , powershell = empty_file
               , m4 = empty_file
               , objective_c = empty_file
               , automake = empty_file
               , margaret = empty_file
               , carp = empty_file
               , shen = empty_file
               , greencard = empty_file
               , cmm = empty_file
               , fluid = empty_file
               , plutus = empty_file
               , j = empty_file
               } : source_contents
  in
    isc
  end

fn map_stream(acc : source_contents, includes : List0(string), excludes : List0(string)) : source_contents =
  list_foldleft_cloref(includes, acc, lam (acc, next) => if test_file_exists(next) || test_file_isdir(next) < 0
                      || next = "" then
                        step_stream(acc, next, next, excludes)
                      else
                        (maybe_err(next) ; acc))

fn step_list(s : string, excludes : List0(string)) : List0(string) =
  let
    var files = $EXTRA.streamize_dirname_fname(s)
    var ffiles = stream_vt_filter_cloptr(files, lam x => not(bad_dir(x, excludes) && test_file_isdir(s + "/" + x) > 0))
    
    fun stream2list(x : stream_vt(string)) : List0(string) =
      case+ !x of
        | ~stream_vt_cons (x, xs) => list_cons(s + "/" + x, stream2list(xs))
        | ~stream_vt_nil() => list_nil
  in
    stream2list(ffiles)
  end

fn step_list_files(s : string, excludes : List0(string)) : List0(string) =
  let
    var files = $EXTRA.streamize_dirname_fname(s)
    var ffiles = stream_vt_filter_cloptr(files, lam x => not(bad_dir(x, excludes)) && test_file_isdir(s + "/" + x) = 0)
    
    fun stream2list(x : stream_vt(string)) : List0(string) =
      case+ !x of
        | ~stream_vt_cons (x, xs) when s = "." => list_cons(x, stream2list(xs))
        | ~stream_vt_cons (x, xs) => list_cons(s + "/" + x, stream2list(xs))
        | ~stream_vt_nil() => list_nil
  in
    stream2list(ffiles)
  end

fn map_depth(xs : List0(string), excludes : List0(string)) : List0(string) =
  let
    fun loop(i : int, xs : List0(string), excludes : List0(string)) : List0(string) =
      let
        var xs0 = list0_filter(g0ofg1(xs), lam x => test_file_isdir(x) > 0)
      in
        case+ i of
          | 0 => g1ofg0(list0_mapjoin(xs0, lam x => if not(bad_dir(x, excludes)) then
                                       g0ofg1(step_list(x, excludes))
                                     else
                                       list0_nil))
          | _ => g1ofg0(list0_mapjoin(xs0, lam x => let
                                       var ys = step_list(x, excludes)
                                       var zs = step_list_files(x, excludes)
                                     in
                                       if not(bad_dir(x, excludes)) then
                                         g0ofg1(loop(i - 1, ys, excludes)) + g0ofg1(zs)
                                       else
                                         if x = "." && i = 3 then
                                           g0ofg1(loop(i - 1, ys, excludes)) + g0ofg1(zs)
                                         else
                                           list0_nil
                                     end))
      end
  in
    loop(3, xs, excludes)
  end
