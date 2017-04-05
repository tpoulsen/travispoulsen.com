{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Template where

import           Data.Text                     (Text, intercalate)
import           Text.InterpolatedString.Perl6 (q, qc)
import           Types

siteTemplate :: Template -> Template
siteTemplate cards =
  [qc|<!DOCTYPE html>
<html>
  <head>
    <link rel="stylesheet" type="text/css" href="/static/css/main.css"/>
    <title>travis poulsen</title>
  </head>
  <body>
    <h1>travis poulsen</h1>
    <div class="content">
      {cards}
    </div>
    <div class="footer">
      <p>2014-2017 - Travis Poulsen</p>
    </div>
  </body>
</html>
|]

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
            {dotJoin . fmap wrapTag $ tags}
          </div>
        </div>
      </div>|]

wrapTag :: Text -> Template
wrapTag tag = [qc|<div>{tag}</div>|]

dotJoin :: Tags -> Template
dotJoin =
  intercalate [q|
            <div>•</div>
            |]
