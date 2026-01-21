// SPDX-License-Identifier: MIT

/*
 * This file implements a main driver for the test of the light switch
 * and the lights turning on within a certain time.
 *
 * Limitations: This driver assumes that time is mononotic.
 * If an event is read from a file that corresponds to a past time, the time of
 * the event is adjusted (overwritten) so that it is assumed to have occurred
 * at a strictly later time.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <inttypes.h>
#include <stdbool.h>
#include <syslog.h>
#include <sys/time.h>

#include "elisa-time.h"

#ifndef LOG_PATH
#define LOG_PATH "/var/log/syslog"
#endif
#define LIGHTS_ON_STRING  "lights: on"
#define LIGHTS_OFF_STRING "lights: off"
#define SWITCH_ON_STRING  "switch: on"
#define SWITCH_OFF_STRING "switch: off"

/*
 * Clock used by the monitors.
 */
int64_t external_clock = 0;

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

/*
 * Update the internal clock to a new time.
 *
 * This function ensures that the clock is monotonic.
 */
void update_time(int64_t new_time) {
  if (new_time > external_clock) {
    external_clock = new_time;
  }
}

// Main function
int main(int argc, char *argv[]) {
    // Used if we need to get the system clock;
    struct timeval tv;
    int64_t milliseconds;

    // Determine which file to use. If one is passed as argument, use that,
    // otherwise use LOG_PATH
    char* file_path = LOG_PATH;
    if (argc > 1) {
      file_path = argv[1];
    }

    // Open the syslog for reading and move to the end
    FILE *file = fopen(file_path, "r");
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
    double lineTime;
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
            if (sscanf(text, "[%lf]", &lineTime) == 1) {
               update_time((int64_t)(lineTime*1000));
            }

            // Re-evaluate monitors only when new data is received.
            step();

        } else {

#if defined(CLOSE_AT_END)
          break;
#elif !(defined(NOTAIL))
          sleep (1);
          clearerr(file);
#endif

        }

    }

    // Close the syslog for reading and writing. Presumably, this is never
    // reached.
    closelog();
    fclose(file);
    return 0;
}
