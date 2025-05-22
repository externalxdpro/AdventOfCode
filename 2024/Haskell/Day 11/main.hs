{-# LANGUAGE ApplicativeDo #-}
{-# LANGUAGE TypeApplications #-}

module Main where

import Control.Arrow ((&&&))
import Data.IntMap (IntMap)
import Data.IntMap qualified as IM

type Input = [String]

blink :: Int -> [Int]
blink x
  | x == 0 = [1]
  | even (length (show x)) =
      let num = show x
          (l, r) = splitAt (length num `div` 2) num
       in [read l, read r]
  | otherwise = [x * 2024]

blinkMap :: IntMap Int -> IntMap Int
blinkMap = IM.fromListWith (+) . concatMap (\(x, n) -> map (,n) (blink x)) . IM.assocs

part1 :: String -> Int
part1 xs =
  let nums = map (read @Int) . words $ xs
   in length . (!! 25) . iterate (concatMap blink) $ nums

part2 :: String -> Int
part2 xs =
  let nums = map (read @Int) . words $ xs
   in sum . IM.elems . (!! 75) . iterate blinkMap . IM.fromListWith (+) . map (,1) $ nums

prepare :: String -> Input
prepare = lines

main :: IO ()
main = do
  readFile "small1.txt" >>= print . part1 . head . prepare
  readFile "small2.txt" >>= print . part2 . head . prepare
  readFile "input.txt" >>= print . (part1 &&& part2) . head . prepare
