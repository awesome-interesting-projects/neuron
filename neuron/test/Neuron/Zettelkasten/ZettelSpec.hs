{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Neuron.Zettelkasten.ZettelSpec
  ( spec,
  )
where

import Data.Aeson
import Data.TagTree
import Data.Time.Calendar
import Neuron.Markdown
import Neuron.Zettelkasten.ID
import Neuron.Zettelkasten.Zettel
import Neuron.Zettelkasten.Zettel.Meta (Meta)
import Relude
import Test.Hspec

spec :: Spec
spec = do
  describe "sortZettelsReverseChronological" $ do
    let mkDay = fromGregorian 2020 3
        (_ :: Meta, _dummyContent) = either error id $ parseMarkdown "<spec>" "Dummy"
        noQueries = (mempty, mempty) -- TODO: test queries
        mkZettel day idx =
          Zettel (ZettelDateID (mkDay day) idx) "Some title" [Tag "science", Tag "journal/class"] (Just $ mkDay day) noQueries
    it "sorts correctly" $ do
      let zs = [mkZettel 3 2, mkZettel 5 1]
      sortZettelsReverseChronological zs
        `shouldBe` [mkZettel 5 1, mkZettel 3 2]
  describe "Zettel JSON" $ do
    let day = fromGregorian 2020 3 19
        zid = ZettelCustomID "Foo-Bar"
        noQueries = (mempty, mempty) -- TODO: test queries
        (_ :: Meta, _dummyContent) = either error id $ parseMarkdown "<spec>" "Dummy"
        zettel = Zettel zid "Some title" [Tag "science", Tag "journal/class"] (Just day) noQueries
    it "Produces expected json" $ do
      -- "{\"id\":\"2011401\",\"title\":\"Some title\",\"tags\":[\"science\"]}"
      object (zettelJson zettel)
        `shouldBe` object
          [ "id" .= ("Foo-Bar" :: Text),
            "title" .= ("Some title" :: Text),
            "tags" .= (["science", "journal/class"] :: [Text]),
            "day" .= day
          ]
