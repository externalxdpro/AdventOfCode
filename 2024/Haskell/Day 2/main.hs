{-# LANGUAGE ApplicativeDo #-}
{-# LANGUAGE LambdaCase #-}

module Main where

import Control.Applicative ((<*>))
import Control.Arrow ((&&&))

type Input = [String]

check :: [Int] -> Bool
check xs = not (any (< 0) xs) || not (any (> 0) xs)

inRange :: [Int] -> Bool
inRange xs = not (any ((\x -> x < 1 || x > 3) . abs) xs)

andList :: [Bool] -> [Bool] -> [Bool]
andList _ [] = []
andList [] _ = []
andList (x : xs) (y : ys) = (x && y) : andList xs ys

sublists :: [Int] -> [[Int]]
sublists xs = [take i xs ++ drop (i + 1) xs | i <- [0 .. length xs]]

part1 :: Input -> Int
part1 xs =
  let parsed = [map read x | x <- map words xs]
      pairs = map (zip <*> tail) parsed
      diff = [map (uncurry (-)) x | x <- pairs]
      (a, b) = (map check diff, map inRange diff)
      anded = andList a b
   in length (filter (== True) anded)

-- part2 :: Input -> [[Bool]]
part2 xs =
  let parsed = [map read x | x <- map words xs]
      subs = map sublists parsed
      pairs = (map . map) (zip <*> tail) subs
      diff = (map . map . map) (uncurry (-)) pairs
      checked = (map . map) check diff
      ranged = (map . map) inRange diff
      anded =zipWith andList checked ranged
   in length (filter (== True) (map or anded))

prepare :: String -> Input
prepare = lines

main :: IO ()
main = do
  readFile "small1.txt" >>= print . part1 . prepare
  readFile "small2.txt" >>= print . part2 . prepare
  readFile "input.txt" >>= print . (part1 &&& part2) . prepare
