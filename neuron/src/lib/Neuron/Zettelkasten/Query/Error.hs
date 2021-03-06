{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Neuron.Zettelkasten.Query.Error where

import Data.Aeson
import Neuron.Zettelkasten.ID (InvalidID, ZettelID, zettelIDText)
import Neuron.Zettelkasten.Query.Error.Internal ()
import Relude
import Text.URI (URI)
import qualified Text.URI as URI

type QueryError = Either QueryParseError QueryResultError

data QueryParseError
  = QueryParseError_InvalidID URI InvalidID
  | QueryParseError_UnsupportedHost URI
  deriving (Eq, Show, Generic, ToJSON, FromJSON)

-- | This error is only thrown when *using* (eg: in HTML) the query results.
data QueryResultError = QueryResultError_NoSuchZettel ZettelID
  deriving (Eq, Show, Generic, ToJSON, FromJSON)

queryParseErrorUri :: QueryParseError -> URI
queryParseErrorUri = \case
  QueryParseError_InvalidID uri _ -> uri
  QueryParseError_UnsupportedHost uri -> uri

showQueryError :: QueryError -> Text
showQueryError = \case
  Left qe ->
    showQueryParseError qe
  Right re ->
    showQueryResultError re

showQueryParseError :: QueryParseError -> Text
showQueryParseError qe =
  let uri = URI.render (queryParseErrorUri qe)
   in uri <> ": " <> case qe of
        QueryParseError_UnsupportedHost _uri ->
          "unsupported host"
        QueryParseError_InvalidID _uri e'' ->
          "invalidID: " <> show e''

showQueryResultError :: QueryResultError -> Text
showQueryResultError (QueryResultError_NoSuchZettel zid) =
  "links to non-existant zettel: " <> zettelIDText zid
