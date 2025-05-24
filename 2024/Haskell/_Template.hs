{-# LANGUAGE ApplicativeDo #-}
{-# LANGUAGE LambdaCase #-}

module Main where

import Control.Arrow ((&&&))

type Input = [String]

part1 :: Input -> ()
part1 = const ()

part2 :: Input -> ()
part2 = const ()

main :: IO ()
main = do
  readFile "example" >>= print . (part1 &&& part2) . lines
  readFile "input" >>= print . (part1 &&& part2) . lines
