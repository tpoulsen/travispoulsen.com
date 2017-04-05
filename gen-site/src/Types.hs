{-# LANGUAGE DeriveGeneric     #-}

module Types where

import           Filesystem.Path.CurrentOS
import           Data.Text                     (Text)
import           Data.Yaml                     (FromJSON, ToJSON)
import           GHC.Generics

type OSFilePath = Filesystem.Path.CurrentOS.FilePath
type Template = Text
type Tags = [Text]

data Link = Link
  { href :: Text
  , desc :: Text
  } deriving (Generic, Show)
instance ToJSON Link
instance FromJSON Link

data Card = Card
  { link     :: Link
  , bodyText :: Text
  , tags     :: Tags
  } deriving (Generic, Show)
instance ToJSON Card
instance FromJSON Card

