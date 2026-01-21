// SPDX-License-Identifier: MIT

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <inttypes.h>
#include <stdbool.h>
#include <syslog.h>

#include "elisa-v2.h"

#ifndef LOG_PATH
#define LOG_PATH "/var/log/syslog"
#endif
#define LIGHTS_ON_STRING  "lights: on"
#define LIGHTS_OFF_STRING "lights: off"
#define SWITCH_ON_STRING  "switch: on"
#define SWITCH_OFF_STRING "switch: off"

/*
 * Globals needed by the monitors to know the status of the system.
 */
bool lights      = false;
bool lightSwitch = false;

/*
 * Fault handler: the light switch didn't turn on or took too long.
 */
void violation1 () {
  syslog(LOG_ERR, "Monitor violation: light switch didn't turn on on time.");
  printf("Monitor violation: light switch didn't turn on on time.\n");
  exit(1);
}

/*
 * Fault handler: the light switch didn't turn off or took too long.
 */
void violation2 () {
  syslog(LOG_ERR, "Monitor violation: light switch didn't turn off on time.");
  printf("Monitor violation: light switch didn't turn off on time.\n");
  exit(1);
}

// Main function
int main() {
    // Open the syslog for reading and move to the end
    FILE *file = fopen(LOG_PATH, "r");
    if (!file) {
        perror("Error opening log file");
        exit(EXIT_FAILURE);
    }
#ifndef NOTAIL
    fseek(file, 0, SEEK_END);
#endif

    // Open the syslog for publishing notifications
    openlog("Copilot", LOG_PID | LOG_CONS, LOG_USER);

    // Process each packet received and re-run the monitors.
    char text[1024];
    while (1) {
        if (fgets(text, sizeof(text), file)) {
            if (strstr(text, LIGHTS_ON_STRING) != NULL)
               lights = true;
            if (strstr(text, LIGHTS_OFF_STRING) != NULL)
               lights = false;
            if (strstr(text, SWITCH_ON_STRING) != NULL)
               lightSwitch = true;
            if (strstr(text, SWITCH_OFF_STRING) != NULL)
               lightSwitch = false;
#ifndef NOTAIL
        } else {
          sleep (1);
          clearerr(file);
#endif
        }

        // Re-evaluate the monitors
        step();
    }

    // Close the syslog for reading and writing. Presumably, this is never
    // reached.
    closelog();
    fclose(file);
    return 0;
}
