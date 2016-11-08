#! /usr/bin/env stack
-- stack --resolver=lts-7.1 runghc --package=shelly

{-# LANGUAGE OverloadedStrings, ExtendedDefaultRules #-}
{-# OPTIONS_GHC -fno-warn-type-defaults #-}
import Shelly
import System.Info
import qualified Data.Text as T
default (T.Text)

main :: IO ()
main = shelly $ run_ "echo" [T.pack os]
