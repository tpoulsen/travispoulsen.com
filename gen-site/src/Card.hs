{-# LANGUAGE OverloadedStrings #-}

module Card where

import           Data.ByteString           (ByteString)
import           Data.Maybe                (Maybe)
import           Data.Yaml                 (decode)
import           Filesystem.Path.CurrentOS hiding (decode)
import           Prelude                   hiding (FilePath)
import           Template
import           Types

readCards :: ByteString -> Maybe [Card]
readCards = decode

genCardDiv :: Maybe Card -> Maybe Template
genCardDiv c = c >>= pure . cardTemplate

