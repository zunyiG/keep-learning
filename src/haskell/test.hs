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

fact_iter :: (Ord t, Num t) => t -> t -> t -> t
fact_iter product conter n
  | conter > n = product
  | otherwise = fact_iter (product * conter) (conter + 1) n

factorial :: (Integral a) => a -> a
factorial n = fact_iter 1 1 n


