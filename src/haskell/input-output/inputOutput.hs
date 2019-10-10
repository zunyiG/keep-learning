-- todo add todo.txt "todo item 1"
-- todo view todo.txt
-- todo remove todo.txt 2

import System.Environment
import System.Directory
import System.IO
import Data.List
import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString.Lazy.Char8 as C


main = do
  (acType : args) <- getArgs
  dispatch actions acType (\_ -> putStrLn ("WARN: Action type [" ++ acType ++ "] is undefined")) args

actions :: [(String, [String] -> IO ())]
actions = [ ("add", add)
          , ("view", view)
          , ("remove", remove)
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
            view [fileName]
    else do putStrLn "The file doesn't Exist"
add _ = putStrLn "The arguments must be: add [filename] [todo]"

view :: [String] -> IO ()
view [fileName] = do
  fileExist <- doesFileExist fileName
  if fileExist
    then do contents <- C.readFile fileName
            let tasks = zipWith
                          (\n line ->
                            (byteStringFromString (show n)) `C.append` (byteStringFromString " - ") `C.append` line)
                          [0..]
                          (C.lines contents)
            putStrLn "index - content"
            putStrLn "---------------"
            C.putStr $ C.unlines tasks
    else do putStrLn "The file doesn't Exist"
view _ = putStrLn "The arguments must be: view [filename]"

byteStringFromString :: String -> C.ByteString
byteStringFromString = foldr C.cons' C.empty

remove :: [String] -> IO ()
remove [fileName, index] = do
  fileExist <- doesFileExist fileName
  if fileExist
    then do contents <- C.readFile fileName
            let tasks = C.lines contents
            if read index >= 0 && read index < length tasks
              then do let removedTasks = delete (tasks !! read index) tasks
                      (tempName, tempHandle) <- openBinaryTempFile "." "temp"
                      C.hPutStr tempHandle (C.unlines removedTasks)
                      hClose tempHandle
                      removeFile fileName
                      renameFile tempName fileName
                      view [fileName]
              else do putStrLn "Invalid index"
    else do putStrLn "The file doesn't Exist"
remove _ = putStrLn "The arguments must be: remove [filename] [index]"
