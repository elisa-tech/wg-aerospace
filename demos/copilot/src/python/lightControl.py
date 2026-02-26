# SPDX-License-Identifier: MIT

import appConfiguration
import socket

LIGHT_ON_MESSAGE = "light 1: on"
LIGHT_OFF_MESSAGE = "light 2: on"


class LightControl:
    """ """

    def __init__(self):
        """ """
        self.lightAddress = appConfiguration.ServerConfiguration.LIGHT_ADDRESS_PORT
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    def TurnOn(self):
        """ """
        self._sendUDPmessage(LIGHT_ON_MESSAGE.encode("utf-8"))

    def TurnOff(self):
        """ """
        self._sendUDPmessage(LIGHT_OFF_MESSAGE.encode("utf-8"))

    def _sendUDPmessage(self, message):
        """ """
        self.sock.sendto(message, self.lightAddress)

    def Shutdown(self):
        """ """
        self.sock.close()
