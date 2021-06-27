{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE ApplicativeDo #-}
module Main where

import Control.Monad(forever, forM_)
import Control.Concurrent
import Control.Concurrent.Chan as Chan
import System.FSNotify
import System.Environment

class Arrow    f
   => ArrowMap f where
  mapA :: Foldable t => (arr a b, a i [a]) -> a b [b]

main = do
  evtChan <- Chan.newChan
  args <- getArgs
  let watched | null args = ["."]
              | otherwise = args
  putStrLn $ "CLI arguments: " <> show args
  forkIO $ forever $ readChan evtChan >>= print
  withManagerConf (defaultConfig { confDebounce = NoDebounce, confUsePolling = True }) $ \mgr -> do
    forM_ watched $ \dirname -> 
      System.FSNotify.watchDirChan mgr dirname (const True) evtChan
    threadDelay 10000000000
