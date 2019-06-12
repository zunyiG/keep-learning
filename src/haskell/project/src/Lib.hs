module Lib
( someFunc
) where

import System.Random

someFunc :: IO ()
-- someFunc = putStrLn $ drawInt 4 100
someFunc = do
  putStrLn "aaa"
  aa <- drawInt 4 100
  putStrLn $ show aa


-- 内容来源于 计算机程序构造和解释 书中例题

-- test 1.5
p = (p)
test_p x y
  | x == 0 = 0
  | otherwise = y
-- 正则序会返回0
-- 应用序会栈溢出

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
fact_iter product counter n
  | counter > n = product
  | otherwise = fact_iter (product * counter) (counter + 1) n

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


-- example 1.2.4
-- b^n = b * b ^ (n-1)
-- b^0 = 1

-- 01
power b n
  | n == 0 = 1
  | otherwise = b * power b (n - 1)

-- 02
power_iter' b n product
  | n == 0 = product
  | otherwise = power_iter' b (n - 1) (product * b)

power' b n = power_iter' b n 1

-- 03
square x = x * x

power'' :: (Integral a1, Integral a2) => a2 -> a1 -> a2
power'' b n
  | n == 0 = 1
  | even n = square (power'' b (floor $ fromIntegral n/2))
  | otherwise = b * (power'' b ((n - 1)))


-- test 1.16 使用乘法做乘幂
-- a (odd n)<- a * b
-- n (even n)<- n / 2
-- n (odd n)<- n - 1
-- b (even n)<- b ^ 2

power_iter :: (Integral a1, Integral a2) => a2 -> a1 -> a2 -> a2
power_iter b n a
  | n == 1 = a*b
  | even n = power_iter (square b) (floor $ fromIntegral n / 2) a
  | otherwise = power_iter b (n - 1) a*b

power_fast :: (Integral a1, Integral a2) => a2 -> a1 -> a2
power_fast b n
  | n < 0 = error "N must > 0"
  | n == 0 = 1
  | otherwise = power_iter b n 1


-- test 1.17 使用加法做乘法
double :: Integer -> Integer
double x = x + x

halve :: Integer -> Integer
halve x
  | even x = floor $ fromIntegral x / 2
  | otherwise = x

product_fast :: Integer -> Integer -> Integer
product_fast a b
  | b == 1 = a
  | even b = double $ product_fast a (halve b)
  | otherwise = a + product_fast a (b - 1)


-- test 1.18 使用加法做乘法 的 迭代运算过程
-- p (odd b)<- a + p
-- a (even b)<- a * 2
-- b (even b)<- b / 2
-- b (odd b)<- b - 1

product_iter :: Integer -> Integer -> Integer -> Integer
product_iter a b p
  | b == 1 = a + p
  | even b = product_iter (double a) (halve b) p
  | otherwise = product_iter a (b - 1) (a + p)

product_fast_iter :: Integer -> Integer -> Integer
product_fast_iter a b
  | b < 0 = error "b must > 0"
  | b == 0 = 0
  | otherwise = product_iter a b 0

-- test 1.19 斐波那契 的对数复杂度求法
fib_fast :: Integer -> Integer
fib_fast n = fib_fast_iter 1 0 0 1 n

fib_fast_iter :: (Integral b) => b -> b -> b -> b -> b -> b
fib_fast_iter a b p q counter
  | counter == 0 = b
  | even counter = fib_fast_iter a b (p*p + q*q) (p*q + q*q + q*p) (floor $ fromIntegral counter / 2)
  | otherwise = fib_fast_iter (b*q + a*q + a*p) (b*p + a*q) p q (counter - 1)

-- example 1.2.5 使用 欧几里得算法 求最大公约数 GCD
-- 步数 n >= Fib(k) .= θ^k/sqrt 5 => θ(log n)
gcd' :: Integer -> Integer -> Integer
gcd' a b
  | b == 0 = a
  | otherwise = gcd' b $ rem a b

-- test 1.20
-- 正则序 求余 18 次
-- 应用序 求余 4 次


-- example 1.2.6
-- 求一个数是否是质数
-- 步数具有 θ(sqrt n ) 的增长阶

prime n = smallest_divisor n == n

smallest_divisor n = find_divisor n 2

find_divisor_next 2 = 3
find_divisor_next n = n + 2


find_divisor n test_divisor
  | square test_divisor > n = n
  | rem n test_divisor == 0 = test_divisor
  | otherwise = find_divisor n $ test_divisor + 1

primes = [x|x <- [1,2..], prime x]

-- 费马检查
-- θ(log n)

drawInt :: Integer -> Integer -> IO Integer
drawInt x y = getStdRandom (randomR (x,y))

random_list :: Integer -> IO [Integer]
random_list 0 = return []
random_list n = do
    a <- drawInt 1 20
    rest <- (random_list(n-1))
    return (a : rest)

expmod :: Integer -> Integer -> Integer -> Integer
expmod base exp m
  | exp == 0 = 1
  | even exp = rem (square (expmod base (floor $ fromIntegral exp / 2) m)) m
  | otherwise = rem (base * (expmod base (exp -1) m)) m

fermat_test :: Integer -> Integer -> IO Bool
fermat_test _ 0 = return True
fermat_test n times = do
  a <- drawInt 1 $ n-1
  rest <- fermat_test n $ times - 1
  return $ ((expmod a n n) == a) && rest

primes_fast :: Integer -> IO [Integer]
primes_fast 0 = return []
primes_fast n = do
    rest <- primes_fast $ n - 1
    b <- fermat_test n 2
    let list = if b then n:rest else rest
    return list

-- test 1.21
{-
  199 -> 199
  1999 -> 1999
  19999 -> 19999
-}


-- test 1.22
search_for_primes _ 0 = return []
search_for_primes start count = do
  if even start
    then do
      rest <- (search_for_primes (start + 1) count)
      return rest
    else do
      is_prime <- fermat_test start 3
      if is_prime
        then do
          rest <- search_for_primes (start + 2) (count - 1)
          return (start : rest)
        else do
          rest <- search_for_primes (start + 2) count
          return rest


search_for_primes' _ 0 = []
search_for_primes' n count
  | even n = search_for_primes' (n + 1) count
  | prime n = n : search_for_primes' (n + 2) (count - 1)
  | otherwise = search_for_primes' (n + 2) count

-- 查找大于1000的3个质数和大于10000的3个质数的运行时间相差不大
-- 步数并非正比于运行时间

-- test 1.23
-- 比值不是一半
-- 17/15
-- 虽然减少了一半的直接计算，但是同样又增加了一些计算

-- test 1.24
-- 应该是两倍的时间
-- 实际为1.5倍左右
-- 个人认为应该是cpu的执行或者系统执行了优化算法

-- test 1.25
-- 不能用于检查
-- 求一个数的 n 次方，会产生一个非常巨大的数， 在进行求余会效率低下，容易出错

-- test 1.26
-- 使用显示的乘法而不是平方，会造成程序运算步骤出现指数型增长，1变成2变成4.., 所以θ(log n) 变成了 θ(n)

-- test 1.27
test_carmichael_iter n count
  | count >= n = True
  | expmod count n n == count = test_carmichael_iter n (count + 1)
  | otherwise = False

test_carmichael n = test_carmichael_iter n 1

carmichael = [x|x<-[1,2..], not $ prime x, test_carmichael x]

-- test 1.28
-- Miller-Rabin 检查

expmod_improve :: Integer -> Integer -> Integer -> Integer
expmod_improve base exp m
  | exp == 0 = 1
  | even exp = if x /= 1 then 0 else x
  | otherwise = rem (base * (expmod_improve base (exp -1) m)) m
  where x = rem (square (expmod base (floor $ fromIntegral exp / 2) m)) m

fermat_test_improve :: Integer -> Integer -> IO Bool
fermat_test_improve _ 0 = return True
fermat_test_improve n times = do
  a <- drawInt 1 $ n-1
  rest <- fermat_test_improve n $ times - 1
  return $ ((expmod_improve a (n - 1) n) == 1) && rest

search_for_primes_improve _ 0 = return []
search_for_primes_improve n count = do
  if even n
    then do
      rest <- (search_for_primes_improve (n + 1) count)
      return rest
    else do
      is_prime <- fermat_test_improve n 3
      if is_prime
        then do
          rest <- search_for_primes_improve (n + 2) (count - 1)
          return (n : rest)
        else do
          rest <- search_for_primes_improve (n + 2) count
          return rest
