{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

module Card (
    Link(..)
  , Tags
  , Card(..)
  , readCards
  ) where

import           Data.Text    (Text, intercalate)
import           Data.Yaml    (FromJSON, ToJSON, decodeFile)
import           GHC.Generics
import           Text.InterpolatedString.Perl6 (q, qc)

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

readCards :: FilePath -> IO (Maybe [Card])
readCards = decodeFile

genCardDiv :: Card -> Text
genCardDiv (Card link bodyText tags) =
  cardTemplate link bodyText tags

cardTemplate :: Link -> Text -> Tags -> Template
cardTemplate (Link href desc) bodyText tags = [qc|
<div class="card">
  <div class="card-header">
    <a class="main-nav-link" href="{href}"><h3>{desc}</h3></a>
  </div>
  <div class="card-body">
    <div>
      {bodyText}
    </div>
    <div class="card-footer">
      {dotJoin . map wrapTag $ tags}
    </div>
  </div>
</div>
|]

wrapTag :: Text -> Template
wrapTag tag = [qc|<div>{tag}</div>|]

dotJoin :: Tags -> Template
dotJoin =
  intercalate [q|<div>•</div>|]
