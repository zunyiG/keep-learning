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
