{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

module Card where

import           Data.ByteString               (ByteString)
import           Data.Maybe                    (Maybe)
import           Data.Text                     (Text, intercalate)
import           Data.Yaml                     (FromJSON, ToJSON, decode)
import           Filesystem.Path.CurrentOS     hiding (decode)
import           GHC.Generics
import           Prelude                       hiding (FilePath)
import           Text.InterpolatedString.Perl6 (q, qc)
import           Types

data Link = Link
  { href :: Text
  , desc :: Text
  } deriving (Generic, Show)
instance ToJSON Link
instance FromJSON Link

type Template = Text
type Tags = [Text]
data Card = Card
  { link     :: Link
  , bodyText :: Text
  , tags     :: Tags
  } deriving (Generic, Show)
instance ToJSON Card
instance FromJSON Card

readCards :: ByteString -> Maybe [Card]
readCards = decode

genCardDiv :: Maybe Card -> Maybe Template
genCardDiv c = c >>= pure . cardTemplate

cardTemplate :: Card -> Template
cardTemplate (Card (Link href desc) bodyText tags) = [qc|
<div class="card">
  <div class="card-header">
    <a class="main-nav-link" href="{href}"><h3>{desc}</h3></a>
  </div>
  <div class="card-body">
    <div>
      {bodyText}
    </div>
    <div class="card-footer">
      {dotJoin . Prelude.map wrapTag $ tags}
    </div>
  </div>
</div>
|]

wrapTag :: Text -> Template
wrapTag tag = [qc|<div>{tag}</div>|]

dotJoin :: Tags -> Template
dotJoin =
  intercalate [q|<div>•</div>|]
