{-# LANGUAGE ApplicativeDo #-}
{-# LANGUAGE LambdaCase #-}

module Main where

import Control.Arrow ((&&&))
import Data.List.Split (splitOn)
import Data.Map (Map, fromList, (!), findWithDefault, member, fromListWith, toList)
import Data.List (sortBy)

type Input = [String]

isOrdered :: Map Int [Int] -> [Int] -> Bool
isOrdered rules update = all good updateIs
  where updateIs = zip update [0..]
        iMap = fromList updateIs
        good (page, i) = all (i < ) rulesIs
          where pageRules = findWithDefault [] page rules
                rulesIs = map (iMap !) . filter (`member` iMap) $ pageRules

getMid :: [Int] -> Int
getMid xs = xs !! div (length xs) 2

sortPages :: Map Int [Int] -> [Int] -> [Int]
sortPages rules update = let relevant' = filter ((`elem` update) . fst) . toList $ rules
                             relevant = map (\(a,b) -> (a, filter (`elem` update) b)) relevant'
                             sorted = sortBy (\(_,a) (_,b) -> compare (length b) (length a)) relevant
                         in map fst sorted

part1 :: [String] -> Int
part1 xs =
  let [rules', updates'] = map lines xs
      rules :: Map Int [Int] = fromListWith (++) . map ((\[a, b] -> (read a, [read b])) . splitOn "|") $ rules'
      updates :: [[Int]] = map (map read . splitOn ",") updates'
   in sum . map getMid . filter (isOrdered rules) $ updates

part2 :: Input -> Int
part2 xs =
  let [rules', updates'] = map lines xs
      rules :: Map Int [Int] = fromListWith (++) . map ((\[a, b] -> (read a, [read b])) . splitOn "|") $ rules'
      updates :: [[Int]] = map (map read . splitOn ",") updates'
      filtered = filter (not . isOrdered rules) updates
      in sum . map (getMid . sortPages rules) $ filtered

prepare :: String -> Input
prepare = splitOn "\n\n"

main :: IO ()
main = do
  readFile "small1.txt" >>= print . part1 . prepare
  readFile "small2.txt" >>= print . part2 . prepare
  readFile "input.txt" >>= print . (part1 &&& part2) . prepare
