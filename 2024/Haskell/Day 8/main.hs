{-# LANGUAGE ApplicativeDo #-}
{-# LANGUAGE LambdaCase #-}

module Main where

import Control.Arrow ((&&&))
import Data.Bifunctor (second)
import Data.List (nub, sort, tails)
import Data.Map (Map)
import Data.Map qualified as Map

type Coord = (Int, Int)

combinations :: Int -> [a] -> [[a]]
combinations 0 _ = [[]]
combinations n xs = [y : ys | y : xs' <- tails xs, ys <- combinations (n - 1) xs']

inside :: Map Coord Char -> Coord -> Bool
inside coords (i, j) =
  let list = Map.toList coords
      maxRow = maximum . map (\((i, j), c) -> i) $ list
      maxCol = maximum . map (\((i, j), c) -> j) $ list
   in 0 <= i && i <= maxRow && 0 <= j && j <= maxCol

gridToMap :: String -> Map Coord Char
gridToMap str =
  Map.fromList
    [((i, j), c) | (i, r) <- zip [0 ..] (lines str), (j, c) <- zip [0 ..] r]

get :: Coord -> Coord -> [Coord]
get (i1, j1) (i2, j2) =
  let (di, dj) = (i1 - i2, j1 - j2)
   in [(i1 + di, j1 + dj), (i2 - di, j2 - dj)]

getAll :: Coord -> Coord -> [Coord]
getAll (i1, j1) (i2, j2) =
  let (di, dj) = (i1 - i2, j1 - j2)
   in concat [[(i1 + (di * n), j1 + (dj * n)), (i2 - (di * n), j2 - (dj * n))] | n <- [0 .. 100]]

part1 :: String -> Int
part1 str =
  let cityMap = gridToMap str
      antennas = nub . concatMap (\[a, b] -> get (fst a) (fst b)) . filter (\[a, b] -> snd a == snd b) . combinations 2 . Map.toList . Map.filter (/= '.') $ cityMap
      filtered = filter (inside cityMap) antennas
   in length filtered

part2 :: String -> Int
part2 str =
  let cityMap = gridToMap str
      antennas = nub . filter (inside cityMap) . concatMap (\[a, b] -> getAll (fst a) (fst b)) . filter (\[a, b] -> snd a == snd b) . combinations 2 . Map.toList . Map.filter (/= '.') $ cityMap
      filtered = filter (inside cityMap) antennas
   in length filtered

main :: IO ()
main = do
  readFile "small1.txt" >>= print . part1
  readFile "small2.txt" >>= print . part2
  readFile "input.txt" >>= print . (part1 &&& part2)
