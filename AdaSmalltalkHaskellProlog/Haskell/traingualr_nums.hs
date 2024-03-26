-- this program outputs first triangular number that
-- has more divisors than a given number

trojkatna :: Int -> Int
trojkatna x = x * (x + 1) `div` 2

czyMniejszaLiczbaDzielnikow :: Int -> Int -> Bool
czyMniejszaLiczbaDzielnikow x ile_dzielnikow = length [d | d <- [1..x], x `mod` d == 0] <= ile_dzielnikow

ktoraLiczba :: Int -> Int
ktoraLiczba ile_dzielnikow = length (takeWhile (\x -> czyMniejszaLiczbaDzielnikow (trojkatna x) ile_dzielnikow) [1..]) + 1

main :: IO ()
main = do
    putStrLn "Podaj liczbe, od ktorje wiecej dzielkikow ma miec liczba trojkatna:"
    ile_dzielnikow <- readLn
    let numer = ktoraLiczba ile_dzielnikow
        liczba = trojkatna numer
    putStrLn $ "Pierwsza liczba trójkątna posiadająca więcej dzielników niż " ++ show ile_dzielnikow ++ ": " ++ show liczba