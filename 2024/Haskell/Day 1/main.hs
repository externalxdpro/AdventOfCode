{-# LANGUAGE ApplicativeDo #-}
{-# LANGUAGE LambdaCase #-}

module Main where

import Control.Arrow ((&&&))
import Data.List (sort, transpose)

type Input = [String]

-- Original part1
-- intoArr :: [(Int, Int)] -> [[Int]]
-- intoArr [] = [[], []]
-- intoArr ((a, b) : xs) = [a : as, b : bs]
--   where
--     [as, bs] = intoArr xs

-- sub :: [Int] -> [Int] -> [Int]
-- sub [] _ = []
-- sub _ [] = []
-- sub (x:xs) (y:ys) = abs (x-y) : sub xs ys

-- part1 :: Input -> Int
-- part1 xs =
--   let [l, r] = map sort (intoArr (map ((\[a, b] -> (read a, read b)) . words) xs))
--    in sum (sub l r)

part1 :: Input -> Int
part1 xs =
  let [a, b] = map sort $ transpose $ map ((\[a, b] -> [read a, read b]) . words) xs
   in sum . map abs $ zipWith (-) a b

part2 :: Input -> Int
part2 xs =
  let [a, b] = transpose $ map ((\[a, b] -> [read a, read b]) . words) xs
   in sum $ zipWith (*) a (map (length . \x -> filter (== x) b) a)

prepare :: String -> Input
prepare = lines

main :: IO ()
main = do
  readFile "small1.txt" >>= print . part1 . prepare
  readFile "small2.txt" >>= print . part2 . prepare
  readFile "input.txt" >>= print . (part1 &&& part2) . prepare
