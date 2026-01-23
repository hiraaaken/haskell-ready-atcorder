{- |
Module      : LibSpec
Description : Tests for Lib module
-}
module LibSpec (spec) where

import Test.Hspec
import Lib (version)

spec :: Spec
spec = do
  describe "Lib" $ do
    describe "version" $ do
      it "returns the current version string" $ do
        version `shouldBe` "0.1.0"
