#! /usr/bin/env stack
-- stack --resolver=lts-9.3 runghc --package=shelly

{-# LANGUAGE ExtendedDefaultRules, OverloadedStrings, ViewPatterns #-}
{-# OPTIONS_GHC -fno-warn-type-defaults #-}

import Shelly
import qualified Data.Text as T
import Prelude hiding (FilePath)
import System.Environment

default (T.Text)

data Arg = Arg { input :: FilePath, output :: Maybe FilePath}
    deriving (Show, Eq)

{-
flac file(s) -> alac file(s) using xld
-}
main :: IO ()
main = getArgs >>= shelly . shellyMain . parseOptions
    where
        shellyMain (Arg {input = x, output = Just y}) = checks >>= smf1
            where
                checks = sequence [test_d x, test_f y, test_d y, test_e y]
                smf1 [dx, fy, dy, ey]
                    | dx && fy = error "output filepath is not directory"
                    | dx && dy = recConv x y
                    | dx && not ey = recConv x y
                    | otherwise = conv x y

        shellyMain (Arg {input = x}) = test_d x >>= smf2
            where
                smf2 dx
                    | dx = recConv x x
                    | otherwise = conv x y
                y = fromText bn <.> "m4a"
                tx = toTextIgnore x
                bn
                    | ".flac" `T.isSuffixOf` tx = T.take (T.length tx - 5) tx
                    | otherwise = tx

parseOptions :: [String] -> Arg
parseOptions = build . poloop (Nothing, Nothing)
    where
        poloop (iacc, _) ("-o" : x : xs) = poloop (iacc, Just x) xs
        poloop _ ("-o" : _) = error "no output filepath"
        poloop (_, oacc) (x : xs) = poloop (Just x, oacc) xs
        poloop acc _ = acc

        build (Just x, Just y) = Arg {input = fromString x, output = Just $ fromString y}
        build (Just x, _) = Arg {input = fromString x, output = Nothing}
        build _ = error "no input filepath"

        fromString = fromText . T.pack

conv :: FilePath -> FilePath -> Sh ()
conv x y = echo (toTextIgnore x `T.append` " -> " `T.append` toTextIgnore y) >> run_ "xld" [toTextIgnore x, "-o", toTextIgnore y, "-f", "alac"]

recConv :: FilePath -> FilePath -> Sh ()
recConv x y = ls x >>= {-lsdebug >>=-} mapM_ mf
    where
        --lsdebug xs = echo ("ls " `T.append` toTextIgnore x `T.append` " is: ") >> mapM_ (echo . toTextIgnore) xs >> return xs
        mf c = test_d c >>= mff
            where
                mff dc  
                    | dc = echo ("Directory: " `T.append` toTextIgnore c) >> mkdir_p yc >> recConv c yc
                    | ".flac" `T.isSuffixOf` toTextIgnore c = conv c yc
                    | otherwise = echo ("Copying " `T.append` toTextIgnore c) >> cp c y
                    where
                        cn = getName c
                        yc
                            | dc = y </> cn
                            | otherwise = y </> editExt cn

getName :: FilePath -> FilePath
getName = fromText . T.takeWhileEnd (/= '/') . toTextIgnore

editExt :: FilePath -> FilePath
editExt x
    | ".flac" `T.isSuffixOf` tx = (fromText $ T.take (T.length tx - 5) tx) <.> "m4a"
    | otherwise = x <.> "m4a"
    where
        tx = toTextIgnore x