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
  | weight / height ^ 2 <= 18.5 = "underweight!"
  | weight / height ^ 2 <= 25.0 = "normal"
  | weight / height ^ 2 <= 30.0 = "fat!"
  | otherwise                   = "faaaat!"
