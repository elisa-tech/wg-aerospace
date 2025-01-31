{-# LANGUAGE RebindableSyntax #-}
-- | License: SPDX-License-Identifier: MIT
module Auxiliary
  (module Auxiliary, module Copilot.Language, module Language.Copilot) where

-- Specific Copilot modules
import Copilot.Compile.C99
import Copilot.Language
import Language.Copilot

-- These are standard Haskell functions. We hide those that Copilot
-- re-exports.
import Prelude hiding ( not, (&&), (++), (<), (<=), (>=), (||) )

-- | True if a stream has been true repeatedly for a given number of samples.
repeatedly :: Int64 -> Stream Bool -> Stream Bool
repeatedly l s = s && (1 + clock - lastOn) >= lS
  where
    -- Constant stream with the value l.
    lS = constant l

    -- last time that s when from False to True.
    lastOn = lastTime (risingEdge s)

-- | True if a stream was true exactly a given number of samples ago.
ago :: Int64 -> Stream Bool -> Stream Bool
ago n s = replicate (fromIntegral n) False ++ s

-- | Number of steps since the last time a stream was True.
timeSinceLastTime :: Stream Bool -> Stream Int64
timeSinceLastTime input = clock - lastTime input

-- | Last time that some input stream when from False to True.
lastTime :: Stream Bool -> Stream Int64
lastTime input = g
  where
    g = if input then clock else ([0] ++ g)

-- | External clock, provided by the C program.
externalClock :: Stream Int64
externalClock = extern "external_clock" Nothing

-- | Discrete time, starting from zero.
-- 0, 1, 2, 3, etc.
clock :: Stream Int64
clock = [0] ++ (clock + 1)

-- | True whenever the given stream goes from False to True. False whenever
-- the values repeat or the current value of the given stream is false.
risingEdge :: Stream Bool -> Stream Bool
risingEdge s = s && not lastS
  where
    -- This is just the value of s delayed by one step (initially False).
    lastS = [False] ++ s

-- | Simplify compilation steps (first type check, then generate C code).
compileToC :: String -> Spec -> IO ()
compileToC fileName spec = do
  spec' <- reify spec
  compile fileName spec'
