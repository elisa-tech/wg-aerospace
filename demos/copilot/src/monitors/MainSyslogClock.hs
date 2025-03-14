{-# LANGUAGE NoImplicitPrelude #-}
-- | License: SPDX-License-Identifier: MIT
import Auxiliary

-- * System inputs

-- | External input that indicates whether the lights are on.
lightsOn :: Stream Bool
lightsOn = extern "lights" Nothing

-- | External input that indicates whether the lights are off.
lightsOff :: Stream Bool
lightsOff = not lightsOn

-- | This is true any time the lights go from off to on.
lightsTurnedOn :: Stream Bool
lightsTurnedOn = risingEdge lightsOn

-- | This is true any time the lights go from on to off.
lightsTurnedOff :: Stream Bool
lightsTurnedOff = risingEdge lightsOff

-- | External input that indicates whether the switch is in the on position.
switchOn :: Stream Bool
switchOn = extern "lightSwitch" Nothing

-- | External input that indicates whether the switch is in the off position.
switchOff :: Stream Bool
switchOff = not switchOn

-- | This is true any time the switch goes from off to on.
switchTurnedOn :: Stream Bool
switchTurnedOn = risingEdge switchOn

-- | This is true any time the switch goes from on to off.
switchTurnedOff :: Stream Bool
switchTurnedOff = risingEdge switchOff

-- * System Requirements

-- | SR1: The Cabin Lights system shall turn lights on in less than 500 ms of
--        the light switch turning on.
--
-- EC: the light switch turns on and, for 500 ms, the lights remain off.
--
-- EC (refined): If the lights are off, the switch was turned on 500 ms ago
-- and the lights have been off for more than that time.
monitor1 :: Stream Bool
monitor1 = lightsOff
        && timeSinceLastTime' switchTurnedOn > limit
        && timeSinceLastTime' lightsTurnedOn > limit

-- | SR2: The Cabin Lights system shall turn lights off in less than 500 ms of
--        the light switch turning off.
--
-- EC: the light switch turns off and, for 500 ms, the lights remain on.
monitor2 :: Stream Bool
monitor2 = lightsOn
        && timeSinceLastTime' switchTurnedOff > limit
        && timeSinceLastTime' lightsTurnedOff > limit

-- | Constant limit: amount of steps betwen the light switch turning on and
-- the light turning on.
limit :: Stream Int64
limit = 500

-- * Specification

-- | Main specification to check
spec :: Spec
spec = do
  -- Call the function violation1 with no args whenever monitor1 becomes true.
  trigger "violation1" monitor1 []

  -- Call the function violation2 with no args whenever monitor2 becomes true.
  trigger "violation2" monitor2 []

-- * Main program

-- | Main Copilot entry.
main :: IO ()
main =
  -- Copilot supports multiple actions, including running an interpreter to
  -- debug specs, and running formal analysis to prove properties about a
  -- system. In this case, we only care about compiling to C.
  compileToC "elisa-time" spec
