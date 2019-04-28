module Lib
( someFunc
) where
  
import System.Random

drawInt :: Int -> Int -> IO Int
drawInt x y = getStdRandom (randomR (x,y))

random_list :: Int -> IO [Int]
random_list 0 = return []
random_list n = do
    a <- drawInt 1 20
    rest <- (random_list(n-1))
    return (a : rest)

someFunc :: IO ()
-- someFunc = putStrLn $ drawInt 4 100
someFunc = putStrLn (drawInt 4 100 ++ "")