module DataBuild
(
) where

import Debug.Trace

make_rat :: (Integral a) => a -> a -> (a, a)
make_rat n d = (floor $ fromIntegral n / fromIntegral g, floor $ fromIntegral d / fromIntegral g)
  where g = gcd n d

number :: (Integral a) => (a, a) -> a
number (a, _) = a

denom :: (Integral a) => (a, a) -> a
denom (_, a) = a

add_rat :: (Integral a) => (a, a) -> (a, a) -> (a, a)
add_rat x y = ((number x * denom y) + (number y * denom x), denom x * denom y)

sub_rat :: (Integral a) => (a, a) -> (a, a) -> (a, a)
sub_rat x y = ((number x * denom y) - (number y * denom x), denom x * denom y)

mul_rat :: (Integral a) => (a, a) -> (a, a) -> (a, a)
mul_rat x y = (number x * number y, denom x * denom y)

div_rat :: (Integral a) => (a, a) -> (a, a) -> (a, a)
div_rat x y = (number x * denom y, denom x * number y)

equal_rat :: (Integral a) => (a, a) -> (a, a) -> Bool
equal_rat x y = number x * denom y == denom x * number y

print_rat :: (Integral a, Show a) => (a, a) -> String
print_rat (a, b) = show a ++ "/" ++ show b

-- test 2.1
make_rat' n d
  | n * d > 0 = (abs n', abs d')
  | otherwise = (- abs n', abs d')
  where g  = gcd n d
        n' = floor $ fromIntegral n / fromIntegral g
        d' = floor $ fromIntegral d / fromIntegral g
        abs' = abs (n + d)


-- test 2.2
make_segment :: a -> a -> (a, a)
make_segment start end = (start, end)

start_segment :: (a,a) -> a
start_segment (start, _) = start
end_segment (_, end) = end

make_point :: a -> a -> (a, a)
make_point x y = (x, y)

x_point :: (a,a) -> a
x_point (x, _) = x
y_point (_, y) = y

midpoint_segment seg = ((x_point start_point + x_point end_point)/2, (y_point start_point + y_point end_point)/2)
  where start_point = start_segment(seg)
        end_point = end_segment(seg)

-- midpoint_segment $ make_segment (make_point 1 5) (make_point 3 8) => (2.0, 6.5)

-- test 2.3
make_rect :: a -> a -> a -> a -> (a, a, a, a)
make_rect p1 p2 p3 p4 = (p1, p2, p3, p4)

-- top_left (point, _, _, _) = point
-- top_right (_, point, _, _) = point
-- bottom_left (_, _, point, _) = point
-- bottom_right (_, _, _, point) = point

perimeters_rect rect =((x_point (top_right rect) - x_point (bottom_left rect))
                      + (y_point (top_right rect) - y_point (bottom_left rect))) * 2
area_rect rect = (x_point (top_right rect) - x_point (bottom_left rect))
                 * (y_point (top_right rect) - y_point (bottom_left rect))

-- perimeters_rect $ make_rect (make_point 0 2) (make_point 4 2) (make_point 0 0) (make_point 4 0)
-- area_rect $ make_rect (make_point 0 2) (make_point 4 2) (make_point 0 0) (make_point 4 0)

make_rect' :: a -> a -> a -> a -> ((a, a), (a, a))
make_rect' p1 p2 p3 p4 = ((p1, p2), (p3, p4))

top_left ((point, _), _) = point
top_right ((_, point), _) = point
bottom_left (_, (point, _)) = point
bottom_right (_, ( _, point)) = point

-- perimeters_rect $ make_rect' (make_point 0 2) (make_point 4 2) (make_point 0 0) (make_point 4 0)
-- area_rect $ make_rect' (make_point 0 2) (make_point 4 2) (make_point 0 0) (make_point 4 0)

-- example 2.1.3
-- 分层的概念不仅可以用于更高层次的数据，更底层次的数据的定义也可以
-- 实现一个序对
cons x y = \m -> if m == 0 then x else if m == 1 then y else error "Argument not 0 or 1 -- CONS "
car x = x 0
cdr x = x 1

-- test 2.4
cons' x y = \m -> m x y
car' z = z (\p q -> p)

-- 代换模型
-- car' (cons' x y)
-- => car' (\m -> m x y)
-- => (\m -> m x y) (\p q -> p)
-- => (\p q -> p) x y
-- => x

cdr' z = z (\p q -> q)

-- test 2.5
-- 由于 2 和 3 互质，所有她们的n次方也将互质，所以对于任意 2^a*3^b 都只有唯一的 a 和 b
cons'' x y = 2^x * 3^y

-- 小数取整的方法
-- ceiling :: (RealFrac a, Integral b) => a -> b
-- floor :: (RealFrac a, Integral b) => a -> b
-- truncate :: (RealFrac a, Integral b) => a -> b
-- round :: (RealFrac a, Integral b) => a -> b

-- car'' :: (Integral a) => a -> a
car'' p
  | gcd (round p) 3 /= 1 = car'' $ p / 3
  | otherwise = log p / log 2
-- cdr'' :: (Integral a) => a -> a
-- cdr'' p = round (((log $ fromIntegral p) - (fromIntegral (car'' p)) * log 2) / log 3)

cdr'' p
  | gcd (round p) 2 /=1 = cdr'' (p / 2)
  | otherwise = log p / log 3

-- 当 y > 33 或 x > 971 时会出现计算错误，可能因为除法会被表示为科学技术法,会被 round 于出，造成误差
-- 改进版本

car''' p =
  let iter g
        | gcd p (g * 2) == g = (log $ fromIntegral g) / log 2
        | otherwise = iter (g * 2)
  in iter 1

cdr''' p =
  let iter g
        | gcd p (g * 3) == g = (log $ fromIntegral g) / log 3
        | otherwise = iter (g * 3)
  in iter 1
-- log 限制 x < 1024, y < 647 位

-- test 2.6
zero = \f -> (\x -> x)
add_1 n = \f -> (\x -> f ((n f) x))
-- add_1 zero
-- => \f -> (\x -> f (((\f -> (\x -> x)) f) x))
-- => \f -> (\x -> f ((\x -> x) x))
-- => \f -> (\x -> f x) => 1

-- add_1 add_1
-- => \f -> (\x -> f (((\f -> (\x -> f ((n f) x))) f) x))
-- => \f -> (\x -> f (f((n f) x))))

-- add_1 add_1 zero
-- => \f -> (\x -> f (f(((\f -> (\x -> x)) f) x))))
-- => \f -> (\x -> f (f x)) => 2

one = \f -> (\x -> f x)
two = \f -> (\x -> f (f x))

lambda_add m n = \f -> (\x -> (\x -> ((m f) x)) ((m f) x))

-- lambda_add one one
-- => \f -> (\x -> (\x -> ((\f -> (\x -> f x) f) x)) ((\f -> (\x -> f x) f) x))
-- => \f -> (\x -> (\x -> (((\f -> (\x -> f x)) f) x)) (((\f -> (\x -> f x)) f) x))
-- => \f -> (\x -> (\x -> f x) (f x))
-- => \f -> (\x -> f (f x))
-- => 2

-- lambda_add one two
-- => \f -> (\x -> (\x -> f x) (((\f -> (\x -> f (f x))) f) x))
-- => \f -> (\x -> (\x -> f x) (f (f x)))
-- => \f -> (\x -> f (f (f x)))
-- => 3


add_interval x y =
  make_interval (lower_bound x + lower_bound y)
                (upper_bound x + upper_bound y)

mul_interval x y =
    let p1 = lower_bound x * lower_bound y
        p2 = lower_bound x * upper_bound y
        p3 = upper_bound x * lower_bound y
        p4 = upper_bound x * upper_bound y
    in make_interval (minimum [p1, p2, p3, p4])
                     (maximum [p1, p2, p3, p4])

div_interval x y =
  mul_interval x
              (make_interval (1 / upper_bound y) (1 / lower_bound y))

-- test 2.7
make_interval a b = (a, b)
upper_bound (_, b) = b
lower_bound (a, _) = a

-- test 2.8
sub_interval x y =
  add_interval x
               (make_interval (- upper_bound y) (- lower_bound y))

