{-# LANGUAGE ApplicativeDo #-}

module Main where

import Control.Arrow ((&&&))
import Data.Bifunctor (bimap)
import Data.Char (digitToInt)
import Data.Ix (inRange)
import Data.Map (Map, (!))
import Data.Set (Set)

import qualified Data.Map as M
import qualified Data.Set as S

type Input = [String]

toMap :: Int -> [[Int]] -> Map (Int, Int) Int
toMap _ [] = M.empty
toMap i (x : xs) = M.union (M.fromList . zipWith (\j x -> ((i, j), x)) [0 ..] $ x) (toMap (i + 1) xs)

inBounds :: Map (Int, Int) Int -> (Int, Int) -> Bool
inBounds points (i, j) =
  let ((m, n), _) = M.findMax points
   in inRange (0, m) i && inRange (0, n) j

adj :: (Int, Int) -> [(Int, Int)]
adj (i, j) =
  let dirs = [(0, 1), (0, -1), (1, 0), (-1, 0)]
   in map (bimap (i +) (j +)) dirs

ends :: Map (Int, Int) Int -> (Int, Int) -> [(Int, Int)]
ends points p
  | points ! p == 9 = [p]
  | otherwise =
      let curr = points ! p
          adjs = filter (\x -> points ! x == curr + 1) . filter (inBounds points) . adj $ p
       in concatMap (ends points) adjs

part1 :: Input -> Int
part1 xs =
  let points = toMap 0 . map (map digitToInt) $ xs
      zeros = M.keys . M.filter (== 0) $ points
   in sum . map (S.size . S.fromList . ends points) $ zeros

part2 :: Input -> Int
part2 xs =
  let points = toMap 0 . map (map digitToInt) $ xs
      zeros = M.keys . M.filter (== 0) $ points
   in sum . map (length . ends points) $ zeros

prepare :: String -> Input
prepare = lines

main :: IO ()
main = do
  readFile "small1.txt" >>= print . part1 . prepare
  readFile "small2.txt" >>= print . part2 . prepare
  readFile "input.txt" >>= print . (part1 &&& part2) . prepare
