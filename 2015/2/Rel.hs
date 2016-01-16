module Rel where

import Data.List
import Data.Tuple

-- Бинарное отношение на подмножестве целых чисел задано
-- списком пар без повторений
newtype R = R {unR :: [(Int, Int)]} deriving Show

-- Реализовать сравнение отношений на равенство (как множеств)
instance Eq R where
  (==) r1 r2 = (sort $ unR r1) == (sort $ unR r2)

-- sub r1 r2 == True <=> r1 --- подмножество r2
sub :: R -> R -> Bool
sub (R []) (R []) = True
sub r1 r2 = (head answ && length answ == 1) 
							where answ = nub [elem x (unR r2) | x <- (unR r1)] 

-- dom r --- список (без повторений) целых чисел, каждое из
-- которых имеет хотя бы одно вхождение в r
dom :: R -> [Int]
dom r = nub $ concat [[x,y] | x <- fst $ unzip $ unR r, y <- snd $ unzip $ unR r]

-- add r1 r2 --- объединение r1 и r2 как множеств (в результате
-- должен получиться список без повторений)
add :: R -> R -> R
add (R[]) (R[]) = R[]
add r1 r2 = R {unR = [(fst x, snd y) | x <- unR r1, y <- unR r2, snd x == snd y && fst x == fst y]}

-- rev r --- отношение, "обратное" к r (т.е. в каждой паре надо
-- компоненты поменять местами).
rev :: R -> R
rev r = R {unR = [(snd x, fst x) | x <- unR r]}

-- join r1 r2 --- отношение, состоящее из тех и только тех пар
-- (x, y), для которых существует z, такое, что (x, z) принадлежит
-- r1 и (z, y) принадлежит r2
join :: R -> R -> R
join r1 r2 = R {unR = [(fst x, snd y) | x <- unR r1, y <- unR r2, snd x == fst y]}

-- closure r строит транзитивное замыкание отношения r (т.е. наименьшее
-- транзитивное отношение, содержащее r)
closure :: R -> R
--closure (R r) = R(r ++ unR((join (R r) (R r)))) 
closure r = R (nub (unR r ++ unR(join r r)))

-- isReflexive r == True <=> r --- рефлексивное отношение на dom r
isReflexive :: R -> Bool
isReflexive r =  sort ([(fst x, snd x) | x <- (unR r), snd x == fst x ]) == sort (unR r) && ([(fst x, snd x) | x <- (unR r), fst x `elem` dom r]) /= []

-- isSymmetric r == True <=> r --- симметрияное отношение
isSymmetric :: R -> Bool
isSymmetric r = sort ([(snd x, fst x) | x <- (unR r)]) == sort (unR r) && (length (unR r)) `mod` 2 == 0

-- isTransitive r == True <=> r --- транзитивное отношение
isTransitive :: R -> Bool
isTransitive r = closure r  ==  r 


-- isEquivalence r == True <=> r --- отношение эквивалентности
isEquivalence :: R -> Bool
isEquivalence r = isReflexive r && isSymmetric r && isTransitive r
