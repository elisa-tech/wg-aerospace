/* SPDX-License-Identifier: CC-BY-SA-4.0 */
#include <errno.h>
#include <netinet/in.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

int main(void) {
  int fd = socket(AF_INET, SOCK_DGRAM, 0);
  int error = fd < 0 ? errno : 0;

  printf("hello world\n");
  if (fd >= 0) {
    printf("NET-PROBE: IPv4/UDP socket available\n");
    close(fd);
  } else {
    printf("NET-PROBE: failed: errno=%d (%s)\n", error, strerror(error));
  }
  fflush(stdout);

  for (;;)
    pause();

  return 0;
}
