solveRPN :: String -> Float
solveRPN =
  head . foldl g [] . words
  where g (x:y:xs) "+" = (y + x):xs
        g (x:y:xs) "-" = (y - x):xs
        g (x:y:xs) "*" = (y * x):xs
        g (x:y:xs) "/" = (y / x):xs
        g (x:y:xs) "^" = (y ** x):xs
        g (x:xs) "log" = (log x):xs
        g xs "sum" = [sum xs]
        g xs num = (read num):xs

-- data Node = Node Road Road | EndNode Road
data Node = Node Road (Maybe Road) deriving (Show)
data Road = Road Int Node deriving (Show)

data Section = Section {getA :: Int, getB :: Int, getC :: Int} deriving (Show)
type RoadSystem = [Section]

data Label = A | B | C deriving (Show)
type Path = [(Label, Int)]

heathrowToLondon :: RoadSystem
heathrowToLondon = [Section 50 10 30, Section 5 90 20, Section 40 2 25, Section 10 8 0]

optimalPath :: RoadSystem -> Path
optimalPath rs =
  let (pathA, pathB, priceA, priceB) = foldl roadStep ([], [], 0, 0) rs
  in if priceA < priceB then reverse pathA else reverse pathB

roadStep :: (Path, Path, Int, Int) -> Section -> (Path, Path, Int, Int)
roadStep (pathA, pathB, priceA, priceB) (Section a b c) =
  let isForwardToA = priceA + a < priceB + b + c
      isForwardToB = priceB + b < priceA + a + c
  in (
       (if isForwardToA then (A, a):pathA else (C, c):(B, b):pathB)
      ,(if isForwardToB then (B, b):pathB else (C, c):(A, a):pathA)
      ,(if isForwardToA then priceA + a else priceB + b + c)
      ,(if isForwardToB then priceB + b else priceA + a + c)
      )

listToRoadSystem :: [Int] -> RoadSystem
listToRoadSystem [] = []
listToRoadSystem xs =
  let [a, b, c] = (take 3 xs)
  in (Section a b c) : (listToRoadSystem $ drop 3 xs)

--  optimalPath $ listToRoadSystem [1,2,3,4,5,6,6,7,8,9,0,1,1,2,3,4,2,3]
