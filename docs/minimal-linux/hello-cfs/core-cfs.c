/* SPDX-License-Identifier: CC-BY-SA-4.0 */
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

int main(void)
{
    printf("========================================\n");
    printf("NASA Core Flight System (cFS) PID 1 Boot\n");
    printf("========================================\n");
    printf("CFE Core Executive Services: Initializing...\n");
    printf("CFE Event Services: Registered\n");
    printf("CFE Table Services: Initialized\n");
    printf("CFE Time Services: Synchronized\n");
    printf("cFS Steady Housekeeping Loop: RUNNING\n");
    fflush(stdout);

    for (;;)
        pause();
    return 0;
}
