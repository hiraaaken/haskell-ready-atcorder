{- |
Module      : Types
Description : Core types for atcoder-problem-fetcher
Copyright   : (c) 2026 kenta
License     : MIT

This module defines the core types used throughout the application.
-}
module Types
    ( -- * Command Types
      Command (..)
    , FetchOptions (..)
    , SetupOptions (..)
      -- * Error Types
    , FetchError (..)
      -- * Config Types
    , Config (..)
    , defaultConfig
      -- * Domain Types
    , UrlType (..)
    , AtCoderUrl (..)
    , ContestId
    , ProblemId
    , Problem (..)
    , Sample (..)
    ) where

import Data.Text (Text)

-- | CLI command type
data Command
    = Fetch FetchOptions
    | Setup SetupOptions
    deriving (Show, Eq)

-- | Options for the fetch command
data FetchOptions = FetchOptions
    { fetchUrl    :: Text        -- ^ AtCoder URL to fetch
    , outputDir   :: Maybe FilePath  -- ^ Output directory (optional)
    , forceWrite  :: Bool        -- ^ Force overwrite existing files
    } deriving (Show, Eq)

-- | Options for the setup command
data SetupOptions
    = SetupInteractive  -- ^ Interactive configuration mode
    | SetupShow         -- ^ Show current configuration
    | SetupReset        -- ^ Reset configuration to defaults
    deriving (Show, Eq)

-- | Error types for the application
data FetchError
    = NetworkError Text   -- ^ Network-related errors
    | ParseError Text     -- ^ HTML parsing errors
    | FileError Text      -- ^ File system errors
    | UrlError Text       -- ^ URL validation errors
    deriving (Show, Eq)

-- | Application configuration
data Config = Config
    { defaultOutputDir :: Maybe FilePath  -- ^ Default output directory
    , templatePath     :: Maybe FilePath  -- ^ Custom template file path
    } deriving (Show, Eq)

-- | Default configuration
defaultConfig :: Config
defaultConfig = Config
    { defaultOutputDir = Nothing
    , templatePath = Nothing
    }

-- | Type of AtCoder URL
data UrlType
    = ContestUrl ContestId        -- ^ Contest task list URL
    | ProblemUrl ContestId ProblemId  -- ^ Single problem URL
    deriving (Show, Eq)

-- | Contest identifier (e.g., "abc300")
type ContestId = Text

-- | Problem identifier (e.g., "a", "abc300_a")
type ProblemId = Text

-- | Parsed AtCoder URL
data AtCoderUrl = AtCoderUrl
    { urlType :: UrlType  -- ^ Type of URL (contest or problem)
    , rawUrl  :: Text     -- ^ Original URL string
    } deriving (Show, Eq)

-- | Problem data extracted from AtCoder
data Problem = Problem
    { problemId     :: ProblemId   -- ^ Problem ID
    , problemTitle  :: Text        -- ^ Problem title
    , problemBody   :: Text        -- ^ Problem statement
    , constraints   :: Text        -- ^ Constraints section
    , inputFormat   :: Text        -- ^ Input format
    , outputFormat  :: Text        -- ^ Output format
    , samples       :: [Sample]    -- ^ Sample input/output pairs
    } deriving (Show, Eq)

-- | Sample input/output pair
data Sample = Sample
    { sampleInput  :: Text  -- ^ Sample input
    , sampleOutput :: Text  -- ^ Expected output
    } deriving (Show, Eq)
