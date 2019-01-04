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
