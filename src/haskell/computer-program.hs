-- 内容来源于 计算机程序构造和解释 书中例题


-- 牛顿法 求平方根
improve guss x = (x/guss + guss)/2

good_enough_1 guss x = abs (x - guss * guss) < 0.001

good_enough guss change_guss = (abs(change_guss - guss))/guss < 0.00000001

sqrt_iter :: (Ord a, Floating a) => a -> a -> a
sqrt_iter guss x
  | (good_enough guss (improve guss x)) = guss
  | otherwise = sqrt_iter (improve guss x) x

sqrt' x = sqrt_iter 1 x



-- 牛顿法 求立方根
improve_3 guss x = (x/(guss*guss) + 2*guss)/3

cube_iter guss x
  | (good_enough guss (improve_3 guss x)) = guss
  | otherwise = cube_iter (improve_3 guss x) x

cube' x = cube_iter 1 x

-- 阶乘的尾递归表述方式
-- product <- counter * product
-- counter < - counter + 1
-- 线性递归过程和线性迭代过程的区别

factorial' n
  | n == 1 = 1
  | otherwise = n * (factorial' (n - 1))

fact_iter :: (Ord t, Num t) => t -> t -> t -> t
fact_iter product conter n
  | conter > n = product
  | otherwise = fact_iter (product * conter) (conter + 1) n

factorial :: (Integral a) => a -> a
factorial n = fact_iter 1 1 n


-- test 1.9

dec x = x - 1
inc x = x + 1

add1 a b
  | a == 0 = b
  | otherwise = inc ( add1 (dec a) b)


add2 a b
  | a == 0 = b
  | otherwise = add2 (dec a) (inc b)


-- example 1.2.2

fibonacci' n
  | n == 0 = 0
  | n == 1 = 1
  | otherwise = fibonacci' (n - 1) + fibonacci' (n - 2)

fibonacci_iter :: (Eq t, Num t) => t -> t -> t -> t
fibonacci_iter a b counter
  | counter == 0 = a
  | otherwise = fibonacci_iter b (a + b) (counter - 1)

fibonacci :: (Num t, Eq t) => t -> t
fibonacci n = fibonacci_iter 0 1 n

-- 换零钱 问题
-- 将 a 现金换成 n 种硬币的不同方式的数目等于：
-- 1.将现金数 a 换成除第一种硬币以外的其它硬币的数目
-- 2.将现金数 a - d 换成所有种类的不同方式的数目， 其中 d 是第一种硬币的币值

count_change_iter :: Integer -> Integer -> Integer
count_change_iter amount kinds
  | amount == 0 = 1
  | amount < 0 || kinds == 0 = 0
  | otherwise = (count_change_iter amount (kinds - 1)) + (count_change_iter (amount - (first_denomination kinds)) kinds)
  where first_denomination kinds = head [x | (y, x) <- [(1, 1), (2, 5), (3, 10), (4, 25), (5, 50)], y == kinds]

count_change :: Integer -> Integer
count_change amount = count_change_iter amount 5

-- test 1.11
t_1_11_recursion :: Integer -> Integer
t_1_11_recursion x
  | x < 3 = x
  | otherwise = (t_1_11_recursion (x - 1)) + 2 * (t_1_11_recursion (x - 2)) + 3 * (t_1_11_recursion (x - 3))


t_1_11_foreach :: Integer -> Integer
t_1_11_foreach n
  | n < 3 = n
  | otherwise = t_1_11_foreach_iter 2 1 0 3 n

t_1_11_foreach_iter :: Integer -> Integer -> Integer -> Integer -> Integer -> Integer
t_1_11_foreach_iter a b c counter n
  | counter > n = a
  | otherwise = t_1_11_foreach_iter (a + (2 * b) + (3 * c)) a b (counter + 1) n


-- test 1.12
--          1 => 2^0
--        1   1 => 2^1
--      1   2   1 => 2^2
--    1   3   3   1 => 2^3
--  1   4   6   4   1
--1   5  10   10  5   1

pascal_triangle x
  | x == 1 = 1
  | otherwise = 2^(x-1) + pascal_triangle(x-1)


-- test 1.13
golden_section :: Float
golden_section = (1 + sqrt 5)/2

golden_section_attest :: (Integral a, Floating b) => a -> b
golden_section_attest n = sqrt (abs ((((1 + sqrt 5)/2) ^ n) - (fromIntegral (fibonacci n)) * (sqrt 5)))


-- test 1.14
-- 空间 θ(2^n)
-- 步数(类似pascal triangle) θ(2^n)


-- test 1.15
-- 当角度 x 足够小时， 我们认为 sin x ≈ x
-- 根据三角恒等式 sin x = 3 * sin(x/3) + 4 * (sin(x/3) ^ 3)

cube x = x * x * x

sine_p x = 3 * x - 4 * cube x
sine' angle
  | abs angle <= 0.1 = angle
  | otherwise = sine_p (sine' (angle / 3))

-- 4 次
-- 空间 θ(log3(n/k))
-- 步数 θ(log3(n/k))




