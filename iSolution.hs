module DraftBeers where

type Barrel = (Int, Int)

initialBarrels :: Barrel -> Barrel -> Barrel  -> (Barrel, Barrel, Barrel)
initialBarrels b1 b2 b3
    | (uncurry (-) b1 >= 0) && (uncurry (-) b2 >= 0) && (uncurry (-) b3 >= 0)  = (b1, b2, b3)

    | (uncurry (-) b1 < 0) && (uncurry (-) b2 >= 0) && (uncurry (-) b3 >= 0) =
        let [b1A, b2A, b3A] = transferBeer (fst b1, fst b1) (snd b1 - fst b1) [(fst b1, fst b1), b2, b3]
        in (b1A, b2A, b3A) --Casos donde b1 (A) es el barril con más cerveza

    | (uncurry (-) b2 < 0) && (uncurry (-) b1 >= 0) && (uncurry (-) b3 >= 0) =
        let [b1B, b2B, b3B] = transferBeer (fst b2, fst b2) (snd b2 - fst b2) [b1, (fst b2, fst b2), b3]
        in (b1B, b2B, b3B) --Casos donde b2 (B) es el barril con más cerveza

    | (uncurry (-) b3 < 0) && (uncurry (-) b1 >= 0) && (uncurry (-) b2 >= 0) =
        let [b1C, b2C, b3C] = transferBeer (fst b3, fst b3) (snd b3 - fst b3) [b1, b2, (fst b3, fst b3)]
        in (b1C, b2C, b3C) --Casos donde b3 (C) es el barril con más cerveza

    | (uncurry (-) b1 < 0) && (uncurry (-) b2 < 0) && (uncurry (-) b3 >= 0) =
        let [b1B, b2B, b3B] = transferBeer (fst b2, fst b2) (snd b2 - fst b2) [(fst b1, fst b1), (fst b2, fst b2), b3]
        in (b1B, b2B, b3B) --Casos donde b1 (A) y b2 (B) son los barriles con más cerveza

    | (uncurry (-) b2 < 0) && (uncurry (-) b3 < 0) && (uncurry (-) b1 >= 0)  =
        let [b1B, b2B, b3B] = transferBeer (fst b2, fst b2) (snd b2 - fst b2) [b1, (fst b2, fst b2), (fst b3, fst b3)]
        in (b1B, b2B, b3B) --Casos donde b2 (B) y b3 (C) son los barriles con más cerveza

    | (uncurry (-) b1 < 0) && (uncurry (-) b3 < 0) && (uncurry (-) b2 >= 0) =
        let [b1A, b2A, b3A] = transferBeer (fst b3, fst b3) (snd b3 - fst b3) (transferBeer (fst b1, fst b1) (snd b1 - fst b1) [(fst b1, fst b1), b2, (fst b3, fst b3)])
        in (b1A, b2A, b3A) --Casos donde b1 (A) y b3 (C) son los barriles con más cerveza

    | otherwise = ((fst b1, fst b1), (fst b2, fst b2), (fst b3, fst b3)) --Caso donde todos los barriles exceden la cantidad de cerveza

verifyBarrels :: (Barrel, Barrel, Barrel) -> Int -> Bool
verifyBarrels ((a,b), (c,d), (e,f)) i
    | a >= i = True
    | c >= i = True
    | e >= i = True
    | otherwise = False

iSolution :: (Barrel, Barrel, Barrel) -> Int -> Bool
iSolution ((a,b), (c,d), (e,f)) i
    | b >= i && a >= i = True
    | d >= i && c >= i = True
    | f >= i && e >= i = True
    | otherwise = False

addBeer :: Int -> Barrel -> (Barrel, Int)
addBeer i (a,b)
    | b + i <= a = ((a, b + i), 0)
    | otherwise = ((a, a), b + i - a)


transferBeer :: Barrel -> Int -> [Barrel] -> [Barrel]
transferBeer x i bs
  -- Caso base: todos los barriles llenos
  | all (uncurry (==)) bs = bs

  -- Transferir a b desde a o c
  | (x == a || x == c) && (available a >= 0 || available c >= 0) =
      let newB = (fst b, min (fst b) (snd b + i))
          overflow = fst b - (snd b + i)
      in if overflow >= 0
         then [a, newB, c]
         else
           transferBeer newB (overflow * (-1)) [a, newB, c]

  -- Transferir a a si b es el origen y a tiene más espacio o igual que c
  | x == b && (snd a < snd c) && uncurry (>) a =
      let (newA, overflowA) = addBeer i a
      in if overflowA == 0
         then [newA, b, c]
         else
           transferBeer newA overflowA [newA, b, c]

  -- Transferir a c si b es el origen y c tiene más espacio que a
  | x == b && (snd c < snd a) && uncurry (>) c =
      let (newC, overflowC) = addBeer i c
      in if overflowC == 0
         then [a, b, newC]
         else
           transferBeer newC overflowC [a, b, newC]

  -- Transferir a a si b es el origen y a es igual que c
  | x == b && (snd a == snd c) && uncurry (>) a =
      let (newA, overflowA) = addBeer i a
      in if overflowA == 0
         then [newA, b, c]
         else
           transferBeer newA overflowA [newA, b, c]

  -- Transferir a a si b es el origen y a tiene más espacio o igual que c
  | x == b && (((snd a <= snd c) && uncurry (==) a) || ((snd c <= snd a) && uncurry (==) c)) = bs

  -- Si no hay nada que transferir, devolver el estado actual
  | all (\(cap, curr) -> cap == curr || curr == 0) bs = bs

  -- Caso de error: patrón no cubierto
  | otherwise = error ("transferBeer: patrón no cubierto con x=" ++ show x ++ ", bs=" ++ show bs)
  where
    a = head bs
    b = head (tail bs)
    c = last bs
    available (cap, curr) = cap - curr

aOrC :: Barrel -> Barrel -> (Int, Int)
aOrC (a,b) (c,d)
    | a-b <= c-d = (a, b)
    | otherwise = (c, d)

calcQuantBeer :: Int -> String -> [Barrel] -> Int
calcQuantBeer i s bs
    | s == "A" = i - snd a
    | s == "B" = (i - snd b) + uncurry (-) (aOrC a c)
    | s == "C" = i - snd c
    | otherwise = error "calcQuantBeer: patrón no cubierto"
    where
     a = head bs
     b = head (tail bs)
     c = last bs

whoServ :: Int -> [Barrel] -> (Barrel, Int)
whoServ x bs = determineBarrel x (map fst (filter (\(_, b) -> x <= b) (zip ["A", "B", "C"] (map fst bs)))) bs

determineBarrel :: Int -> [String] -> [Barrel] -> (Barrel, Int)
determineBarrel i st bs
  | length st == 1 && head st == "A" = (a, quantAddA)
  | length st == 1 && head st == "B" = (b, quantAddB)
  | length st == 1 && head st == "C" = (c, quantAddC)
  | length st == 2 && notElem "B" st && quantAddA <= quantAddC = (a, quantAddA)
  | length st == 2 && notElem "B" st && quantAddC < quantAddA = (c, quantAddC)
  | length st == 2 && notElem "A" st && quantAddB <= quantAddC = (b, quantAddB)
  | length st == 2 && notElem "A" st && quantAddC < quantAddB = (c, quantAddC)
  | length st == 2 && notElem "C" st && quantAddA <= quantAddB = (a, quantAddA)
  | length st == 2 && notElem "C" st && quantAddB < quantAddA = (b, quantAddB)
  | length st == 3 && (quantAddA <= quantAddB) && (quantAddA <= quantAddC) = (a, quantAddA)
  | length st == 3 && (quantAddB < quantAddA) && (quantAddB < quantAddC) = (b, quantAddB)
  | length st == 3 && (quantAddC < quantAddA) && (quantAddC < quantAddB) = (c, quantAddC)
  | otherwise = error "determineBarrel: patrón no cubierto"
  where
    a = head bs
    b = head (tail bs)
    c = last bs
    quantAddA = calcQuantBeer i "A" bs
    quantAddB = calcQuantBeer i "B" bs
    quantAddC = calcQuantBeer i "C" bs


servBeer :: (Barrel, Int) -> [Barrel] -> (Int, (Barrel, Barrel, Barrel))
servBeer (x, s) bs
    | x == a = modifyBarrelState "A" (fst (addBeer s a), s) bs

    | x == b =
        let (barrelMod, overflow) = addBeer s (aOrC a c)
            bs2 = if aOrC a c == a
                  then [barrelMod, b, c]
                  else [a, b, barrelMod]
            bMod = head (tail (transferBeer barrelMod overflow bs2))
        in modifyBarrelState "B" (bMod, s) (transferBeer barrelMod overflow bs2)

    | x == c = modifyBarrelState "C" (fst (addBeer s c), s) bs

    | otherwise = error "servBeer: patrón no cubierto"
  where
    a = head bs
    b = head (tail bs)
    c = last bs

modifyBarrelState :: String -> (Barrel, Int) -> [Barrel] -> (Int, (Barrel, Barrel, Barrel))
modifyBarrelState st (x, s) bs
    | st == "A" = (s, (x, b, c))
    | st == "B" = (s, (a, x, c))
    | st == "C" = (s, (a, b, x))
    | otherwise = error "modifyBarrelState: patrón no cubierto"
  where
    a = head bs
    b = head (tail bs)
    c = last bs

findBestSolution :: Int -> (Barrel, Barrel, Barrel) -> (Int, (Barrel, Barrel, Barrel))
findBestSolution i (a, b, c)
    | verifyBarrels (a, b, c) i && not (iSolution (a, b, c) i) = servBeer (whoServ i [d, e, f]) [d, e, f]
    | iSolution (a, b, c) i = (0, (d, e, f))
    | otherwise = (0, (a, b, c))
  where
    (d, e, f) = initialBarrels a b c
