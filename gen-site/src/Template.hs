{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Template where

import           Data.Text                     (Text, intercalate)
import           Text.InterpolatedString.Perl6 (q, qc)

type Template = Text

