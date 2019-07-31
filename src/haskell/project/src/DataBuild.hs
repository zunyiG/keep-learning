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

-- test 2.9
width_interval x =
  (upper_bound x - lower_bound x) / 2


-- width_interval (add_interval x y)
-- => width_interval ( make_interval (lower_bound x + lower_bound y) (upper_bound x + upper_bound y))
-- => ((upper_bound x + upper_bound y) - (lower_bound x + lower_bound y)) / 2
-- => (upper_bound x + upper_bound y - lower_bound x - lower_bound y) / 2
-- => ((upper_bound x - lower_bound x) + (upper_bound y - lower_bound y)) / 2
-- => (upper_bound x - lower_bound x) / 2 + (upper_bound y - lower_bound y) / 2
-- => width_interval x + width_interval y

-- width_interval (sub_interval x y)
-- => width_interval (add_interval x (make_interval (- upper_bound y) (- lower_bound y)))
-- => width_interval (add_interval x (make_interval (- upper_bound y) (- lower_bound y)))
-- => width_interval (make_interval (lower_bound x - upper_bound y) (upper_bound x - lower_bound y)
-- => ((upper_bound x - lower_bound y) - (lower_bound x - upper_bound y)) / 2
-- => (upper_bound x  - lower_bound x + upper_bound y - lower_bound y) / 2
-- => (upper_bound x  - lower_bound x) / 2 + (upper_bound y - lower_bound y) / 2
-- => width_interval x + width_interval y

-- width_interval (7,10) / width_interval (3,4) => 3.0
-- width_interval $ div_interval (7,10) (3,4) => 0.7916666666666665
-- width_interval $ mul_interval (7,10) (3,4) => 9.5

-- test 2.10
div_interval' x y
  | upper_bound y == 0 || lower_bound y == 0 = error "Zero cannot be divided"
  | otherwise = mul_interval x
                             (make_interval (1 / upper_bound y) (1 / lower_bound y))

-- test 2.11
-- (a,b) (c,d)
-- 1. a,b,c,d >= 0 => (a*c, b*d)
-- 2. a < 0; b,c,d >= 0 => (a*d, b*d)
-- 3. b < 0; a,c,d >= 0 => (b*d, a*d) X
-- 4. c < 0; a,b,d >= 0 => (b*c, b*d)
-- 5. d < 0; a,b,c >= 0 => (b*d, b*c) X
-- 6. a,b < 0; c,d >= 0 => (b*d, a*c)
-- 7. a,c < 0; b,d >= 0 => (a*d || b*c, a*c || b*d)
-- 8. a,d < 0; b,c >= 0 => (b*d, a*c) X
-- 9. b,c < 0; a,d >= 0 => (b*d, a*c) X
-- 10. b,d < 0; a,c >= 0 => (b*c, b*d) X
-- 11. c,d < 0; a,b >= 0 => (b*d, a*c)
-- 12. a,b,c < 0; d >= 0 => (b*d, b*c)
-- 13. a,b,d < 0; c >= 0 => (b*c, b*d) X
-- 14. a,c,d < 0; b >= 0 => (b*d, a*d)
-- 15. b,c,d < 0; a >= 0 => (a*d, b*d) X
-- 16. a,b,c,d < 0 => (a*c, b*d)

mul_interval' x y
  | a >= 0 && b >= 0 && c >= 0 && d >= 0 = make_interval (a*c) (b*d)
  | c < 0 && d < 0 && a < 0 && b < 0 = make_interval (a*c) (b*d)
  | a < 0 && b >= 0 && c >= 0 && d >= 0 = make_interval (a*d) (b*d)
  | c < 0 && a >= 0 && b >= 0 && d >= 0 = make_interval (b*c) (b*d)
  | a < 0 && b < 0 && c >= 0 && d >= 0 = make_interval (b*d) (a*c)
  | c < 0 && d < 0 && a >= 0 && b >= 0 = make_interval (b*d) (a*c)
  | a < 0 && b < 0 && c < 0 && d >= 0 = make_interval (b*d) (b*c)
  | a < 0 && c < 0 && d < 0 && b >= 0 = make_interval (b*d) (a*d)
  | a < 0 && c < 0 && b >= 0 && d >= 0 = make_interval (if a*d < b*c then a*d else b*c)
                                                       (if a*c > b*d then a*c else b*d)
  | otherwise = error "cannot be multiplication"
  where a = lower_bound x
        b = upper_bound x
        c = lower_bound y
        d = upper_bound y

make_center_width c w = make_interval (c - w) (c + w)

center i = (lower_bound i + upper_bound i) / 2

width i = (upper_bound i - lower_bound i) / 2

-- test 2.12
make_center_percent c p = make_interval (c - c * p) (c + c * p)

percent i = width i / center i

-- test 2.13
-- percent (mul_interval (make_center_percent c1 p1) (make_center_percent c2 p2)) 假设区间端点都为正
-- => percent (mul_interval (make_center_percent c1 p1) (make_center_percent c2 p2))
-- => percent (mul_interval (make_interval (c1 - c1 * p1) (c1 + c1 * p1)) (make_interval (c2 - c2 * p2) (c2 + c2 * p2)))
-- => percent (make_interval ((c1 - c1 * p1) * (c2 - c2 * p2)) ((c1 + c1 * p1) * (c2 + c2 * p2)))
-- => (((c1 + c1 * p1) * (c2 + c2 * p2)) - ((c1 - c1 * p1) * (c2 - c2 * p2))) / 2 / (( (((c1 + c1 * p1) * (c2 + c2 * p2)) + ((c1 - c1 * p1) * (c2 - c2 * p2))) ) /2)
-- => (((c1 + c1 * p1) * (c2 + c2 * p2)) - ((c1 - c1 * p1) * (c2 - c2 * p2))) / (((c1 + c1 * p1) * (c2 + c2 * p2)) + ((c1 - c1 * p1) * (c2 - c2 * p2)))
-- =>(c1c2 + c1c2p2 + c1p1c2 + c1p1c2p2 - (c1c2 - c1c2p2 - c1p1c2 + c1p1c2p2)) / (c1c2 + c1c2p2 + c1p1c2 + c1p1c2p2 + (c1c2 - c1c2p2 - c1p1c2 + c1p1c2p2))
-- => (2*c1c2p2 + 2*c1p1c2) / (2*c1c2 + 2*c1p1c2p2)
-- => (p2 + p1) / (1 + p1p2)  当p1 p2 都非常小时，可以忽略p1p2
-- => p1 + p2
-- 除法计算也是 (p2 + p1) / (1 + p1p2)
-- 加法 (c1p1 + c2p2)/ (c1 + c2)


mul_percent p1 p2 = (p2 + p1) / (1 + p1*p2)

-- test 2.14
par1 r1 r2 = div_interval (mul_interval r1 r2)
                          (add_interval r1 r2)

par2 r1 r2 = div_interval one
                          (add_interval (div_interval one r1)
                                        (div_interval one r2))
  where one = make_interval 1 1

-- par1 (make_interval 2 3) (make_interval 3 4) => (0.8571428571428571,2.4000000000000004)
-- par2 (make_interval 2 3) (make_interval 3 4) => (1.2000000000000002,1.7142857142857144)
-- mul_interval (div_interval (make_interval 1 2) (make_interval 3 4)) (make_interval 3 4) => (0.75,2.6666666666666665)
-- div_interval (make_interval 2 3) (make_interval 4 5) => (0.4,0.75)
-- div_interval (make_interval 2 3) (make_interval 2 3) => (0.6666666666666666,1.5)
-- div_interval (make_center_percent 100 0.001) (make_center_percent 100 0.001) => (0.9980019980019981,1.002002002002002)
-- mul_interval (div_interval (make_center_percent 100 0.001) (make_center_percent 100 0.001)) (make_center_percent 100 0.001) => (99.7003996003996,100.30040040040039)
-- 区间宽度更小时可以使结果更加精确

-- test 2.15
-- par2 = div_interval (mul_interval r1 r2) (add_interval r1 r2)
-- => mul_interval (mul_interval r1 r2) (div_interval one (add_interval r1 r2))
-- 说法正确, 减少非确定性区间的乘积计算可以是结果更加准确
-- 如果宽度变化为0，乘法或除法运算后的区间宽度百分比变化为 0

-- test 2.16
-- 因为非确定区间的运算会随着运算的进行使区间宽度不断增加
--  (p1 + p2) / (1 + p1*p2)

