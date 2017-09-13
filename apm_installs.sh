#!/bin/sh

APM=apm-beta

# something
${APM} install linter linter-ui-default intentions busy-signal minimap file-icons highlight-column highlight-line color-picker pigments;
# git
${APM} install git-history git-control merge-conflicts git-plus git-log tualo-git-context;
# haskell
${APM} install ide-haskell haskell-ghc-mod ide-haskell-cabal autocomplete-haskell language-haskell haskell-pointfree linter-hlint;
# clang
${APM} install linter-clang autocomplete-clang;
# rust
${APM} install language-rust linter-rust racer;
# latex
${APM} install latex pdf-view language-latex latexer linter-chktex script markdown-preview-enhanced;
# fsharp
${APM} install language-fsharp;
# java
#${APM} install autocomplete-java linter-javac;
# scala
${APM} install language-scala linter-scalac;
# elm
${APM} install language-elm linter-elm-make;
# erlang
${APM} install language-erlang;
# asm
${APM} install language-x86-64-assembly;
# lisp
${APM} install language-lisp;
# graphviz
${APM} install language-dot;
# llvm
${APM} install language-llvm;
# elixir
${APM} install language-elixir autocomplete-elixir linter-elixirc;

# IDE
${APM} install atom-ide-ui ide-csharp ide-java;
