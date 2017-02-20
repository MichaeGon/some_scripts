#! /usr/bin/env stack
-- stack --resolver=lts-7.4 runghc --package=shelly

{-# LANGUAGE ExtendedDefaultRules, OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-type-defaults #-}

import Control.Exception
import Data.List
import Shelly hiding (FilePath, (</>), (<.>))
import System.Directory
import System.FilePath
import System.IO
import qualified Data.Text as T

default (T.Text)

src :: FilePath
src = ".atom" </> "packages" </> "script" </> "lib" </> "grammars" <.> "coffee"

main :: IO ()
main = getHomeDirectory >>= main'
    where
        main' h = readFile path >>= useBracket
            where
                path = h </> src

                useBracket s = bracketOnError (openTempFile "." "tmp")
                                (\(p, h)
                                    -> hClose h
                                    >> removeFile p
                                )
                                (\(p, h)
                                    -> hPutStr h (edit s)
                                    >> hClose h
                                    >> removeFile path
                                    >> renameFile p path
                                    >> putStrLn "done"
                                )

edit :: String -> String
edit = unlines . replace . lines

replace :: [String] -> [String]
replace (x : y : zs)
    | "\"latexmk\"" `isSuffixOf` x = "      command: \"ptex2pdf\"" : "      args: (context) -> ['-l', '-ot', '\"-synctex=1 -file-line-error\"', context.filepath]" : zs
    | otherwise = x : replace (y : zs)
replace xs = xs
