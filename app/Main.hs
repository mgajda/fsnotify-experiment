{-# LANGUAGE ScopedTypeVariables #-}
module Main where

import Control.Monad(forever)
import Control.Concurrent
import Control.Concurrent.Chan as Chan
import System.FSNotify

main = do
  evtChan <- Chan.newChan
  forkIO $ forever $ readChan evtChan >>= print
  withManagerConf (defaultConfig { confDebounce = NoDebounce
                                 , confUsePolling = False }) $ \mgr -> do
    System.FSNotify.watchTreeChan mgr "." (const True) evtChan
    threadDelay 10000000000
