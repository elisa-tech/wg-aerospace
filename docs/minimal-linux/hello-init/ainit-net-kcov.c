/* SPDX-License-Identifier: CC-BY-SA-4.0 */
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <sys/mount.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>

#define KCOV_INIT_TRACE _IOR('c', 1, unsigned long)
#define KCOV_ENABLE     _IO('c', 100)
#define KCOV_DISABLE    _IO('c', 101)
#define KCOV_TRACE_PC   0
#define COVER_SIZE      (64 * 1024)

int main(void)
{
    printf("hello world\n");
    if (mkdir("/sys", 0755) != 0 && errno != EEXIST) {
        perror("mkdir /sys");
        return 1;
    }
    if (mkdir("/sys/kernel", 0755) != 0 && errno != EEXIST) {
        perror("mkdir /sys/kernel");
        return 1;
    }
    if (mkdir("/sys/kernel/debug", 0755) != 0 && errno != EEXIST) {
        perror("mkdir /sys/kernel/debug");
        return 1;
    }
    if (mount("debugfs", "/sys/kernel/debug", "debugfs", 0, NULL) != 0) {
        perror("mount debugfs");
        return 1;
    }
    int fd = open("/sys/kernel/debug/kcov", O_RDWR);
    if (fd < 0) {
        perror("open /sys/kernel/debug/kcov");
        return 1;
    }
    if (ioctl(fd, KCOV_INIT_TRACE, COVER_SIZE) != 0) {
        perror("ioctl KCOV_INIT_TRACE");
        close(fd);
        return 1;
    }
    unsigned long *cover = (unsigned long *)mmap(NULL,
        COVER_SIZE * sizeof(unsigned long),
        PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    if (cover == MAP_FAILED) {
        perror("mmap");
        close(fd);
        return 1;
    }
    if (ioctl(fd, KCOV_ENABLE, KCOV_TRACE_PC) != 0) {
        perror("ioctl KCOV_ENABLE");
        munmap(cover, COVER_SIZE * sizeof(unsigned long));
        close(fd);
        return 1;
    }

    __atomic_store_n(&cover[0], 0, __ATOMIC_RELAXED);

    /* Target syscall: socket probe */
    int s = socket(AF_INET, SOCK_DGRAM, 0);

    if (ioctl(fd, KCOV_DISABLE, 0) != 0) {
        perror("ioctl KCOV_DISABLE");
    }

    if (s >= 0) {
        printf("NET-PROBE: IPv4/UDP socket available\n");
        close(s);
    } else {
        printf("NET-PROBE: failed: errno=%d (%s)\n", errno, strerror(errno));
    }

    unsigned long n = __atomic_load_n(&cover[0], __ATOMIC_RELAXED);
    printf("KCOV captured %lu PCs:\n", n);
    for (unsigned long i = 0; i < n; i++) {
        printf("0x%lx\n", cover[i + 1]);
    }

    munmap(cover, COVER_SIZE * sizeof(unsigned long));
    close(fd);

    for (;;)
        pause();
    return 0;
}
