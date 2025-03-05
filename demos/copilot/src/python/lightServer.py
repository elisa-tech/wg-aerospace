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

ServerCommand = appConfiguration.ServerConfiguration.ServerCommandSerializer

LIGHT_ON_LOG_MESSAGE = 'lights: on'
LIGHT_OFF_LOG_MESSAGE = 'lights: off'

class LightServer(threading.Thread):
    """Main thread that handles all server requests """
    
    def __init__(self):
        """ """
        super().__init__()
        self.running = True
        self.serverAddress = appConfiguration.ServerConfiguration.SERVER_ADDRESS_PORT
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.sock.setblocking(False)
        self.sock.bind(self.serverAddress)
        self.light = lightControl.LightControl()
        self.logger = logger.Logger().GetLogger()

    def run(self):
        """ Start the Light Server"""
        self.logger.info("Starting Light Server...")
        while self.running:
            try:
                commandData, address = self.sock.recvfrom(4096)
                # Parse the command
                serverCommand = ServerCommand.DeSerialize(commandData)
                if serverCommand.DeviceID == Devices.LIGHT:
                    if serverCommand.Command == ServerCommands.TURN_ON_DEVICE:
                        self.logger.info(LIGHT_ON_LOG_MESSAGE)
                        self.light.TurnOn()
                    elif serverCommand.Command == ServerCommands.TURN_OFF_DEVICE:
                        self.logger.info(LIGHT_OFF_LOG_MESSAGE)
                        self.light.TurnOff()
            except BlockingIOError:
                # This probably means that there is no data to read
                pass

            time.sleep(.01)
        
    def stop(self):
        """ Stop the Light server"""
        self.running = False
        self.sock.close()
    

class ServerMain:
    """Main application that is responsibel for kicking off the server thread and monitoring signals. """
    def __init__(self):
        """ """
        self.LightServer = LightServer()
        self.logger = logger.Logger().GetLogger()
    
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
            while self.LightServer.is_alive():
                time.sleep(1)
        except Exception as e:
            self.logger.critical(f"Unexpected Error: {e}. Shutting Down Server")
            
        finally:
            self.LightServer.stop()
            self.LightServer.join()           
                    
if __name__ == "__main__":

    # Start the application
    app = ServerMain()
    app.Start()