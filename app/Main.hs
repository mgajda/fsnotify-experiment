{-# LANGUAGE ScopedTypeVariables #-}
module Main where

import Control.Monad(forever, forM_)
import Control.Concurrent
import Control.Concurrent.Chan as Chan
import System.FSNotify
import System.Environment

main = do
  evtChan <- Chan.newChan
  args <- getArgs
  putStrLn $ "CLI arguments: " <> show args
  forkIO $ forever $ readChan evtChan >>= print
  withManagerConf (defaultConfig { confDebounce = NoDebounce
                                 , confUsePolling = True }) $ \mgr -> do
    forM_ args $ \dirname -> 
      System.FSNotify.watchTreeChan mgr dirname (const True) evtChan
    threadDelay 10000000000
