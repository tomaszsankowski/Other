-- this haskell code generates all lexicographically sorted
-- permutations of m digits and returns
-- the n-th number from its order

convertToHex :: Int -> String
convertToHex 10 = "A"
convertToHex 11 = "B"
convertToHex 12 = "C"
convertToHex 13 = "D"
convertToHex 14 = "E"
convertToHex 15 = "F"
convertToHex m = convertToChar m

convertToChar :: Int -> String
convertToChar 0 = "0"
convertToChar 1 = "1"
convertToChar 2 = "2"
convertToChar 3 = "3"
convertToChar 4 = "4"
convertToChar 5 = "5"
convertToChar 6 = "6"
convertToChar 7 = "7"
convertToChar 8 = "8"
convertToChar 9 = "9"

convertDigits :: Int -> String
convertDigits 0 = "0"
convertDigits m
  | m > 9 && m < 16 = convertDigits (m - 1) ++ convertToHex m
  | otherwise = convertDigits (m - 1) ++ convertToChar m


insert :: Ord a => a -> [a] -> [a]
insert x [] = [x]
insert x (y:ys)
  | x <= y = x : y : ys
  | otherwise = y : insert x ys

insertionSort :: Ord a => [a] -> [a]
insertionSort = foldr insert []

permutationsN :: Ord a => [a] -> [[a]]
permutationsN stringToPermutate = insertionSort(doPerm stringToPermutate [])
  where
    doPerm [] _ = [[]]
    doPerm [singleElement] remainingElements = fmap (singleElement:) (doPerm remainingElements [])
    doPerm (firstElement : remainingElements) secondList = doPerm [firstElement] (remainingElements ++ secondList) ++ doPerm remainingElements (firstElement : secondList)



sortLexographic :: [Int] -> [Char]
sortLexographic [n, m] =
  let
    numbers = convertDigits m
    numbers1 = permutationsN numbers
    numbers2 = numbers1 !! (n-1)
   
  in
    numbers2

main :: IO ()
main = do
  print (sortLexographic [1, 5])
  print (sortLexographic [2, 5])
  print (sortLexographic [3, 5])
  print (sortLexographic [4, 5])
  print (sortLexographic [5, 5])
  print (sortLexographic [6, 5])
  print (sortLexographic [7, 5])
