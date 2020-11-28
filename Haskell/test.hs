import System.Directory
import System.IO.Unsafe
import Data.IORef

tempGlobal :: IORef [Int]
tempGlobal = unsafePerformIO (newIORef [])

readVal :: IO [Int]
readVal = readIORef tempGlobal

writeVal :: [Int] -> IO ()
writeVal value = writeIORef tempGlobal value

tryfunc :: IO()
tryfunc = do
 let list = [1,2,3]
 writeVal list
 list2 <- readVal
 print list2