{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

module Card where

import           Data.ByteString               (ByteString)
import           Data.Maybe                    (Maybe)
import           Data.Text                     (Text, intercalate)
import           Data.Yaml                     (decode)
import           Filesystem.Path.CurrentOS     hiding (decode)
import           Prelude                       hiding (FilePath)
import           Text.InterpolatedString.Perl6 (q, qc)
import           Types

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
