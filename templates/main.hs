{- |
AtCoder solution template
Problem: {{PROBLEM_ID}}
Contest: {{CONTEST_ID}}
-}
import qualified Data.ByteString.Char8 as BS
import Data.Maybe (fromJust)

-- | Read a single integer from ByteString
readInt :: BS.ByteString -> Int
readInt = fst . fromJust . BS.readInt

-- | Read a line and parse as integer
getInt :: IO Int
getInt = readInt <$> BS.getLine

-- | Read a line and parse as list of integers
getInts :: IO [Int]
getInts = map readInt . BS.words <$> BS.getLine

-- | Main solution
solve :: IO ()
solve = do
  -- TODO: Implement solution
  return ()

main :: IO ()
main = solve
