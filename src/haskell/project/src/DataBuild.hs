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
cons :: a -> b -> (a -> b -> c) -> c
cons x y = \m -> m x y

car :: ((a -> b -> a) -> a) -> a
car z = z (\p q -> p)

-- 代换模型
-- car' (cons' x y)
-- => car' (\m -> m x y)
-- => (\m -> m x y) (\p q -> p)
-- => (\p q -> p) x y
-- => x

cdr :: ((a -> b -> b) -> b) -> b
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

-- 当 y > 33 或 x > 971 时会出现计算错误，可能因为除法会被表示为科学技术法,会被 round 于除，造成误差
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

data List a = Nil | Cons a (List a) | Cons2 (List a) (List a) deriving (Eq)

instance (Show a) => Show (List a) where
  show (Nil) = "nil"
  show (Cons x xs) = show x ++ " -> " ++ show xs
  show (Cons2 l r) = "(" ++ show l ++ ", " ++ show r ++ ")"

instance Foldable List where
  foldr _ m (Nil) = m
  foldr f m (Cons x xs) = foldr f (f x m) xs
  foldr f m (Cons2 l r) = foldr f (foldr f m l) r

listSingle :: a -> List a
listSingle x = Cons x Nil

listInsert :: a -> List a -> List a
listInsert x (Nil) = listSingle x
listInsert x xs = Cons x xs

listFrom :: [a] -> List a
listFrom = foldr listInsert Nil

listRef :: Int -> List a -> a
listRef 0 (Cons x _) = x
listRef n (Cons x xs) = listRef (n-1) xs

listLength :: (Integral b) => List a -> b
listLength = foldr (\_ len -> len + 1) 0

listAppend :: List a -> List a -> List a
-- listAppend (Nil) xs = xs
-- listAppend (Cons x xs) ys = listInsert x (listAppend xs ys)
listAppend = flip (foldl (flip listInsert))

listFirst :: List a -> a
listFirst = listRef 0

listFilter :: (a -> Bool) -> List a -> List a
-- listFilter _ (Nil) = Nil
-- listFilter f (Cons x xs) = if (f x)
--                               then listInsert x (listFilter f xs)
--                               else listFilter f xs
listFilter f = foldl (\ys x -> if f x then listInsert x ys else ys) Nil

listMap :: (a -> b) -> List a -> List b
-- listMap _ (Nil) = Nil
-- listMap f (Cons x xs) = listInsert (f x) (listMap f xs)
listMap f = foldl (\ys x -> listInsert (f x) ys) Nil

-- test 2.17
listLast :: List a -> a
listLast (Cons x Nil) = x
listLast (Cons x xs) = listLast xs

-- test 2.18
listReverse :: List a -> List a
-- listReverse Nil = Nil
-- listReverse (Cons x xs) = listAppend (listReverse xs) (listSingle x)
listReverse = foldr (\x ys -> listInsert x ys) Nil

-- test 2.19
usCoins :: (Fractional a) => List a
usCoins = listFrom [50, 25, 10, 5, 1]
ukCoins :: (Fractional a) => List a
ukCoins = listFrom [100, 50, 20, 10, 5, 2, 1, 0.5]

cc :: (Num a, Num b, Ord a) => a -> List a -> b
cc amount coinValues
  | amount == 0                       = 1
  | amount < 0 || noMore coinValues = 0
  | otherwise                         = (+) (cc amount (exceptFirstDenomination coinValues))
                                            (cc (amount - firstDenomination coinValues) coinValues)
  where firstDenomination (Cons x xs) = x
        exceptFirstDenomination (Cons x xs) = xs
        noMore = (==) Nil
-- 不会影响， 因为此递归过程会将所包含的组合都计算一遍，顺序不影响所包含的组合

-- test 2.20
sameParity :: (Integral a) => List a -> List a
sameParity all@(Cons x xs) = listFilter (\y -> odd x == odd y) all
-- sameParity [2,3,4,5,6,7,8,9] => [2,4,6,8]
-- sameParity [1,2,3,4,5,6,7] => [1,3,5,7]

-- test 2.21
squareList :: (Num a) => List a -> List a
squareList (Nil) = Nil
squareList (Cons x xs) = listInsert (x * x) (squareList xs)

squareList' = listMap (\x -> x * x)

-- test 2.22
squareList'' items =
  let
      iter (Nil) answer = answer
      iter (Cons x xs) answer = iter xs (listInsert (x * x) answer)
  in iter items Nil

-- 1. 因为插入过程是反向的，先插入最里层，最后插入最外层， 所有最后结果是反向的: cons 4 (cons 3 (cons 2 ( cons 1 nil)))
-- 2. 还是不行是因为，只是把cons的参数交换了，但是插入顺序还是反向的: cons (cons (cons (cons nil 1) 2) 3) 4

-- test 2.23
forEach :: (a -> b -> b) -> b -> List a -> b
forEach _ y (Nil) = y
forEach f y (Cons x xs) = forEach f (f x y) xs
-- forEach (\x y -> trace (show y) x) 0 (listFrom [1,2,3,4,5,6,7])

-- example 2.2.2
data Tree a = Empty | Leaf a | Node a (Tree a) (Tree a) deriving (Eq)

instance (Show a) => Show (Tree a) where
  show (Empty)    = "empty"
  show (Leaf a)   = show a
  show (Node a l r) = show a ++ " -> (" ++ show l ++ ", " ++ show r ++ ")"

treeLength :: (Num b) => Tree a -> b
treeLength (Empty)      = 0
treeLength (Leaf _)     = 1
treeLength (Node a l r) = treeLength l + treeLength r

-- test 2.24
-- [1, ->] -> [2, ->] -> [3, 4]
-- Cons 1 (Cons 2 (Cons2 (Cons 3 Nil) (Cons 4 Nil)))
-- 1 -> 2 -> (3 -> nil, 4 -> nil)
-- Node 1 (Node 2 (Leaf 3) (Leaf 4)) Empty
-- 1 -> (2 -> (3, 4), empty)

-- test 2.25
-- 1. (1 3 (5 7) 9)
-- let l = cons 1 (cons 3 (cons (cons 5 (cons 7 Nil)) (cons 9 Nil)))
-- car (cdr (car (cdr (cdr l))))

-- 2. ((7))
-- let l = cons (cons 7 Nil) Nil
-- car (car l)

-- 3. (1 (2 (3 (4 (5 (6, 7))))))
-- let l = cons 1 (cons 2 (cons 3 (cons 4 (cons 5 (cons 6 7)))))
-- cdr (cdr (cdr (cdr (cdr (cdr l)))))

-- test 2.26
-- 1. listAppend (listFrom [1,2,3]) (listFrom [4,5,6])
-- 1 -> 2 -> 3 -> 4 -> 5 -> 6 -> nil

-- 2. List (listFrom [1,2,3]) (listFrom [4,5,6])
-- (1 -> 2 -> 3 -> nil, 1 -> 2 -> 3 -> nil)

-- 3. listFrom [listFrom [1,2,3], listFrom [1,2,3]]
-- (1 -> 2 -> 3 -> nil) -> (1 -> 2 -> 3 -> nil) -> nil

-- test 2.27
listReverseDeep :: List a -> List a
listReverseDeep = listReverse
-- listReverseDeep (Cons2 (listFrom [1,2,3]) (listFrom [4,5,6]))
-- 6 -> 5 -> 4 -> 3 -> 2 -> 1 -> nil

-- test 2.28
fringe :: List a -> List a
fringe = foldl (flip listInsert) Nil
-- fringe (Cons2 (Cons2 (Cons 1 Nil) (Cons 2 Nil)) (Cons2 (Cons 3 Nil) (Cons 4 Nil)))
-- 1 -> 2 -> 3 -> 4 -> nil

-- test 2.29
data Branch a b = Branch b (Mobile a b) | LeafBranch b b deriving (Show)
data Mobile a b = Mobile (Branch a b) (Branch a b) deriving (Show)

makeMobile :: Branch a b -> Branch a b -> Mobile a b
makeMobile left right = Mobile left right

makeLeafBranch :: b -> b -> Branch a b
makeLeafBranch length weight = LeafBranch length weight

makeBranch :: b -> Mobile a b -> Branch a b
makeBranch length structure = Branch length structure

-- a.
leftBranch :: Mobile a b -> Branch a b
leftBranch (Mobile left _) = left

rightBranch :: Mobile a b -> Branch a b
rightBranch (Mobile _ right) = right

branchLength :: Branch a b -> b
branchLength (Branch length _) = length
branchLength (LeafBranch length _) = length

branchStructure :: Branch a b -> Mobile a b
branchStructure (Branch _ m) = m

-- b.
totalWeight :: (Num b) => Mobile a b -> b
totalWeight (Mobile left right) = totalBranch left + totalBranch right

totalBranch :: (Num b) => Branch a b -> b
totalBranch (LeafBranch _ b) = b
totalBranch (Branch _ m) = totalWeight m

-- totalWeight (Mobile (LeafBranch 1 2) (Branch 1 ( Mobile (Branch 2 ( Mobile (LeafBranch 3 4) (LeafBranch 3 5) )) (LeafBranch 2 3) )))
-- => 14

-- c.
equalCheck :: (Num b, Eq b) => Mobile a b -> Bool
equalCheck (Mobile left right) = (
                                    (==)
                                    ((branchLength left) * (totalBranch left))
                                    ((branchLength right) * (totalBranch right))
                                  )
                                && equalCheckBranch left
                                && equalCheckBranch right

equalCheckBranch :: (Num b, Eq b) => Branch a b -> Bool
equalCheckBranch (Branch length m) = equalCheck m
equalCheckBranch _ = True

-- equalCheck (Mobile (LeafBranch 6 2) (Branch 2 ( Mobile (Branch 2 ( Mobile (LeafBranch 2 4) (LeafBranch 8 1) )) (LeafBranch 10 1) )))
-- => True

-- d.
-- 由于使用了参数解构，所以改动很大。可以使用层次性数据来减少这种耦合性
-- 重构

-- 数据构建层
data Mobile' a b = Mobile' (Mobile' a b) (Mobile' a b) | Branch' b (Mobile' a b) | LeafBranch' b b deriving (Show)

leftBranch' :: Mobile' a b -> Mobile' a b
leftBranch' (Mobile' left _) = left

rightBranch' :: Mobile' a b -> Mobile' a b
rightBranch' (Mobile' _ right) = right

branchLength' :: Mobile' a b -> b
branchLength' (Branch' length _) = length
branchLength' (LeafBranch' length _) = length

branchStructure' :: Mobile' a b -> Mobile' a b
branchStructure' (Branch' _ m) = m

branchWight' :: Mobile' a b -> b
branchWight' (LeafBranch' _ w) = w

isMobile :: Mobile' a b -> Bool
isMobile (Mobile' _ _) = True
isMobile _ = False

isBranch :: Mobile' a b -> Bool
isBranch (Branch' _ _) = True
isBranch _ = False

isLeafBranch :: Mobile' a b -> Bool
isLeafBranch (LeafBranch' _ _) = True
isLeafBranch _ = False

-- 数据应用层
totalWeight' :: (Num b) => Mobile' a b -> b
totalWeight' m
  | isMobile m     = totalWeight' (leftBranch' m) + totalWeight' (rightBranch' m)
  | isBranch m     = totalWeight' (branchStructure' m)
  | isLeafBranch m = branchWight' m

-- (Mobile' (LeafBranch' 1 2) (Branch' 1 ( Mobile' (Branch' 2 ( Mobile' (LeafBranch' 3 4) (LeafBranch' 3 5) )) (LeafBranch' 2 3) )))
-- => 14


treeMap :: (a -> b) -> Tree a -> Tree b
treeMap _ (Empty)      = Empty
treeMap f (Leaf x)     = Leaf (f x)
treeMap f (Node x l r) = Node (f x) (treeMap f l) (treeMap f r)

-- treeMap (\x->x*2) (Node 1 (Leaf 2) (Node 3 (Leaf 4) (Leaf 5)))
-- 2 -> (4, 6 -> (8, 10))

-- test 2.30 2.31
squareTree' :: (Num a) => Tree a -> Tree a
squareTree' (Empty)      = Empty
squareTree' (Leaf x)     = Leaf (x * x)
squareTree' (Node x l r) = Node (x * x) (squareTree' l) (squareTree' r)

squareTree :: (Num a) => Tree a -> Tree a
squareTree = treeMap (\x -> x * x)

-- test 2.32
subsets :: (Show a) => List a -> List (List a)
subsets (Cons x xs) =
  let rest = subsets xs
  in  listAppend (
        foldr (\y ys -> listAppend ys (Cons (listInsert x y) Nil))
              (Cons (Cons x Nil) Nil)
              rest
      ) rest
subsets (Nil) = Nil
-- subsets (listFrom [1,2,3])
-- 1 -> nil -> 1 -> 2 -> nil -> 1 -> 2 -> 3 -> nil -> 1 -> 3 -> nil -> 2 -> nil -> 2 -> 3 -> nil -> 3 -> nil -> nil

-- 所有子集等于
-- 1.当前元素 (x)
-- 2.当前元素和其它组合的组合 (foldr)
-- 3.不包含当前元素的组合 (rest)

-- test 2.33
accumulate :: (b -> a -> b) -> b -> List a -> b
accumulate _ acc (Nil) = acc
accumulate f acc (Cons x xs) = accumulate f (f acc x) xs
accumulate f acc (Cons2 xs ys) = accumulate f (accumulate f acc xs) ys

-- accumulateR _ acc (Nil) = acc
-- accumulateR f acc (Cons x xs) = f (accumulate f acc xs) x

accumulateR :: (a -> b -> b) -> b -> List a -> b
accumulateR f acc xs = accumulate (\g x y -> g (f x y)) id xs acc

-- accumulate f (\g x y -> g (f x y) id x) xs
-- => accumulate f (\y -> id (f x y)) xs
-- => accumulate f (\y -> f x y) xs
-- => accumulate f ((\g x y -> g (f x y)) (\y1 -> f x1 y1) x) xs
-- => accumulate f ((\y2 -> f x1 (f x2 y2))) xs
-- => accumulate f ((\y3 -> f x1 (f x2 (f x3 y3)))) xs
-- => accumulateR (\y3 -> f x1 (f x2 (f x3 y3))) acc

accumulateL :: (b -> a -> b) -> b -> List a -> b
accumulateL f acc xs = accumulateR (\x g realAcc -> g (f realAcc x)) id xs acc

sequenceMap :: (a -> b) -> List a -> List b
sequenceMap f = accumulateR (\x xs -> listInsert (f x) xs) Nil

sequenceAppend :: List a -> List a -> List a
sequenceAppend xs ys = accumulateR listInsert ys xs

sequenceLength :: (Num b) => List a -> b
sequenceLength = accumulateL (\n _ -> n + 1) 0

-- test 2.34
hornerEval :: (Num a) => a -> List a -> a
hornerEval x = accumulateR (\a acc -> a + acc * x) 0
-- hornerEval 2 (listFrom [1,3,0,5,0,1])
-- 79

-- test 2.35
countLevel :: (Num b) => List a -> b
countLevel = accumulateR (\_ n -> n + 1) 0
-- countLevel (Cons2 (Cons 2 Nil) (Cons2 (Cons 3 Nil) (Cons 3 Nil)))
-- 3

-- test 2.36

accumulateZip :: (b -> a -> b) -> b -> List (List a) -> List b
accumulateZip _ _ (Cons (Nil) _) = Nil
accumulateZip f acc xs =
  listInsert
  (accumulateL f acc (accumulateL (\ys (Cons z _) -> listInsert z ys ) Nil xs))
  (accumulateZip f acc (accumulateL (\ys (Cons _ zs) -> listInsert zs ys ) Nil xs))
  --  accumulateZip (+) 0 (listFrom [listFrom [1,2,3], listFrom [4,5,6], listFrom [7,8,9], listFrom [10,11,12]])
  -- 22 -> 26 -> 30 -> nil

zipWithList' :: (a -> b -> c) -> List a -> List b -> List c
zipWithList' _ _ (Nil) = Nil
zipWithList' _ (Nil) _ = Nil
zipWithList' f (Cons x xs) (Cons y ys) = listInsert (f x y) (zipWithList' f xs ys)

-- test 2.37
-- dotProduct :: List (List a) -> List (List a) -> List (List a)
