{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Lib
  ( run,
  )
where

import Data.Text (Text)
import Happstack.Lite
import Text.Blaze.Html5 (Html, a, p, toHtml, (!))
import qualified Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes (href)

myApp :: ServerPart Response
myApp =
  msum
    [dir "echo" echo, homePage]

homePage :: ServerPart Response
homePage =
  ok $
    template "home page" $ do
      H.h1 "Hello!"
      H.p "Here is a fun application written with happstack-lite"
      H.p $ a ! href "/echo/secret%20message" $ "echo"

echo :: ServerPart Response
echo =
  path $ \(msg :: String) ->
    ok $
      template "echo" $ do
        p $ "echo says: " >> toHtml msg
        p "Change the url to echo something else"

template :: Text -> Html -> Response
template title body = toResponse $
  H.html $ do
    H.head $ do
      H.title (toHtml title)
    H.body $ do
      body
      p $ a ! href "/" $ "back home"

config = ServerConfig {port = 8080, ramQuota = 2 ^ 16, diskQuota = 2 ^ 16, tmpDir = "./.tmp"}

run :: IO ()
run = serve (Just config) myApp
