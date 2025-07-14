# SPDX-License-Identifier: MIT
from serverCommands import *
import socket
import logger
import time
import signal

ServerCommand = ServerCommandLightText
SWITCH_ON_LOG_MESSAGE = 'switch: on'
SWITCH_OFF_LOG_MESSAGE = 'switch: off'
STOP_SWITCH = False
#Ip = "127.0.0.1"  
#Port = 10000 

Interface =  'lo'

DestMac = b'\x00\x00\x00\x00\x00\x00'
SrcMac = b'\x00\x00\x00\x00\x00\x00'

switchLogger = logger.Logger().GetLogger()

def SendRawPacket(message):
    """Sends a Raw packet to the Light Server."""

    eth_type = 0x88B5
    sock = socket.socket(socket.AF_PACKET, socket.SOCK_RAW, socket.htons(eth_type))
    sock.bind((Interface, 0))
    ethernet_frame = DestMac + SrcMac + struct.pack('!H', eth_type) + message
    sock.send(ethernet_frame)

    sock.close()

def TurnLightOn():
    """ """    
    com = ServerCommand(Devices.LIGHT, ServerCommands.TURN_ON_DEVICE)       
    sres = (com.Serialize())
    SendRawPacket(sres)
    switchLogger.info(SWITCH_ON_LOG_MESSAGE)

def TurnLightOff():
    """ """
    com = ServerCommand(Devices.LIGHT, ServerCommands.TURN_OFF_DEVICE)       
    sres = (com.Serialize())
    SendRawPacket(sres)
    switchLogger.info(SWITCH_OFF_LOG_MESSAGE)

def SignalHandler(signum, frame):
    """ """
    global STOP_SWITCH
    switchLogger.info(f"Received signal {signum}. Shutting down the switch")
    STOP_SWITCH = True
    

if __name__ == "__main__":

    signal.signal(signal.SIGUSR1, SignalHandler)
    
    while STOP_SWITCH == False:
        
        TurnLightOff()
        # Wait for a 1 sec before attempting to turn the switch on
        time.sleep(1)

        TurnLightOn()
        # Wait for a 1 sec before attempting to turn the switch off
        time.sleep(1)

