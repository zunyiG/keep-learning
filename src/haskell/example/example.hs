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
