{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Card
import           Data.Text                 as T hiding (unfoldr)
import           Data.Text.Encoding
import           Filesystem.Path.CurrentOS
import           Prelude                   hiding (FilePath)
import           System.Environment        (getArgs)
import           Template                  (siteTemplate)
import           Turtle
import           Types                     (OSFilePath, Template)

parser :: Parser (OSFilePath, OSFilePath)
parser = (,) <$> optPath "cardYaml" 'f' "Yaml file with card data"
             <*> optPath "output" 'o' "Filepath for output html"

main :: IO ()
main = do
  (cardYaml, output) <- options "Gen Site" parser
  rawCards <- readTextFile cardYaml
  let cards = readCards $ encodeUtf8 rawCards
  let cardDivs = mapM genCardDiv . sequence $ cards
  writeOutput output cardDivs
  echo "Done :)"

writeOutput :: OSFilePath -> Maybe [Template] -> IO ()
writeOutput out cards =
  case cards of
    Just html ->
      writeTextFile out . siteTemplate . T.concat $ html
    Nothing ->
      echo "No cards present"
