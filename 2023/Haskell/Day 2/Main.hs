{-# LANGUAGE ApplicativeDo #-}
{-# LANGUAGE LambdaCase #-}

module Main where

import Control.Arrow ((&&&))
import Data.List (sort)
import Data.List.Split (splitOn, splitOneOf)

type Input = [String]

part1 :: Input -> Int
part1 = sum . map parse
  where
    getMax :: String -> Int
    getMax "red" = 12
    getMax "green" = 13
    getMax "blue" = 14

    parse :: String -> Int
    parse s =
      let colon = splitOn ":" s
          gameID = read (last (words (head colon)))
          draws = splitOneOf ";," (last colon)
          pairs = map ((\(x : y : _) -> (read x :: Int, getMax y)) . words) draws
          bools = map (uncurry (<=)) pairs
       in if and bools then gameID else 0

part2 :: Input -> Int
part2 = sum . map ((\(x, y, z) -> x * y * z) . parse)
  where
    getIndex :: String -> Int
    getIndex "red" = 0
    getIndex "green" = 1
    getIndex "blue" = 2

    makeTriple :: [(Int, Int)] -> (Int, Int, Int)
    makeTriple xs =
      let list = aux xs 0
          len = length list
       in if len == 1 then (head list, 0, 0) else if len == 2 then (head list, head (tail list), 0) else (head list, head (tail list), head (tail (tail list)))
      where
        aux :: [(Int, Int)] -> Int -> [Int]
        aux [] _ = []
        aux ((pos, val) : xs) i
          | i == pos = val : aux xs (i + 1)
          | otherwise = 0 : aux ((pos, val) : xs) (i + 1)

    parse :: String -> (Int, Int, Int)
    parse s =
      let colon = last (splitOn ":" s)
          draws = splitOn ";" colon
          pairs = map (map ((\(x : y : _) -> (getIndex y, read x :: Int)) . words) . splitOn ",") draws
          triples = map (makeTriple . sort) pairs
       in foldr (\(x, y, z) (a, b, c) -> (max x a, max y b, max z c)) (0, 0, 0) triples

prepare :: String -> Input
prepare = lines

main :: IO ()
main = do
  readFile "small1.txt" >>= print . part1 . prepare
  readFile "small2.txt" >>= print . part2 . prepare
  readFile "input.txt" >>= print . (part1 &&& part2) . prepare
