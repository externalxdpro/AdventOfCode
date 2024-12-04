{-# LANGUAGE ApplicativeDo #-}
{-# LANGUAGE LambdaCase #-}

module Main where

import Control.Arrow ((&&&))
import Data.List.Split (splitOn)
import Text.Regex.TDFA (getAllMatches, (=~))

type Input = [String]

parse :: [[String]] -> [Int]
parse = f True
  where
    f _ [] = []
    f _ (("do()" : _) : xs) = f True xs
    f _ (("don't()" : _) : xs) = f False xs
    f True ([_, x, y] : xs) = read x * read y : f True xs
    f False (_ : xs) = f False xs

part1 :: String -> Int
part1 xs =
  let regex = "mul\\(([0-9]+),([0-9]+)\\)"
   in sum $ parse (xs =~ regex)

part2 :: String -> Int
part2 xs =
  let regex = "mul\\(([0-9]+),([0-9]+)\\)|do\\(\\)|don't\\(\\)"
   in sum $ parse (xs =~ regex)

main :: IO ()
main = do
  readFile "small1.txt" >>= print . part1
  readFile "small2.txt" >>= print . part2
  readFile "input.txt" >>= print . (part1 &&& part2)
