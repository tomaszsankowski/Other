-- this program returns biggest number smaller than n that
-- can be representent as sum of two abundant numbers

dzielniki :: Int -> [Int]
dzielniki n = [x | x <- [1..(n `div` 2)], n `mod` x == 0]

sumaDzielnikow :: Int -> Int
sumaDzielnikow n = sum (dzielniki n)

jestObfita :: Int -> Bool
jestObfita n = sumaDzielnikow n > n

liczbyObfite :: Int -> [Int]
liczbyObfite n = [x | x <- [12..n], jestObfita x]

czyDaSieZsumowac :: Int -> [Int] -> Bool
czyDaSieZsumowac _ [] = False
czyDaSieZsumowac n (y:ys)
    | (n - y) `elem` (y:ys) = True
    | otherwise = czyDaSieZsumowac n ys

najmniejszaLiczbaHelp :: Int -> Int
najmniejszaLiczbaHelp n = najmniejszaLiczba n (liczbyObfite n)

najmniejszaLiczba :: Int -> [Int] -> Int
najmniejszaLiczba n lista
  | n<24 = n
  | czyDaSieZsumowac n lista  = najmniejszaLiczba (n - 1) lista
  | otherwise = n

main :: IO ()
main = do
  print (najmniejszaLiczbaHelp 1000)