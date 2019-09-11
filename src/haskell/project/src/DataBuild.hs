module DataBuild
(
) where

import Debug.Trace

makeRat :: (Integral a) => a -> a -> (a, a)
makeRat n d = (floor $ fromIntegral n / fromIntegral g, floor $ fromIntegral d / fromIntegral g)
  where g = gcd n d

number :: (Integral a) => (a, a) -> a
number (a, _) = a

denom :: (Integral a) => (a, a) -> a
denom (_, a) = a

addRat :: (Integral a) => (a, a) -> (a, a) -> (a, a)
addRat x y = ((number x * denom y) + (number y * denom x), denom x * denom y)

subRat :: (Integral a) => (a, a) -> (a, a) -> (a, a)
subRat x y = ((number x * denom y) - (number y * denom x), denom x * denom y)

mulRat :: (Integral a) => (a, a) -> (a, a) -> (a, a)
mulRat x y = (number x * number y, denom x * denom y)

divRat :: (Integral a) => (a, a) -> (a, a) -> (a, a)
divRat x y = (number x * denom y, denom x * number y)

equalRat :: (Integral a) => (a, a) -> (a, a) -> Bool
equalRat x y = number x * denom y == denom x * number y

printRat :: (Integral a, Show a) => (a, a) -> String
printRat (a, b) = show a ++ "/" ++ show b

-- test 2.1
makeRat' n d
  | n * d > 0 = (abs n', abs d')
  | otherwise = (- abs n', abs d')
  where g  = gcd n d
        n' = floor $ fromIntegral n / fromIntegral g
        d' = floor $ fromIntegral d / fromIntegral g
        abs' = abs (n + d)


-- test 2.2
makeSegment :: a -> a -> (a, a)
makeSegment start end = (start, end)

startSegment :: (a,a) -> a
startSegment (start, _) = start
endSegment (_, end) = end

makePoint :: a -> a -> (a, a)
makePoint x y = (x, y)

xPoint :: (a,a) -> a
xPoint (x, _) = x
yPoint (_, y) = y

midpointSegment seg = ((xPoint startPoint + xPoint endPoint)/2, (yPoint startPoint + yPoint endPoint)/2)
  where startPoint = startSegment(seg)
        endPoint = endSegment(seg)

-- midpointSegment $ makeSegment (makePoint 1 5) (makePoint 3 8) => (2.0, 6.5)

-- test 2.3
makeRect :: a -> a -> a -> a -> (a, a, a, a)
makeRect p1 p2 p3 p4 = (p1, p2, p3, p4)

-- topLeft (point, _, _, _) = point
-- topRight (_, point, _, _) = point
-- bottomLeft (_, _, point, _) = point
-- bottomRight (_, _, _, point) = point

perimetersRect rect =((xPoint (topRight rect) - xPoint (bottomLeft rect))
                      + (yPoint (topRight rect) - yPoint (bottomLeft rect))) * 2
areaRect rect = (xPoint (topRight rect) - xPoint (bottomLeft rect))
                 * (yPoint (topRight rect) - yPoint (bottomLeft rect))

-- perimetersRect $ makeRect (makePoint 0 2) (makePoint 4 2) (makePoint 0 0) (makePoint 4 0)
-- areaRect $ makeRect (makePoint 0 2) (makePoint 4 2) (makePoint 0 0) (makePoint 4 0)

makeRect' :: a -> a -> a -> a -> ((a, a), (a, a))
makeRect' p1 p2 p3 p4 = ((p1, p2), (p3, p4))

topLeft ((point, _), _) = point
topRight ((_, point), _) = point
bottomLeft (_, (point, _)) = point
bottomRight (_, ( _, point)) = point

-- perimetersRect $ makeRect' (makePoint 0 2) (makePoint 4 2) (makePoint 0 0) (makePoint 4 0)
-- areaRect $ makeRect' (makePoint 0 2) (makePoint 4 2) (makePoint 0 0) (makePoint 4 0)

-- example 2.1.3
-- 分层的概念不仅可以用于更高层次的数据，更底层次的数据的定义也可以
-- 实现一个序对
cons' x y = \m -> if m == 0 then x else if m == 1 then y else error "Argument not 0 or 1 -- CONS "
car' x = x 0
cdr' x = x 1

-- test 2.4
cons x y = \m -> m x y
car z = z (\p q -> p)

-- 代换模型
-- car' (cons' x y)
-- => car' (\m -> m x y)
-- => (\m -> m x y) (\p q -> p)
-- => (\p q -> p) x y
-- => x

cdr z = z (\p q -> q)

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
add1 n = \f -> (\x -> f ((n f) x))
-- add1 zero
-- => \f -> (\x -> f (((\f -> (\x -> x)) f) x))
-- => \f -> (\x -> f ((\x -> x) x))
-- => \f -> (\x -> f x) => 1

-- add1 add1
-- => \f -> (\x -> f (((\f -> (\x -> f ((n f) x))) f) x))
-- => \f -> (\x -> f (f((n f) x))))

-- add1 add1 zero
-- => \f -> (\x -> f (f(((\f -> (\x -> x)) f) x))))
-- => \f -> (\x -> f (f x)) => 2

one = \f -> (\x -> f x)
two = \f -> (\x -> f (f x))

lambdaAdd m n = \f -> (\x -> (\x -> ((m f) x)) ((n f) x))

-- lambdaAdd one one
-- => \f -> (\x -> (\x -> ((\f -> (\x -> f x) f) x)) ((\f -> (\x -> f x) f) x))
-- => \f -> (\x -> (\x -> (((\f -> (\x -> f x)) f) x)) (((\f -> (\x -> f x)) f) x))
-- => \f -> (\x -> (\x -> f x) (f x))
-- => \f -> (\x -> f (f x))
-- => 2

-- lambdaAdd one two
-- => \f -> (\x -> (\x -> f x) (((\f -> (\x -> f (f x))) f) x))
-- => \f -> (\x -> (\x -> f x) (f (f x)))
-- => \f -> (\x -> f (f (f x)))
-- => 3


addInterval x y =
  makeInterval (lowerBound x + lowerBound y)
                (upperBound x + upperBound y)

mulInterval x y =
    let p1 = lowerBound x * lowerBound y
        p2 = lowerBound x * upperBound y
        p3 = upperBound x * lowerBound y
        p4 = upperBound x * upperBound y
    in makeInterval (minimum [p1, p2, p3, p4])
                     (maximum [p1, p2, p3, p4])

divInterval x y =
  mulInterval x
              (makeInterval (1 / upperBound y) (1 / lowerBound y))

-- test 2.7
makeInterval a b = (a, b)
upperBound (_, b) = b
lowerBound (a, _) = a

-- test 2.8
subInterval x y =
  addInterval x
               (makeInterval (- upperBound y) (- lowerBound y))

-- test 2.9
widthInterval x =
  (upperBound x - lowerBound x) / 2


-- widthInterval (addInterval x y)
-- => widthInterval ( makeInterval (lowerBound x + lowerBound y) (upperBound x + upperBound y))
-- => ((upperBound x + upperBound y) - (lowerBound x + lowerBound y)) / 2
-- => (upperBound x + upperBound y - lowerBound x - lowerBound y) / 2
-- => ((upperBound x - lowerBound x) + (upperBound y - lowerBound y)) / 2
-- => (upperBound x - lowerBound x) / 2 + (upperBound y - lowerBound y) / 2
-- => widthInterval x + widthInterval y

-- widthInterval (subInterval x y)
-- => widthInterval (addInterval x (makeInterval (- upperBound y) (- lowerBound y)))
-- => widthInterval (addInterval x (makeInterval (- upperBound y) (- lowerBound y)))
-- => widthInterval (makeInterval (lowerBound x - upperBound y) (upperBound x - lowerBound y)
-- => ((upperBound x - lowerBound y) - (lowerBound x - upperBound y)) / 2
-- => (upperBound x  - lowerBound x + upperBound y - lowerBound y) / 2
-- => (upperBound x  - lowerBound x) / 2 + (upperBound y - lowerBound y) / 2
-- => widthInterval x + widthInterval y

-- widthInterval (7,10) / widthInterval (3,4) => 3.0
-- widthInterval $ divInterval (7,10) (3,4) => 0.7916666666666665
-- widthInterval $ mulInterval (7,10) (3,4) => 9.5

-- test 2.10
divInterval' x y
  | upperBound y == 0 || lowerBound y == 0 = error "Zero cannot be divided"
  | otherwise = mulInterval x
                             (makeInterval (1 / upperBound y) (1 / lowerBound y))

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

mulInterval' x y
  | a >= 0 && b >= 0 && c >= 0 && d >= 0 = makeInterval (a*c) (b*d)
  | c < 0 && d < 0 && a < 0 && b < 0 = makeInterval (a*c) (b*d)
  | a < 0 && b >= 0 && c >= 0 && d >= 0 = makeInterval (a*d) (b*d)
  | c < 0 && a >= 0 && b >= 0 && d >= 0 = makeInterval (b*c) (b*d)
  | a < 0 && b < 0 && c >= 0 && d >= 0 = makeInterval (b*d) (a*c)
  | c < 0 && d < 0 && a >= 0 && b >= 0 = makeInterval (b*d) (a*c)
  | a < 0 && b < 0 && c < 0 && d >= 0 = makeInterval (b*d) (b*c)
  | a < 0 && c < 0 && d < 0 && b >= 0 = makeInterval (b*d) (a*d)
  | a < 0 && c < 0 && b >= 0 && d >= 0 = makeInterval (if a*d < b*c then a*d else b*c)
                                                       (if a*c > b*d then a*c else b*d)
  | otherwise = error "cannot be multiplication"
  where a = lowerBound x
        b = upperBound x
        c = lowerBound y
        d = upperBound y

makeCenterWidth c w = makeInterval (c - w) (c + w)

center i = (lowerBound i + upperBound i) / 2

width i = (upperBound i - lowerBound i) / 2

-- test 2.12
makeCenterPercent c p = makeInterval (c - c * p) (c + c * p)

percent i = width i / center i

-- test 2.13
-- percent (mulInterval (makeCenterPercent c1 p1) (makeCenterPercent c2 p2)) 假设区间端点都为正
-- => percent (mulInterval (makeCenterPercent c1 p1) (makeCenterPercent c2 p2))
-- => percent (mulInterval (makeInterval (c1 - c1 * p1) (c1 + c1 * p1)) (makeInterval (c2 - c2 * p2) (c2 + c2 * p2)))
-- => percent (makeInterval ((c1 - c1 * p1) * (c2 - c2 * p2)) ((c1 + c1 * p1) * (c2 + c2 * p2)))
-- => (((c1 + c1 * p1) * (c2 + c2 * p2)) - ((c1 - c1 * p1) * (c2 - c2 * p2))) / 2 / (( (((c1 + c1 * p1) * (c2 + c2 * p2)) + ((c1 - c1 * p1) * (c2 - c2 * p2))) ) /2)
-- => (((c1 + c1 * p1) * (c2 + c2 * p2)) - ((c1 - c1 * p1) * (c2 - c2 * p2))) / (((c1 + c1 * p1) * (c2 + c2 * p2)) + ((c1 - c1 * p1) * (c2 - c2 * p2)))
-- =>(c1c2 + c1c2p2 + c1p1c2 + c1p1c2p2 - (c1c2 - c1c2p2 - c1p1c2 + c1p1c2p2)) / (c1c2 + c1c2p2 + c1p1c2 + c1p1c2p2 + (c1c2 - c1c2p2 - c1p1c2 + c1p1c2p2))
-- => (2*c1c2p2 + 2*c1p1c2) / (2*c1c2 + 2*c1p1c2p2)
-- => (p2 + p1) / (1 + p1p2)  当p1 p2 都非常小时，可以忽略p1p2
-- => p1 + p2
-- 乘除法 (p2 + p1) / (1 + p1p2)
-- 加减法 (c1p1 + c2p2)/ (c1 + c2)
-- 加减法(宽度) (w1 + w2)
-- 乘除法(宽度) (c1w2 + c2w1)


mulPercent p1 p2 = (p2 + p1) / (1 + p1*p2)

-- test 2.14
par1 r1 r2 = divInterval (mulInterval r1 r2)
                          (addInterval r1 r2)

par2 r1 r2 = divInterval one
                          (addInterval (divInterval one r1)
                                        (divInterval one r2))
  where one = makeInterval 1 1

-- par1 (makeInterval 2 3) (makeInterval 3 4) => (0.8571428571428571,2.4000000000000004)
-- par2 (makeInterval 2 3) (makeInterval 3 4) => (1.2000000000000002,1.7142857142857144)
-- mulInterval (divInterval (makeInterval 1 2) (makeInterval 3 4)) (makeInterval 3 4) => (0.75,2.6666666666666665)
-- divInterval (makeInterval 2 3) (makeInterval 4 5) => (0.4,0.75)
-- divInterval (makeInterval 2 3) (makeInterval 2 3) => (0.6666666666666666,1.5)
-- divInterval (makeCenterPercent 100 0.001) (makeCenterPercent 100 0.001) => (0.9980019980019981,1.002002002002002)
-- mulInterval (divInterval (makeCenterPercent 100 0.001) (makeCenterPercent 100 0.001)) (makeCenterPercent 100 0.001) => (99.7003996003996,100.30040040040039)
-- 区间宽度更小时可以使结果更加精确

-- test 2.15
-- par2 = divInterval (mulInterval r1 r2) (addInterval r1 r2)
-- => mulInterval (mulInterval r1 r2) (divInterval one (addInterval r1 r2))
-- 说法正确, 减少非确定性区间的乘积计算可以使结果更加准确
-- 如果宽度变化为0，乘法或除法运算后的区间宽度百分比变化为 0

-- test 2.16
-- 因为非确定区间的运算会随着运算的进行使区间宽度不断增加
-- 分别取各个区间的最小值最大值，计算出的值得最小值最大值即为结果区间
varCalc f x y =
  let p1 = upperBound (f (makeCenterWidth (lowerBound x) 0) (makeCenterWidth (lowerBound y) 0))
      p2 = upperBound (f (makeCenterWidth (lowerBound x) 0) (makeCenterWidth (upperBound y) 0))
      p3 = upperBound (f (makeCenterWidth (upperBound x) 0) (makeCenterWidth (lowerBound y) 0))
      p4 = upperBound (f (makeCenterWidth (upperBound x) 0) (makeCenterWidth (upperBound y) 0))
  in makeInterval (minimum [p1, p2, p3, p4])
                (maximum [p1, p2, p3, p4])
-- varCalc par1 (3,4) (5,6) => (1.875,2.4000000000000004)
-- varCalc par2 (3,4) (5,6) => (1.875,2.4000000000000004)

-- test 2.17
lastPair (x:[]) = x
lastPair (x:xs) = lastPair xs

-- test 2.18
reverse' (x:[]) = [x]
reverse' (x:xs) = reverse xs ++ [x]

-- test 2.19
usCoins = [50, 25, 10, 5, 1]
ukCoins = [100, 50, 20, 10, 5, 2, 1, 0.5]
cc amount coinValues
  | amount == 0                       = 1
  | amount < 0 || noMore coinValues = 0
  | otherwise                         = (+) (cc amount (exceptFirstDenomination coinValues))
                                            (cc (amount - firstDenomination coinValues) coinValues)
  where firstDenomination (x:_) = x
        exceptFirstDenomination (_:xs) = xs
        noMore = null
-- 不会影响， 因为此递归过程会将所包含的组合都计算一遍，顺序不影响所包含的组合

-- test 2.20
sameParity (x:[]) = [x]
sameParity (x:xs)
        | odd x == odd (head xs) = x : sameParity xs
        | otherwise = sameParity (x : tail xs)
-- sameParity [2,3,4,5,6,7,8,9] => [2,4,6,8]
-- sameParity [1,2,3,4,5,6,7] => [1,3,5,7]

-- test 2.21
squareList [] = []
squareList (x:xs) = (x*x) : squareList xs

squareList' = map (\x -> x*x)

-- test 2.22
squareList'' items =
  let iter things answer
        | null things = answer
        | otherwise = iter (tail things) (answer ++ [head things * head things])
  in iter items []

-- test 2.23
forEach f items =
  let iter things none
        | null things = none
        | otherwise = iter (tail things) (f (head things) + none)
  in iter items (head items)
-- forEach (\x -> trace (show x) x) [1,2,3,4,5]

-- 在 haskell 中不能计算没有返回值的方法

-- example 2.2.2
-- countLeavels :: (L a)
-- countLeavels [x]
-- countLeavels [x]
-- countLeavels (x:xs)

