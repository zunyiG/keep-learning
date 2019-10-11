import System.Random

getRandomRage :: (Random a) => (a, a) -> IO a
getRandomRage r = randomRIO r


getRandomRageList :: (Random a) => (a, a) -> IO [a]
getRandomRageList r = do
  gen <- getStdGen
  newStdGen
  return $ randomRs r gen
