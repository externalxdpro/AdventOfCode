{-# LANGUAGE ApplicativeDo #-}
{-# LANGUAGE LambdaCase #-}

module Main where

import Control.Arrow ((&&&))
import Data.List.Split (splitOn)
import Data.Bifunctor (second)

type Input = [String]

calibrate :: [Int -> Int -> Int] -> [Int] -> [Int]
calibrate fs (x:xs) = aux xs x
  where
    aux :: [Int] -> Int -> [Int]
    aux [] total = [total]
    aux (y:ys) total = concatMap (aux ys) . sequence (sequence fs total) $ y

(|||) :: Int -> Int -> Int
a ||| b = read (show a ++ show b)

part1 :: [(Int, [Int])] -> Int
part1 = let ops = [(+),(*)]
        in
          sum . map fst . filter (uncurry elem) .  map (second (calibrate ops))

part2 :: [(Int, [Int])] -> Int
part2 = let ops = [(+),(*),(|||)]
        in sum . map fst . filter (uncurry elem) .  map (second (calibrate ops))

prepare :: String -> [(Int, [Int])]
prepare =map ((\[a,b] ->(read a, map read (splitOn " " b))) . splitOn ": ") . lines

main :: IO ()
main = do
  readFile "small1.txt" >>= print . part1 . prepare
  -- readFile "small2.txt" >>= print . part2 . prepare
  readFile "input.txt" >>= print . (part1 &&& part2) . prepare
