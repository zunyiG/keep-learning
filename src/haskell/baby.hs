doubleMe x = x + x

doubleUs x y = doubleMe x + doubleMe y

doubleSmallNumber x = if x > 100
                      then x
                      else doubleMe x

doubleSmallNumber' x = (if x > 100 then x else doubleMe x) + 1

namE'Str = "This is a text line!"

-- 阶层
factorial :: (Integral a) => a -> a
factorial 0 = 1
factorial n = n * factorial(n - 1)


-- Tuple 相加
addVectors :: (Num a) => (a, a) -> (a, a) -> (a, a)
addVectors (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)

-- 模式匹配
length' :: (Num b) => [a] -> b
length' [] = 0
length' (_:xs) = 1 + length' xs

sum' :: (Num a) => [a] -> a
sum' [] = 0
sum' (x:xs) = x + sum' xs

capital :: String -> String
capital "" = "Empty!"
capital all@(x:xs) = "The first latter of " ++ all ++ " is " ++ [x]

-- 守卫
bmiTell :: (RealFloat a) => a -> a -> String
bmiTell weight height
  | bmi <= skinny = "underweight!"
  | bmi <= normal = "normal"
  | bmi <= fat = "fat!"
  | otherwise                   = "faaaat!"
  where bmi = weight / height ^ 2
        (skinny, normal, fat) = (18.5, 25.0, 30.0)


initials :: String -> String -> String
initials firstname lastname = [f] ++ ". " ++ [l] ++ "."
    where (f:_) = firstname
          (l:_) = lastname

-- 递归

maximum' :: (Ord a) => [a] -> a
maximum' [] = error "maximum of empty list"
maximum' [x] = x
maximum' (x:xs) = max x (maximum' xs)

replicate' :: (Num i, Ord i) => i -> a -> [a]
replicate' n a
  | n < 0 = []
  | otherwise = a : replicate' (n-1) a

take' :: (Num i, Ord i) => i -> [a] -> [a]
take' n _
  | n <= 0     = []
take' _ []    = []
take' n (x:xs)  = x:take' (n-1) xs

reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x:xs)  = (reverse' xs) ++ [x]

repeat' :: a -> [a]
repeat' x = x : repeat' x

zip' :: [a] -> [b] -> [(a,b)]
zip' _ [] = []
zip' [] _ = []
zip' (x:xs) (y:ys) = (x,y):zip' xs ys

elem' :: (Eq a) => a -> [a] -> Bool
elem' _ [] = False
elem' a (x:xs)
  | x == a = True
  | otherwise = a `elem'` xs

quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x:xs) = quicksort [a | a <- xs, a <= x] ++ [x] ++ quicksort [b | b <- xs, b > x]

-- 递归法的一般解决问题思路
-- 找到边境
-- 找到单比特（比如乘法的单比特是1， 加法的单比特是 0）
-- 找到递归的模式

collatz_chain :: (Integral a) => a -> [a]
collatz_chain 1 = [1]
collatz_chain n
  | odd n = n : collatz_chain (n * 3 + 1)
  | otherwise = n : collatz_chain (n `div` 2)

numLongChains = length (filter isLong (map collatz_chain [1..100]))
  where isLong xs = length xs > 15
