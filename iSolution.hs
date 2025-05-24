type Barrel = (Int, Int)

initialBarrels :: Barrel -> Barrel -> Barrel  -> (Barrel, Barrel, Barrel)
initialBarrels b1 b2 b3 = (b1, b2, b3)

iSolution :: (Barrel, Barrel, Barrel) -> Int -> Bool
iSolution ((a,b), (c,d), (e,f)) i
    | b >= i = True
    | d >= i = True
    | f >= i = True
    | otherwise = False

addBeer :: Int -> Barrel -> (Barrel, Int)
addBeer i (a,b)
    | b + i <= a = ((a, b + i), 0)
    | otherwise = ((a, a), b + i - a)