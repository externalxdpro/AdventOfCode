{-# LANGUAGE ApplicativeDo #-}
{-# LANGUAGE LambdaCase #-}

module Main where

import Control.Applicative ((<*>))
import Control.Arrow ((&&&))

type Input = [String]

safe :: [Int] -> Bool
safe xs
  | head diff > 0 = all (\n -> 1 <= n && n <= 3) diff
  | head diff < 0 = all (\n -> -3 <= n && n <= -1) diff
  | otherwise = False
  where
    diff = zipWith (-) xs (tail xs)

sublists :: [Int] -> [[Int]]
sublists xs = [take i xs ++ drop (i + 1) xs | i <- [0 .. length xs]]

part1 :: Input -> Int
part1 xs =
  let parsed :: [[Int]] = map (map read . words) xs
   in length $ filter (== True) (map safe parsed)

part2 :: Input -> Int
part2 xs =
  let parsed = map (map read . words) xs
   in length $ filter (== True) $ map (any safe . sublists) parsed

prepare :: String -> Input
prepare = lines

main :: IO ()
main = do
  readFile "small1.txt" >>= print . part1 . prepare
  readFile "small2.txt" >>= print . part2 . prepare
  readFile "input.txt" >>= print . (part1 &&& part2) . prepare
