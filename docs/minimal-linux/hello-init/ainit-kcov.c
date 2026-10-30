/* SPDX-License-Identifier: CC-BY-SA-4.0 */
#include <errno.h>
#include <stdio.h>
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <sys/mount.h>
#include <unistd.h>
#include <fcntl.h>
#include <linux/types.h>

#define KCOV_INIT_TRACE		_IOR('c', 1, unsigned long)
#define KCOV_ENABLE		_IO('c', 100)
#define KCOV_DISABLE		_IO('c', 101)
#define COVER_SIZE		(64 << 10)
#define KCOV_TRACE_PC		0

static _Noreturn void idle(int status)
{
    puts(status ? "KCOV: FAILED" : "KCOV: complete");
    fflush(stdout);
    for (;;)
        pause();
}

int main(void)
{
    int fd, error;
    long result;
    unsigned long *cover, n, i;

    mkdir("/sys", 0755);
    mkdir("/sys/kernel", 0755);
    mkdir("/sys/kernel/debug", 0755);
    if (mount("none", "/sys/kernel/debug", "debugfs", 0, NULL))
        perror("mount debugfs"), idle(1);

    fd = open("/sys/kernel/debug/kcov", O_RDWR);
    if (fd == -1)
        perror("open"), idle(1);

    if (ioctl(fd, KCOV_INIT_TRACE, COVER_SIZE))
        perror("ioctl"), idle(1);

    cover = (unsigned long *)mmap(NULL, COVER_SIZE * sizeof(unsigned long),
                                 PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    if ((void *)cover == MAP_FAILED)
        perror("mmap"), idle(1);

    if (ioctl(fd, KCOV_ENABLE, KCOV_TRACE_PC))
        perror("ioctl"), idle(1);

    __atomic_store_n(&cover[0], 0, __ATOMIC_RELAXED);
    errno = 0;
    result = syscall(SYS_read, -1, NULL, 0);
    error = errno;
    n = __atomic_load_n(&cover[0], __ATOMIC_RELAXED);

    if (ioctl(fd, KCOV_DISABLE, 0))
        perror("ioctl"), idle(1);

    if (result != -1 || error != EBADF) {
        fprintf(stderr, "unexpected read result: %ld, errno: %d\n", result, error);
        idle(1);
    }
    if (!n || n >= COVER_SIZE - 1) {
        fprintf(stderr, "empty or full coverage buffer: %lu PCs\n", n);
        idle(1);
    }
    for (i = 0; i < n; i++)
        printf("0x%lx\n", cover[i + 1]);

    if (munmap(cover, COVER_SIZE * sizeof(unsigned long)))
        perror("munmap"), idle(1);
    if (close(fd))
        perror("close"), idle(1);

    idle(0);
}
