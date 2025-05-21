{-# LANGUAGE ApplicativeDo #-}
{-# LANGUAGE LambdaCase #-}

module Main where

import Control.Arrow ((&&&))
import Data.Char
import Data.Foldable
import Data.Sequence (Seq ((:<|), (:|>)), (<|), (|>))
import Data.Sequence qualified as Seq

type Input = [String]

pairs :: [Int] -> [(Int, Int)]
pairs [] = []
pairs [x] = [(x, 0)]
pairs (x : y : xs) = (x, y) : pairs xs

genDisk :: [Int] -> [[Int]]
genDisk = filter (not . null) . zipWith (\i n -> replicate n (if odd i then -1 else i `div` 2)) [0 ..]

compress1 :: [Int] -> [Int]
compress1 [] = []
compress1 [x] = [x]
compress1 (x : xs)
  | last xs == -1 = compress1 (x : init xs)
  | x == -1 = last xs : compress1 (init xs)
  | otherwise = x : compress1 xs

sinit :: Seq a -> Seq a
sinit (xs :|> x) = xs

slast :: Seq a -> a
slast (xs :|> x) = x

compress2 :: Seq [Int] -> Seq [Int]
compress2 Seq.Empty = Seq.empty
compress2 (x :<| Seq.Empty) = Seq.singleton x
compress2 xs =
  let (swapped :|> x) = swap xs
   in compress2 swapped |> x
  where
    swap Seq.Empty = Seq.empty
    swap (x :<| Seq.Empty) = Seq.singleton x
    swap (x :<| xs)
      | head (slast xs) == -1 = swap (x <| sinit xs) |> slast xs
      | head x == -1 =
          let l = slast xs
              ll = length l
              i = sinit xs
           in case compare ll (length x) of
                LT -> (l <| drop ll x <| i) |> take ll x
                EQ -> (l <| i) |> x
                GT -> x <| swap xs
      | otherwise = x <| swap xs

part1 :: String -> Int
part1 xs =
  let converted = concat . genDisk . map digitToInt $ xs
   in sum . zipWith (*) [0 ..] . compress1 $ converted

part2 :: String -> Int
part2 xs =
  let converted = genDisk . map digitToInt $ xs
      packed = compress2 . Seq.fromList . filter (not . null) $ converted
   in sum . zipWith (\a b -> if b /= -1 then a * b else 0) [0 ..] . concat $ packed

prepare :: String -> Input
prepare = lines

main :: IO ()
main = do
  readFile "small1.txt" >>= print . part1 . head . prepare
  readFile "small2.txt" >>= print . part2 . head . prepare
  readFile "input.txt" >>= print . (part1 &&& part2) . head . prepare
