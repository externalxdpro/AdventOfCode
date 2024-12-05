{-# LANGUAGE ApplicativeDo #-}
{-# LANGUAGE LambdaCase #-}

module Main where

import Control.Arrow ((&&&))
import Data.List (transpose)

type Input = [String]

diagonals :: [String] -> [String]
diagonals [] = []
diagonals ([] : xss) = xss
diagonals xss =
  zipWith
    (++)
    (map ((: []) . head) xss ++ repeat [])
    ([] : diagonals (map tail xss))

count :: String -> Int
count [] = 0
count ('X' : 'M' : 'A' : 'S' : xs) = 1 + count xs
count (_ : xs) = count xs

submatrices :: Int -> [String] -> [[String]]
submatrices n =
  map transpose . concatMap (groups n . transpose) . groups n
  where
    groups n xs = [take n $ drop i xs | i <- [0 .. length xs - n]]

isCross :: [String] -> Bool
isCross = any cross . sequence [id, transpose, reverse, reverse . transpose]
  where
    cross [['M', _, 'M'], [_, 'A', _], ['S', _, 'S']] = True
    cross _ = False

part1 :: Input -> Int
part1 xs = sum . map (sum . map count) $ (allDiags xs ++ allDir xs)
  where
    allDir xs = [xs, transpose xs, map reverse xs, (map reverse . transpose) xs]
    allDiags xs = map diagonals [xs, transpose xs, map reverse xs, (reverse . transpose) xs]

part2 :: Input -> Int
part2 = length . filter id . map isCross . submatrices 3

prepare :: String -> Input
prepare = lines

main :: IO ()
main = do
  readFile "small1.txt" >>= print . part1 . prepare
  readFile "small2.txt" >>= print . part2 . prepare
  readFile "input.txt" >>= print . (part1 &&& part2) . prepare
