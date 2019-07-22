module DataBuild
(
) where

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
-- 由于 2 和 3 互质，她们的n次方也将互质，所以对于任意 2^a*3^b 都只有唯一的 a 和 b
cons'' x y = 2^x * 3^y
car'' n
  | g /= 1 = car'' (n / 3)
  | otherwise = log n / log 2
  where g = gcd n 3
