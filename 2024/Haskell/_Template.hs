{-# LANGUAGE ApplicativeDo #-}
{-# LANGUAGE LambdaCase #-}

module Main where

import Control.Arrow ((&&&))

type Input = [String]

part1 :: Input -> ()
part1 = const ()

part2 :: Input -> ()
part2 = const ()

prepare :: String -> Input
prepare = lines

main :: IO ()
main = do
  readFile "small1.txt" >>= print . part1 . prepare
  readFile "small2.txt" >>= print . part2 . prepare
  readFile "input.txt" >>= print . (part1 &&& part2) . prepare
