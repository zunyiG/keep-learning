-- todo add todo.txt "todo item 1"
-- todo view todo.txt
-- todo remove todo.txt 2

import System.Environment
import System.Directory
import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString.Lazy.Char8 as C


main = do
  (acType : args) <- getArgs
  dispatch actions acType (\_ -> putStrLn ("WARN: Action type [" ++ acType ++ "] is undefined")) args

actions :: [(String, [String] -> IO ())]
actions = [ ("add", add)
          , ("view", view)
          , ("remove", add)
          ]

dispatch :: (Eq a) => [(a, b)] -> a -> b -> b
dispatch actions acType empty =
  if null action
    then empty
    else let (Just ac) = action in ac
  where action = lookup acType actions

add :: [String] -> IO ()
add [fileName, todo] = do
  fileExist <- doesFileExist fileName
  if fileExist
    then do appendFile fileName (todo ++ "\n")
    else do putStrLn "The file doesn't Exist"
add _ = putStrLn "Missing arguments: add [filename] [todo]"

view :: [String] -> IO ()
view [fileName] = do
  contents <- C.readFile fileName
  let tasks = C.zipWith (\n line -> show n ++ " - " ++ line) [0..] (C.lines contents)
  C.putStr $ C.unlines tasks
view _ = putStrLn "Missing arguments: view [filename] [todo]"
