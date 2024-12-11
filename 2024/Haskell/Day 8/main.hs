{-# LANGUAGE ApplicativeDo #-}
{-# LANGUAGE LambdaCase #-}

module Main where

import Control.Arrow ((&&&))
import Data.List (nub, sort, tails)
import Data.Map (Map)
import Data.Map qualified as Map

type Coord = (Int, Int)

combinations :: Int -> [a] -> [[a]]
combinations 0 _ = [[]]
combinations n xs = [y : ys | y : xs' <- tails xs, ys <- combinations (n - 1) xs']

inside :: [(Coord, Char)] -> Coord -> Bool
inside coords (i, j) =
  let maxRow = maximum . map (\((i, j), c) -> i) $ coords
      maxCol = maximum . map (\((i, j), c) -> j) $ coords
   in 0 <= i && i <= maxRow && 0 <= j && j <= maxCol

gridCoords :: String -> [(Coord, Char)]
gridCoords str = [((i, j), c) | (i, r) <- zip [0 ..] (lines str), (j, c) <- zip [0 ..] r]

getOne :: Coord -> Coord -> [Coord]
getOne (i1, j1) (i2, j2) =
  let (di, dj) = (i1 - i2, j1 - j2)
   in [(i1 + di, j1 + dj), (i2 - di, j2 - dj)]

getAll :: ([Coord] -> [Coord]) -> Coord -> Coord -> [Coord]
getAll f (i1, j1) (i2, j2) =
  let (di, dj) = (i1 - i2, j1 - j2)
      pos = f [(i1 + (di * n), j1 + (dj * n)) | n <- [0 ..]]
      neg = f [(i2 - (di * n), j2 - (dj * n)) | n <- [0 ..]]
   in pos ++ neg

part1 :: String -> Int
part1 xs =
  let cityCoords = gridCoords xs
      antennas = filter (\(_, c) -> c /= '.') cityCoords
      antinodes = nub . concatMap (\[a, b] -> getOne (fst a) (fst b)) . filter (\[a, b] -> snd a == snd b) . combinations 2 $ antennas
   in length . filter (inside cityCoords) $ antinodes

part2 :: String -> Int
part2 xs =
  let cityCoords = gridCoords xs
      antennas = filter (\(_, c) -> c /= '.') cityCoords
      antinodes = nub . concatMap (\[a, b] -> getAll (takeWhile (inside cityCoords)) (fst a) (fst b)) . filter (\[a, b] -> snd a == snd b) . combinations 2 $ antennas
   in length antinodes

main :: IO ()
main = do
  readFile "small1.txt" >>= print . part1
  readFile "small2.txt" >>= print . part2
  readFile "input.txt" >>= print . (part1 &&& part2)
