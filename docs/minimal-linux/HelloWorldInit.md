<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# How to build a simple init Hello World

This document shows how to build the minimal "hello world" program used as the
PID 1 application in the [Kernel Minimization](../KernelMinimization.md)
walkthrough. It is packed into a small initramfs and the kernel execs it
directly as `/init` (PID 1) — there is no init system, no shell, and no service
manager.

## Prerequisites

Install the build tooling once, per
[Kernel Minimization → Prerequisites](../KernelMinimization.md#prerequisites-toolchain-and-build-dependencies).
That covers the native `build-essential`, the `aarch64-linux-gnu` cross
toolchain, and `file` used to verify the static build below.

## The program

```c
#include <stdio.h>
#include <unistd.h>

int main(void)
{
    printf("hello world\n");
    fflush(stdout);

    /* PID 1 must never return. Idle forever. */
    for (;;)
        pause();

    return 0; /* not reached */
}
```

Save it as `ainit.c`.

## Static build

A PID 1 init should be statically linked so the kernel can exec it without
needing a dynamic loader or any libraries present in the rootfs:

```sh
# GCC (native)
gcc -static -O2 -o ainit ainit.c

# Cross-compile (example: aarch64)
aarch64-linux-gnu-gcc -static -O2 -o ainit ainit.c
```

Verify it's truly static (no interpreter, no shared-lib deps):

```sh
file ainit
# -> ELF 64-bit ... statically linked ...

ldd ainit
# -> "not a dynamic executable"
```

Install it into a staging directory as `/init` — the path the kernel runs
automatically from an initramfs:

```sh
ROOTFS=./rootfs
install -D -m 0755 ainit "$ROOTFS/init"
```

Because the binary is statically linked, that is the only file the initramfs
needs in order to boot.

## Pack the initramfs (non-root)

Pack the staging directory into a cpio initramfs. This runs as a normal user —
no `sudo`, no `mount`, no `mknod`:

```sh
( cd "$ROOTFS" && find . | cpio -o -H newc ) | gzip > initramfs.cpio.gz
```

`cpio -H newc` writes the kernel's expected newc format and `gzip` compresses
it. The result, `initramfs.cpio.gz`, is handed to QEMU with `-initrd` below. The
kernel needs initramfs support built in (`CONFIG_BLK_DEV_INITRD=y`, on by
default in `defconfig`).

## Boot it in QEMU

Boot the `Image` from the sibling walkthrough and pass the initramfs with
`-initrd`. The kernel runs `/init` from the initramfs automatically, so the only
cmdline you need is the console:

```sh
qemu-system-aarch64 -machine virt -cpu cortex-a57 -nographic \
    -kernel arch/arm64/boot/Image \
    -initrd initramfs.cpio.gz \
    -append 'console=ttyAMA0'
```

Notes:

- No `root=` and no disk image — the initramfs _is_ the root, and the kernel
  runs `/init` from it by default. (Use `rdinit=/sbin/init` on the `-append`
  line if you placed the binary somewhere other than `/init`.)
- `console=ttyAMA0` is the serial console on the arm64 `virt` machine; combined
  with `-nographic` the hello world print lands on your terminal.

## Behavior

Once booted, the kernel unpacks the initramfs, execs `/init` as PID 1, and
you'll see:

```text
hello world
```

Then the process parks in `pause()` forever — the system stays up (idle) with no
shell, no services, nothing else. Since the process never exits, you won't hit
the `Attempted to kill init!` panic. To shut down you close QEMU (`Ctrl-a x`
with `-nographic`); this minimal init doesn't handle signals or reboot.

## Metrics

Apply the same measurement practice used in
[Kernel Minimization → Metrics](../KernelMinimization.md#metrics): count SLOC with
the [`sloc-counter`](./sloc-counter) script and record the built size. For this
app:

```sh
docs/minimal-linux/sloc-counter files ainit.c     # source SLOC
size ainit                                         # text/data/bss of the binary
stat -c%s ainit                                    # static binary size on disk
stat -c%s initramfs.cpio.gz                        # packed initramfs size
```

Measured figures for this init (arm64, static build against glibc — numbers vary
by architecture and libc):

| Metric                             | Value                     | Notes                                                |
| ---------------------------------- | ------------------------- | ---------------------------------------------------- |
| Source SLOC (`sloc-counter files`) | 10                        | the whole application                                |
| Static binary, unstripped          | 634,000 B                 | dominated by the statically linked libc, not the app |
| Static binary, stripped            | 532,408 B                 | `aarch64-linux-gnu-strip ainit`                      |
| `size` (text/data/bss)             | 498,513 / 22,164 / 21,600 | mostly libc `text`                                   |
| `initramfs.cpio.gz`                | 279,571 B                 | gzip-compressed cpio of just `/init`                 |

The takeaway matches the base walkthrough's "Further reduction opportunities":
the 10 lines of application are negligible — the footprint is almost entirely
the static libc. Rebuilding against a smaller libc (e.g. musl) is the biggest
lever here; re-measure the same way to capture the delta.

## Probing a kernel feature (networking)

To tie a kernel-config decision to observable behavior, extend the init to
exercise a networking-stack feature — opening a UDP/IP socket. This should
succeed on a kernel built with the network stack and fail on one built without
it, giving a concrete pass/fail per config:

```c
#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/socket.h>
#include <netinet/in.h>

int main(void)
{
    printf("hello world\n");

    /* Probe a networking-stack feature: open a UDP/IP socket.
     * Succeeds with CONFIG_NET enabled; fails (e.g. ENOSYS /
     * EAFNOSUPPORT) on a kernel built without the network stack. */
    int fd = socket(AF_INET, SOCK_DGRAM, 0);
    if (fd >= 0) {
        printf("NET-PROBE: socket(AF_INET) OK -> network stack present\n");
        close(fd);
    } else {
        printf("NET-PROBE: socket(AF_INET) FAILED: %s -> no network stack\n",
               strerror(errno));
    }
    fflush(stdout);

    for (;;)
        pause();
    return 0;
}
```

Build, pack, and boot it against each kernel exactly as above. Measured results
(LTS v6.18.52, arm64):

| Kernel config         | Probe result                                       | As expected? |
| --------------------- | -------------------------------------------------- | ------------ |
| defconfig (has `NET`) | `socket(AF_INET) OK -> network stack present`      | yes (pass)   |
| defconfig − `NET`     | `socket(AF_INET) FAILED: Function not implemented` | yes (fail)   |
| tinyconfig + serial   | `socket(AF_INET) FAILED: Function not implemented` | yes (fail)   |

This turns "did we really remove the feature?" into a self-checking boot test:
the same binary reports success or the specific failure, so each config change is
verified by observed behavior rather than assumption.

## Dumping kernel coverage (KCOV)

The same init can also report which kernel code its syscalls _activate_ — the
runtime side of
[identifying activated code](../KernelMinimization.md#identifying-activated-code).
Build the kernel with coverage enabled (KCOV lives under debugfs):

```sh
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- defconfig
./scripts/config --enable KCOV --enable KCOV_INSTRUMENT_ALL --enable DEBUG_FS
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- olddefconfig
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j"$(nproc)" Image
```

Extend the init to mount debugfs (there is no init system to do it), enable
`kcov` over a syscall, and print how many kernel PCs that syscall activated. See
the kernel's [`Documentation/dev-tools/kcov.rst`](https://docs.kernel.org/dev-tools/kcov.html)
for the ioctl interface.

```c
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <errno.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/mount.h>

#define KCOV_INIT_TRACE _IOR('c', 1, unsigned long)
#define KCOV_ENABLE     _IO('c', 100)
#define KCOV_DISABLE    _IO('c', 101)
#define COVER_SIZE      (64 << 10)
#define KCOV_TRACE_PC   0

int main(void)
{
    printf("hello world\n");

    /* No init system: mount the filesystem kcov needs ourselves. */
    mount("debugfs", "/sys/kernel/debug", "debugfs", 0, NULL);

    int fd = open("/sys/kernel/debug/kcov", O_RDWR);
    if (fd < 0) {
        printf("KCOV: open failed: %s (need CONFIG_KCOV + debugfs)\n",
               strerror(errno));
        goto idle;
    }
    ioctl(fd, KCOV_INIT_TRACE, COVER_SIZE);
    unsigned long *cover = mmap(NULL, COVER_SIZE * sizeof(unsigned long),
                                PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);

    __atomic_store_n(&cover[0], 0, __ATOMIC_RELAXED);  /* reset count */
    ioctl(fd, KCOV_ENABLE, KCOV_TRACE_PC);

    (void)getpid();                                    /* exercise the kernel */

    unsigned long n = __atomic_load_n(&cover[0], __ATOMIC_RELAXED);
    ioctl(fd, KCOV_DISABLE, 0);

    printf("KCOV: collected %lu PC samples for our syscalls\n", n);
    for (unsigned long i = 0; i < (n < 3 ? n : 3); i++)
        printf("KCOV:   pc[%lu] = 0x%lx\n", i, cover[i + 1]);

idle:
    fflush(stdout);
    for (;;)
        pause();
    return 0;
}
```

Build it statically and pack it into the initramfs with the debugfs mount point
present, then boot as above:

```sh
aarch64-linux-gnu-gcc -static -O2 -o ainit-kcov ainit-kcov.c
mkdir -p rootfs/sys/kernel/debug
install -D -m 0755 ainit-kcov rootfs/init
( cd rootfs && find . | cpio -o -H newc ) | gzip > initramfs.cpio.gz
```

Measured output (LTS v6.18.52, arm64, defconfig + `KCOV`):

```text
hello world
KCOV: collected 29 PC samples for our syscalls
KCOV:   pc[0] = 0xffff8000804341e0
KCOV:   pc[1] = 0xffff8000804341e4
KCOV:   pc[2] = 0xffff8000804341ec
```

Those program counters are the kernel instructions a single `getpid()` drove;
resolving them against `vmlinux` (e.g. `addr2line -e vmlinux <pc>`) shows the
functions activated. Code never activated across representative runs is a removal
or deactivated-code candidate.
