/* SPDX-License-Identifier: CC-BY-SA-4.0 */
#include <stdio.h>
#include <unistd.h>

int main(void)
{
    printf("hello world\n");
    fflush(stdout);

    for (;;)
        pause();

    return 0;
}
