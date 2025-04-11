# SPDX-License-Identifier: MIT
import threading
import signal
import time
import sys
import socket
from serverCommands import *
import logger
import appConfiguration
import lightControl
import random
import argparse
import re

ServerCommand = appConfiguration.ServerConfiguration.ServerCommandSerializer

LIGHT_ON_LOG_MESSAGE = 'lights: on'
LIGHT_OFF_LOG_MESSAGE = 'lights: off'

class ServerDelayType(Enum):
    """List of the different possible Server Commands """
    OFF = 0
    FIXED = 1
    RANDOM = 2

class LightServerDelay(object):
    """ Class that allows control of the time taken by the server to act on a received command."""
    def __init__(self):
        """ """

        # Set up some default values
        self.DelayControlSetting = ServerDelayType.OFF
        self.DelayFixedMs = 200
        self.RandomDelayLowerLimitMs = 100
        self.RandomDelayUpperLimitMs = 700
        self.RandomDelayIncrement = 100

        self.LockObj = threading.Lock()
        self.logger = logger.Logger().GetLogger()
    
    def SetDelayOff(self):
        """ Turn off Delay"""
        self.logger.info("Setting delay to default(100 ms)")
        with self.LockObj:
            self.DelayControlSetting = ServerDelayType.OFF
        

    def SetDelayFixed(self, delayTimeMs):
        """ Set delay to a fixed value"""
        self.logger.info(f"Setting delay to fixed - {delayTimeMs} ms")
        with self.LockObj:
            self.DelayControlSetting = ServerDelayType.FIXED
            self.DelayFixedMs = delayTimeMs
    
    def IncreaseFixedDelay(self):
        """ Add 100ms to delay time"""
        self.logger.info(f"Increasing delay time by 100 ms")        
        if self.DelayControlSetting == ServerDelayType.FIXED:
            with self.LockObj:
                self.DelayControlSetting = ServerDelayType.FIXED
                # we don't want to allow delay less than 100ms                
                self.DelayFixedMs = self.DelayFixedMs + 100
    
    def DecreaseFixedDelay(self):
        """ Reduce delay time by 100ms"""
        self.logger.info(f"Reducing delay time by 100 ms")
        if self.DelayControlSetting == ServerDelayType.FIXED:
            with self.LockObj:
                self.DelayControlSetting = ServerDelayType.FIXED
                # we don't want to ensure that delay is not less than 100ms
                if self.DelayFixedMs - 100 > 100: 
                    self.DelayFixedMs = self.DelayFixedMs - 100

    def SetDelayRandom(self, delayTimeLowerLimitMs, delayTimeUpperLimitMs):
        """ Turn off Delay"""
        self.logger.info(f"Setting delay to Random - {delayTimeLowerLimitMs} ms to {delayTimeUpperLimitMs} ms")
        with self.LockObj:
            self.DelayControlSetting = ServerDelayType.RANDOM
            self.RandomDelayLowerLimitMs = delayTimeLowerLimitMs
            self.RandomDelayUpperLimitMs = delayTimeUpperLimitMs

    def DoDelay(self):
        """ """
        delayTimeSec = 0.0

        with self.LockObj:
            # Even if the delay is set to off, add a delay for at least 100ms
            if ServerDelayType.OFF == self.DelayControlSetting:
                delayTimeSec = .1
            elif ServerDelayType.FIXED == self.DelayControlSetting:
                delayTimeSec = self.DelayFixedMs/1000
            else:
                # Return a random value in increments of 100 ms
                delayTimeSec = random.randrange(self.RandomDelayLowerLimitMs, self.RandomDelayUpperLimitMs, self.RandomDelayIncrement)/1000
            
        time.sleep(delayTimeSec)


class LightServer(threading.Thread):
    """Main thread that handles all server requests """
    
    def __init__(self, delayController):
        """ """
        super().__init__()
        self.running = True
        self.serverAddress = appConfiguration.ServerConfiguration.SERVER_ADDRESS_PORT
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.sock.setblocking(False)
        self.sock.bind(self.serverAddress)
        self.light = lightControl.LightControl()
        self.DelayController = delayController
        self.logger = logger.Logger().GetLogger()

    def run(self):
        """ Start the Light Server"""
        self.logger.info("Starting Light Server...")
        while self.running:
            try:
                commandData, address = self.sock.recvfrom(4096)
                # Parse the command
                serverCommand = ServerCommand.DeSerialize(commandData)
                
                # Add a delay before commanding the light based on the configuration
                self.DelayController.DoDelay()

                if serverCommand.DeviceID == Devices.LIGHT:
                    if serverCommand.Command == ServerCommands.TURN_ON_DEVICE:
                        self.logger.info(LIGHT_ON_LOG_MESSAGE)
                        self.light.TurnOn()
                    elif serverCommand.Command == ServerCommands.TURN_OFF_DEVICE:
                        self.logger.info(LIGHT_OFF_LOG_MESSAGE)
                        self.light.TurnOff()

            except BlockingIOError:
                # This probably means that there is no data to read
                # Wait for a little while allow the server to respond to one command before
                # moving on to the next and also reduce load on the CPU.
                time.sleep(.01)
            
        
    def stop(self):
        """ Stop the Light server"""
        self.running = False
        self.sock.close()
    

class ServerMain:
    """Main application that is responsibel for kicking off the server thread and monitoring signals. """
    def __init__(self, delayController):
        """ """
        self.DelayController = delayController
        self.LightServer = LightServer(delayController)
        self.logger = logger.Logger().GetLogger()

    def _parseCommand(self, inputLine):
        """ """
        fixedCommandPattern = r'^fixed +(\d+)'
        randomCommandPattern = r'^random +(\d+) +(\d+)'
        higherPattern = r'^higher *'
        lowerPattern = r'^lower *'

        fixedCommandMatch = re.match(fixedCommandPattern,inputLine)
        randomCommandMatch = re.match(randomCommandPattern,inputLine)
        higherCommandMatch = re.match(higherPattern,inputLine)
        lowerCommandMatch = re.match(lowerPattern,inputLine)

        if fixedCommandMatch:
            self.DelayController.SetDelayFixed(int(fixedCommandMatch[1]))
        elif randomCommandMatch:
            self.DelayController.SetDelayRandom(int(randomCommandMatch[1]), int(randomCommandMatch[2]))
        elif higherCommandMatch:
            if self.DelayController.DelayControlSetting == ServerDelayType.FIXED:
                self.DelayController.IncreaseFixedDelay()
            else:
                print("higher command is only applicable in fixed delay mode ")
        elif lowerCommandMatch:
            if self.DelayController.DelayControlSetting == ServerDelayType.FIXED:
                self.DelayController.DecreaseFixedDelay()                
            else:
                print("lower command is only applicable in fixed delay mode ")
        else:
            print("Invalid Command")
        
    def SignalHandler(self, signum, frame):
        """ """
        self.logger.info(f"\nReceived signal {signum}. Shutting down the server")
        self.LightServer.stop()
        self.LightServer.join()
        
        sys.exit(0)
           
    def Start(self):
        """ """
        # register the signal handler
        signal.signal(signal.SIGINT, self.SignalHandler)
        signal.signal(signal.SIGTERM, self.SignalHandler)
        
        self.LightServer.start()
        
        try:
            print("Enter Commands (fixed <delay>, random <low> <high>, higher or lower).")
            while self.LightServer.is_alive():
                commandText = input()
                command = self._parseCommand(commandText)

        except Exception as e:
            self.logger.critical(f"Unexpected Error: {e}. Shutting Down Server")
            
        finally:
            self.LightServer.stop()
            self.LightServer.join()           
                    
if __name__ == "__main__":

    # Parse Command line args
    parser = argparse.ArgumentParser(description="Light Server program with configurable delay")

    delay_group = parser.add_mutually_exclusive_group()
    delay_group.add_argument('--delay-fixed', type=int, help="Fixed delay time in millisecond")
    delay_group.add_argument('--delay-random', type=int, nargs=2, metavar = ('lowerLimit', 'upperLimit'), 
                                help="Random delay lower limit and upper limit in millisecond(low high)")

    cmdLineArgs = parser.parse_args()

    delayController= LightServerDelay()

    if cmdLineArgs.delay_fixed is not None:        
        delayController.SetDelayFixed(cmdLineArgs.delay_fixed)
    elif cmdLineArgs.delay_random is not None:
        lowerLimit, upperLimit = cmdLineArgs.delay_random
        delayController.SetDelayRandom(lowerLimit, upperLimit)
    else:
        delayController.SetDelayOff()

        
    # Start the application
    app = ServerMain(delayController)
    app.Start()