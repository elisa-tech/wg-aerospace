from serverCommands import *

class ServerConfiguration:
    """ """
    # IP address and port the Light Server needs to bind to
    SERVER_ADDRESS_PORT = ('127.0.0.1',10000)
    # Serializer class(Defined in ServerCommands.py) that needs to be used to encode and decode server messages
    ServerCommandSerializer = ServerCommandLightText
    # IP address and port the of the light device    
    LIGHT_ADDRESS_PORT = ('127.0.0.1',10001)

class LoggingConfiguration:
    """ """
    SYSLOG_LOGGING_ENABLED = True
    SYSLOG_FILE_PATH = '/dev/log'
    LOG_FILE_LOGGING_ENABLED = True
    APP_LOG_FILE = 'lightApp.log'
    CONSOLE_LOGGING_ENABLED = True


