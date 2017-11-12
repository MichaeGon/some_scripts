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
install x = run_ "code" ["--install-extension" x]

extensions :: [T.Text]
extensions =
    [ -- haskell
      "justusadam.language-haskell"
    , "hoovercj.vscode-ghc-mod"
    , "hoovercj.haskell-linter"
    ]