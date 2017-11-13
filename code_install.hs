#! /usr/bin/env stack
-- stack --resolver=lts-9.3 runghc --package=shelly

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
    --, "ms-vscode.cpptools" -- default
    , "llvm-vs-code-extensions.vscode-clangd" -- for clang
     -- python
    , "ms-python.python"
     -- git
    , "vector-of-bool.gitflow"
    , "donjayamanne.githistory"
    ]