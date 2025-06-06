import logging
import logging.handlers
import appConfiguration
import time  # Import time module for epoch time

class Logger:
    """ This class wraps the python logger and allows for the logger to be configured as required for the application."""
    _instance = None
    def __new__(class_, *args, **kwargs):
        if class_._instance is None:
            class_._instance = super(Logger, class_).__new__(class_)
            class_._instance._initalize()
        return class_._instance

    def _initalize(self):
        """ """
        self.logger = logging.getLogger('Logger')
        self.logger.setLevel(logging.DEBUG)

        # Create a syslog handler
        if appConfiguration.LoggingConfiguration.SYSLOG_LOGGING_ENABLED == True:
            syslogHandler = logging.handlers.SysLogHandler(address='/dev/log')
            syslogHandler.setLevel(logging.INFO)
            self.logger.addHandler(syslogHandler)
        
        # Create a file handler
        if appConfiguration.LoggingConfiguration.LOG_FILE_LOGGING_ENABLED == True:
            fileHandler = logging.FileHandler(appConfiguration.LoggingConfiguration.APP_LOG_FILE)
            fileHandler.setLevel(logging.INFO)
            
            # Add a formatter with epoch time in nano seconds
            fileFormatter = logging.Formatter('[%(created)f] %(message)s')
            fileHandler.setFormatter(fileFormatter)
            
            self.logger.addHandler(fileHandler)
        
        # Create a console handler
        if appConfiguration.LoggingConfiguration.CONSOLE_LOGGING_ENABLED == True:
            consoleHandler = logging.StreamHandler()
            consoleHandler.setLevel(logging.DEBUG)
            self.logger.addHandler(consoleHandler)                


    def GetLogger(self):
        """ """
        return self.logger
