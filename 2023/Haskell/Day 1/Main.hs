{-# LANGUAGE ApplicativeDo #-}
{-# LANGUAGE LambdaCase #-}

module Main where

import Control.Arrow ((&&&))
import Data.Char

type Input = [String]

part1 :: Input -> Int
part1 = sum . map (read . (\xs -> [head xs, last xs]) . filter isDigit)

part2 :: Input -> Int
part2 = sum . map ((\xs -> 10 * head xs + last xs) . getNums)
  where
    getNums :: String -> [Int]
    getNums [] = []
    getNums ('z' : 'e' : 'r' : 'o' : xs) = 0 : getNums ('o' : xs)
    getNums ('o' : 'n' : 'e' : xs) = 1 : getNums ('e' : xs)
    getNums ('t' : 'w' : 'o' : xs) = 2 : getNums ('o' : xs)
    getNums ('t' : 'h' : 'r' : 'e' : 'e' : xs) = 3 : getNums ('e' : xs)
    getNums ('f' : 'o' : 'u' : 'r' : xs) = 4 : getNums xs
    getNums ('f' : 'i' : 'v' : 'e' : xs) = 5 : getNums ('e' : xs)
    getNums ('s' : 'i' : 'x' : xs) = 6 : getNums xs
    getNums ('s' : 'e' : 'v' : 'e' : 'n' : xs) = 7 : getNums ('n' : xs)
    getNums ('e' : 'i' : 'g' : 'h' : 't' : xs) = 8 : getNums ('t' : xs)
    getNums ('n' : 'i' : 'n' : 'e' : xs) = 9 : getNums ('e' : xs)
    getNums (x : xs)
      | isDigit x = digitToInt x : getNums xs
      | otherwise = getNums xs

prepare :: String -> Input
prepare = lines

main :: IO ()
main = do
  readFile "small1.txt" >>= print . part1 . prepare
  readFile "small2.txt" >>= print . part2 . prepare
  readFile "input.txt" >>= print . (part1 &&& part2) . prepare
