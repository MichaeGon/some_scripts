module SomeModule where

import qualified Data.ByteString.Char8 as B
import Data.Maybe

getWith :: (Read a) => (B.ByteString -> Maybe (a, B.ByteString)) -> B.ByteString -> (a, B.ByteString)
getWith f = br . fromJust . f
    where
        br (x, s)
            | B.null s = (x, s)
            | otherwise = (x, B.tail s)

get :: B.ByteString -> (Int, B.ByteString)
get = getWith B.readInt

get' :: B.ByteString -> (Integer, B.ByteString)
get' = getWith B.readInteger
