{-# LANGUAGE ApplicativeDo #-}
{-# LANGUAGE LambdaCase #-}

module Main where

import Control.Arrow ((&&&))
import Data.Bifunctor (second)
import Data.List (transpose)
import Data.Map (Map)
import Data.Map qualified as Map
import Data.Maybe (isJust)
import Data.Set (Set)
import Data.Set qualified as Set

type Input = [String]

type Coord = (Int, Int)

gridCoords :: String -> [(Coord, Char)]
gridCoords str =
  let rows = zip [0 ..] (lines str)
      cols = map (second (zip [0 ..])) rows
      mapped = [((a, x), y) | (a, b) <- cols, (x, y) <- b]
   in mapped

walk :: Set Coord -> (Coord, Coord) -> (Coord, Coord)
walk obs (pos@(i, j), dir@(di, dj))
  | Set.member next obs = (pos, newDir)
  | otherwise = (next, dir)
  where
    next = (i + di, j + dj)
    newDir = (dj, -di)

patrol :: (Int, Int) -> Set Coord -> Set (Coord, Coord) -> (Coord, Coord) -> Maybe (Set Coord)
patrol dims@(lx, ly) obs seen p@(pos, dir)
  | Set.member p seen = Nothing
  | not (inside pos) = Just seenPos
  | otherwise = patrol dims obs (Set.insert p seen) (walk obs p)
  where
    inside (x, y) = 0 <= x && x < lx && 0 <= y && y < ly
    seenPos = Set.fromList . map fst . Set.toList $ seen

loop :: (Int, Int) -> Set Coord -> (Coord, Coord) -> Coord -> Bool
loop dims obs p newObs
  | isJust path = False
  | otherwise = True
  where
    path = patrol dims (Set.insert newObs obs) Set.empty p

part1 :: String -> Int
part1 xs =
  let grid = gridCoords xs
      obs = Set.fromList . map fst . filter ((== '#') . snd) $ grid
      start = fst . head . filter ((== '^') . snd) $ grid
      dims = (length . lines $ xs, length . transpose . lines $ xs)
      Just path = patrol dims obs Set.empty (start, (-1, 0))
   in Set.size path

part2 :: String -> Int
part2 xs =
  let grid = gridCoords xs
      obs = Set.fromList . map fst . filter ((== '#') . snd) $ grid
      start = fst . head . filter ((== '^') . snd) $ grid
      dims = (length . lines $ xs, length . transpose . lines $ xs)
      Just path = patrol dims obs Set.empty (start, (-1, 0))
   in length . filter (== True) . map (loop dims obs (start, (-1, 0))) . Set.toList . Set.delete start $ path

main :: IO ()
main = do
  readFile "small1.txt" >>= print . part1
  readFile "small2.txt" >>= print . part2
  readFile "input.txt" >>= print . (part1 &&& part2)
