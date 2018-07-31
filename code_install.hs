#! /usr/bin/env stack
-- stack --resolver=lts-10.5 runghc --package=shelly

{-# LANGUAGE ExtendedDefaultRules, OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-type-defaults #-}

import Shelly
import qualified Data.Text as T
import Prelude hiding (FilePath)

default (T.Text)

main :: IO ()
main = shelly shellyMain
    where
        shellyMain = mapM_ install extensions
        
install :: T.Text -> Sh ()
install x = run_ "code" ["--install-extension", x]

extensions :: [T.Text]
extensions =
    [ -- haskell
      "justusadam.language-haskell"
    , "alanz.vscode-hie-server"
     -- rust
    , "rust-lang.rust"
     -- markdown
    , "hnw.vscode-auto-open-markdown-preview"
     -- elixir
    , "mjmcloug.vscode-elixir"
     -- c/c++
    , "ms-vscode.cpptools" -- default
    --, "llvm-vs-code-extensions.vscode-clangd" -- for clangd
     -- python
    , "ms-python.python"
     -- racket
    --, "Dmytro.racket"
     -- git
    , "vector-of-bool.gitflow"
    , "donjayamanne.githistory"
     -- bazel
    , "DevonDCarew.bazel-code"
    -- fsharp
    , "ionide.ionide-fsharp"
	-- pdf viewer
    , "tomoki1207.pdf"
    -- bracket
    , "CoenraadS.bracket-pair-colorizer"
    ]