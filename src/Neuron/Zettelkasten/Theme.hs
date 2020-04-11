{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE Rank2Types #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TupleSections #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE ViewPatterns #-}
{-# LANGUAGE NoImplicitPrelude #-}

-- | HTML & CSS
module Neuron.Zettelkasten.Theme where

import Data.Text (toLower)
import Relude

-- | Neuron color theme
--
-- Each theme corresponds to the color supported by Semantic UI
-- https://semantic-ui.com/usage/theming.html#sitewide-defaults
data Theme
  = Teal
  | Brown
  deriving (Eq, Show)

withRgb :: Theme -> (Integer -> Integer -> Integer -> a) -> a
withRgb theme f =
  case theme of
    Teal ->
      f 0 128 128
    Brown ->
      f 165 42 42

-- | Convert Theme to Semantic UI color name
semanticColor :: Theme -> Text
semanticColor = toLower . show @Text

-- | Make Theme from Semantic UI color name
mkTheme :: Text -> Theme
mkTheme = \case
  "teal" -> Teal
  "brown" -> Brown
  s -> error $ "Unsupported theme name: " <> s

defaultTheme :: Theme
defaultTheme = Teal
