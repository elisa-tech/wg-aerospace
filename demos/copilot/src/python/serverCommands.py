# SPDX-License-Identifier: MIT

from enum import Enum
from abc import ABC, abstractmethod
import json
import struct
class ServerCommands(Enum):
    """List of the different possible Server Commands """
    TURN_OFF_DEVICE = 0
    TURN_ON_DEVICE = 1
    ACK = 3
    NACK = 4

class Devices(Enum):
    """ List of available devices"""
    LIGHT = 1

class ServerCommandBase(ABC):
    """ Base class to abstract away message format details"""
    def __init__(self, deviceID, command):
        """ Constructor """
        self.DeviceID = deviceID
        self.Command = command

    @abstractmethod
    def Serialize(self):
        """ Function that serializes this class into a command that can be transmitted"""
        pass

    @staticmethod
    @abstractmethod
    def DeSerialize(data):
        """ Function that unpack datas from a raw utf-8 buffer into an object."""
        pass


class ServerCommandJson(ServerCommandBase):
    """ Class to handle server messages in the JSON format"""
    def __init__(self, deviceID, command):
        """ """
        self.DeviceID = deviceID
        self.Command = command
    
    def Serialize(self):
        """Serialize the server command into a JSON string """

        # This is a hack to get the Json serializer to work. json.dumps doesn't work with enums
        # and therefore requires the enums to be replaced with their corresponding raw values. 
        # we temporarily replace the enums with the corresponing integer values and restore them after
        # the call to json.dumps
        self.DeviceID = self.DeviceID.value
        self.Command = self.Command.value

        # Serialize the data
        serializedData = json.dumps(self.__dict__).encode('utf-8')

        # Restore the fields back to the enum type
        self.DeviceID = Devices(self.DeviceID)
        self.Command = ServerCommands(self.Command)

        return serializedData

    @staticmethod
    def DeSerialize(data):
        """ Unpack JSON command into a server command object"""
        jsonObj = json.loads(data.decode('utf-8'))
        return ServerCommandJson(Devices(jsonObj['DeviceID']),ServerCommands(jsonObj['Command']))


class ServerCommandLightText(ServerCommandBase):
    """Class to handle server messages in the text format.
       class expects commands to be in the format 
       'lights: on' or 'lights: off' """
    CommandPrefix = "lights"
    CommandSeparator = ": "
    OnCommand = "on"
    OffCommand = "off"

    def __init__(self, deviceID, command):
        """ """
        self.Command = command
        self.DeviceID = Devices.LIGHT
    
    def Serialize(self):
        """ Serialize the server command into a custom text format."""
        command = ServerCommandLightText.CommandPrefix + ServerCommandLightText.CommandSeparator + ServerCommandLightText.OnCommand if \
                    self.Command == ServerCommands.TURN_ON_DEVICE else \
                    ServerCommandLightText.CommandPrefix + ServerCommandLightText.CommandSeparator + ServerCommandLightText.OffCommand
        return command.encode('utf-8')

    @staticmethod
    def DeSerialize(data):
        """ Unpack text string into a server command object"""
        returnValue = None
        command = data.decode('utf-8').split(sep = ServerCommandLightText.CommandSeparator, maxsplit=1)
        if len(command) == 2 and command[0] == ServerCommandLightText.CommandPrefix:
            # This means that this is a light command
            returnValue = ServerCommandLightText(Devices.LIGHT, ServerCommands.TURN_OFF_DEVICE if command[1] == ServerCommandLightText.OffCommand else ServerCommands.TURN_ON_DEVICE) 
        return returnValue

class ServerCommandLightRaw(ServerCommandBase):
    """Class to handle server messages in a raw binary format
       that consists of two bytes - First byte for Device ID and second byte for Server Command """

    def __init__(self, deviceID, command):
        """ """
        self.Command = command
        self.DeviceID = Devices.LIGHT
    
    def Serialize(self):
        """ Serialize the server command into a custom binary format."""
        command = struct.pack('>bb',self.DeviceID.value, self.Command.value)
        return command

    @staticmethod
    def DeSerialize(data):
        """ Unpack binary data into a server command object"""
        returnValue = None
        if len(data) == 2:
            # This means that this is a light command
            (devId, cmd) = struct.unpack('>bb',data)
            returnValue = ServerCommandLightRaw(Devices(devId), ServerCommands(cmd))

        return returnValue        
