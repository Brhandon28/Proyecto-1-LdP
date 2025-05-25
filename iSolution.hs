module DraftBeers where

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


transferBeer :: Barrel -> Int -> [Barrel] -> [Barrel]
transferBeer x i bs
  -- Caso base: todos los barriles llenos
  | all (\(cap, curr) -> cap == curr) bs = bs

  -- Transferir a b desde a o c
  | (x == a || x == c) && (available a > 0 || available c > 0) =
      let newB = (fst b, min (fst b) (snd b + i))
          overflow = fst b - (snd b + i)  
      in if overflow >= 0
         then [a, newB, c]
         else
           let newB2 = (fst b, fst b)
           in transferBeer newB2 overflow [a, newB2, c]

  -- Transferir a a si b es el origen y a tiene más espacio o igual que c
  | x == b && available a >= available c =
      let newA = (fst a, min (fst a) (snd a + i))
          overflow = snd a + i - fst a
      in if overflow >= 0
         then [newA, b, c]
         else
           let newA2 = (fst a, fst a)
           in transferBeer a overflow [newA2, b, c]

  -- Transferir a c si b es el origen y c tiene más espacio que a
  | x == b && available c > available a =
      let newC = (fst c, min (fst c) (snd c + i))
          overflow = snd c + i - fst c
      in if overflow >= 0
         then [a, b, newC]
         else
           let newC2 = (fst c, fst c)
           in transferBeer c overflow [a, b, newC2]

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
    | s == "B" = (i - snd b) + (i - fst (aOrC a c))
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
    | x == c = modifyBarrelState "C" (addBeer s c) bs
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
    | iSolution (a, b, c) i = (0, (a, b, c))
    | otherwise = solution
  where
    solution = servBeer (whoServ i [a, b, c]) [a, b, c]