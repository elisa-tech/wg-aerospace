<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Kernel Minimization

This document describes how we can minimize a Linux Kernel to run a flight
application on it. Minimizing the kernel can help reduce the footprint needed
in deployment and reduce the amount of code that needs to be verified for
safety/security before a flight.

The primary deliverable is a **repeatable workflow** — a documented process any
team can apply to their own system scenario, BSP, hardware, and product case.
The specific kconfig is secondary to the process; the Hello World and Hello cFS
examples below are analysis targets for developing and demonstrating the
workflow, not a prescribed configuration.

Imagine the scenario where we want the computer to run a minimal program upon
start that writes Hello World to the serial console, and we want to run it on
Linux. If we don't need multiple processes, or networking, running a full Linux
kernel with the same options we'd need for a desktop environment would be
overbloated.

This document assumes a specific baseline scenario, and the rest of the
walkthrough follows from it:

**Baseline: the flight application is launched directly by the kernel as PID 1
via `init=<application>` bootargs. There is no init system, no service manager,
and no general multiuser user space.**

See [Hello World init](./minimal-linux/HelloWorldInit.md) for how to build the statically
linked PID 1 program used as the `<application>` in this walkthrough. The same
techniques then can be applied to a demonstration flight application written
using NASA Core Flight System in [Hello cFS](./minimal-linux/KernelMinimizationCFS.md).

Certification-level progression (moving a minimized kernel up from a low
software level toward higher assurance) is a separate, related track kept out of
this build/measure sequence — see
[Certification progression](./minimal-linux/CertificationProgression.md).

## Customizing a kernel

### Technique

A practical way to approach minimization is to pick a direction and iterate:
**change → build → test → measure → document**. The commands below use `arm64`
as the worked example.

#### Prerequisites: toolchain and build dependencies

On an x86_64 host you need native build essentials, the AArch64 cross toolchain,
and the usual kernel build dependencies. This covers both the kernel build below
and the userspace init build in [Hello World init](./minimal-linux/HelloWorldInit.md). On
Debian/Ubuntu:

```bash
sudo apt update
sudo apt install -y build-essential file gcc-aarch64-linux-gnu \
    bison flex libssl-dev libelf-dev bc make git cpio qemu-system-arm cloc
```

- `build-essential` — native `gcc`/`make` and the static libc used by
  `gcc -static` (the userspace init build).
- `gcc-aarch64-linux-gnu` — the `aarch64-linux-gnu-` cross compiler used via
  `CROSS_COMPILE` below and for cross-building the init. (For a native arm64
  build host, drop `CROSS_COMPILE` and this package.)
- `bison flex libssl-dev libelf-dev bc make git` — kernel build dependencies.
- `file` — used to confirm a binary is statically linked.
- `cpio` — packs the initramfs in [Hello World init](./minimal-linux/HelloWorldInit.md).
- `qemu-system-arm` — provides `qemu-system-aarch64` for booting the arm64
  `Image` (used in the walkthrough and in [Hello World init](./minimal-linux/HelloWorldInit.md)).
- `cloc` — counts SLOC for the Metrics tables.

#### Start from a fresh kernel.org clone

Use the `linux-stable` tree and shallow-clone the latest LTS (longterm) series
so you pull a single release worth of history rather than the whole tree, and
track a kernel with a long maintenance window. Check the current longterm
version at <https://www.kernel.org/> (the "longterm:" lines) and use its
`linux-<major>.<minor>.y` branch:

```bash
# Replace 6.18 with the current latest LTS/longterm series shown on kernel.org
LTS=linux-6.18.y

git clone --depth 1 --branch "$LTS" \
    https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git \
    linux
cd linux

git describe --tags   # confirm the exact LTS release you cloned
```

#### Build the default arm64 configuration

Export the arch/toolchain once so the rest of the commands stay short:

```bash
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-

make defconfig                 # arch/arm64/configs/defconfig -> .config
make -j"$(nproc)" Image        # builds arch/arm64/boot/Image
```

This gives you a known-good baseline to measure against before you remove
anything.

> With the kernel `Image` built, build the workload you'll boot to test it —
> follow [Hello World init](./minimal-linux/HelloWorldInit.md) to produce the
> `initramfs.cpio.gz`, then come back here to iterate on the config.

#### Iterate toward minimal

Pick a direction:

- **Bottom-up** — start from almost nothing and add only what the workload
  needs:

  ```bash
  make tinyconfig
  # enable exactly what you need, e.g. the serial console for "Hello World":
  ./scripts/config --enable TTY --enable SERIAL_AMBA_PL011 \
      --enable SERIAL_AMBA_PL011_CONSOLE
  make olddefconfig             # resolve dependencies for the changes
  make -j"$(nproc)" Image
  ```

- **Top-down** — start from `defconfig` and remove features, re-testing after
  each removal:

  ```bash
  ./scripts/config --disable IPV6      # example: drop a feature
  make olddefconfig
  make -j"$(nproc)" Image
  ```

Instead of editing options one at a time on the command line, you can browse the
full configuration tree interactively with `menuconfig` and toggle options with
their help text in view:

```bash
make menuconfig
```

`menuconfig` uses an ncurses text UI, so install its dependency first if it is
not already present (Debian/Ubuntu): `sudo apt install -y libncurses-dev`.

After each change, boot the `Image` under QEMU
(`qemu-system-aarch64 -machine virt -kernel arch/arm64/boot/Image ...`) and
confirm the workload still runs before measuring.

This walkthrough uses the kernel's own `make tinyconfig` as the bottom-up
starting point. Published minimal configs are alternatives you can start from or
measure against instead — e.g. Boeing's arm64 `minimal_defconfig`, the ELISA
LFSCS minimal config, and community sets such as
[under-view/tiny-linux-kconfigs](https://github.com/under-view/tiny-linux-kconfigs/tree/master/linux-6.12).
(The [minimal-buildroot aarch64-virt config](https://github.com/afbjorklund/minimal-buildroot/blob/main/board/qemu/aarch64-virt/linux.config)
is another, but it is less minimal — it enables a full ext4 filesystem and the
ATA/SCSI subsystems.) Boeing and LFSCS are measured as reference rows in
[Minimal Kernel Config Analysis](./minimal-linux/KernelConfigAnalysis.md).

#### Higher-level, reproducible alternative

Editing kconfig by hand makes dependency management tedious. This working group
also maintains a higher-level, reproducible approach using Nix, where you toggle
features in a structured config and let the build resolve dependencies for you —
see the
[Nix-based kernel configuration walk-through](../demos/AvioNix-demo/NixBasedKernelConfig.md).
The same iterate-and-measure loop applies whether you drive it through raw
kconfig, a Yocto `defconfig` fragment, or Nix.

Whichever direction you choose, record the exact config delta for each step
(`scripts/diffconfig` between saved `.config` files is handy) so a reviewer or a
later flight-cert activity can reproduce it.

### Feature considerations (userspace + kernel)

The baseline decision above (no-init, PID 1 application) cascades into the rest
of the configuration:

- **No init system** — no `systemd`/BusyBox-init, no service management, no
  getty/login. The kernel hands control straight to the application.
- **Reduced POSIX surface** — because there is no shell, no multiuser session,
  and no general-purpose user space, we only need the POSIX/library features the
  application itself calls. We are not targeting full POSIX conformance;
  anything the workload does not exercise is a removal candidate.
- **Minimal user-space libraries** — the rootfs carries essentially the
  application plus the minimal libc it links against, not a distro user space.
- **Single-process model** — multi-process/job-control features can be treated
  as optional and evaluated for removal.
- **Networking** — decide whether the stack is required by the application at
  all; if not, remove it. (Worked example: disabling `IPV6` cascades into
  removal of `CONFIG_NET_IP_TUNNEL`, `CONFIG_INET_TUNNEL`, `CONFIG_DST_CACHE`,
  `CONFIG_GRO_CELLS`, and related options — see the
  [Nix kernel config doc](../demos/AvioNix-demo/NixBasedKernelConfig.md).)
- **Storage / filesystems** — enable only what is needed to hold and launch the
  application (e.g. a single fs type or an initramfs), not the desktop defaults.

The intent is a defensible chain: *the application needs X → therefore option Y
is enabled → everything else is removed*. Starting from a no-init, PID 1
application makes that chain short and easy to justify.

## Evaluating an executable

Even with a no-init, PID 1 launch, the application still exercises a set of
system calls and kernel subsystems — the job here is to enumerate exactly that
set and nothing more. Trace the workload rather than guessing; the upstream
[workload-tracing admin guide](https://docs.kernel.org/admin-guide/workload-tracing.html)
describes the method, and ELISA's
[Discovering Linux kernel subsystems used by a workload](https://github.com/elisa-tech/ELISA-White-Papers/blob/master/Processes/Discovering_Linux_kernel_subsystems_used_by_a_workload.md)
is a companion write-up.

Flow:

1. Run the target as PID 1 (or under tracing on a known-good kernel) and collect
   the syscalls/subsystems it uses.
2. Map those to the kernel config options that provide them.
3. Because there is no init system or general user space, expect this set to be
   small — treat everything outside it as a removal candidate.
4. Re-test after each pruning step.

Concrete ways to collect that information:

- **`strace` (syscall level)** — the quickest first pass. Run the application
  under `strace` and summarize which syscalls it actually makes:

  ```sh
  strace -f -c ./app                 # per-syscall summary counts
  strace -f -e trace=%file ./app     # e.g. just filesystem-related syscalls
  ```

  The set of syscalls used maps fairly directly to the subsystems (and therefore
  config options) the workload depends on. `strace -k` adds stack traces if you
  need to see *where* a syscall comes from.

- **`ftrace` / `perf` (kernel internals)** — to see the kernel functions and
  subsystems reached (not just the syscall boundary), use the in-kernel tracers.
  This is the method the upstream
  [workload-tracing admin guide](https://docs.kernel.org/admin-guide/workload-tracing.html)
  walks through, e.g. `trace-cmd record`/`trace-cmd report` (an ftrace
  front-end) or `perf trace`/`perf record`. These require the tracing options
  the guide lists (e.g. `CONFIG_FTRACE`), so run them on a known-good
  measurement kernel, not the minimized target.

- **QEMU (emulated, no target hardware)** — because this walkthrough already
  boots the workload in QEMU, you can evaluate it there. Run the tracers above
  inside the guest, or use QEMU's own facilities: `-d in_asm,cpu,int` / `-D
  qemu.log` for low-level execution logging, and the GDB stub (`-s -S` +
  `gdb-multiarch vmlinux`) to break on kernel entry points and confirm which
  paths a workload reaches. This keeps the whole evaluate → prune → re-test loop
  on the emulator.

Related ELISA tracing/minimization work to build on: LFSCS
[`min_prog_trace`](https://github.com/elisa-tech/wg-lfscs/tree/main/min_prog_trace).

### Identifying activated code

Tracing shows which subsystems are *reached*; coverage shows which code is
actually *activated* (executed) versus merely built in. Build the measurement
kernel with coverage and observe it under the workload:

- **`gcov` (kernel GCOV,** `CONFIG_GCOV_KERNEL`**)** — line/branch execution
  counts for the built-in code, collected from `/sys/kernel/debug/gcov`.
- **`kcov`** (`CONFIG_KCOV`**)** — per-task PC traces of the kernel paths a
  specific workload drives; good for attributing activated code to *this* app.
  See [Hello World init → Dumping kernel coverage (KCOV)](./minimal-linux/HelloWorldInit.md#dumping-kernel-coverage-kcov)
  for a worked example.

Use the activated set two ways:

1. **Minimization** — code that is present but never activated across
   representative runs is a strong removal candidate; re-test after pruning to
   confirm it was not latent-but-needed.
2. **Verification argument** — the activated-vs-present split maps onto the
   DO-178C distinction between activated and deactivated code. Code that remains
   in the image but is never activated must either be removed or be justified and
   handled as deactivated code. Treat coverage as evidence to focus that
   analysis, not as proof on its own (see
   [Measuring Linux Kernel Complexity](./minimal-linux/KernelComplexity.md) and
   [Certification progression](./minimal-linux/CertificationProgression.md)).

## Metrics

Capture the same measurements at each iteration so configurations are comparable
across contributors and architectures:

- **SLOC** of the resulting kernel — a distro-generic proxy for "amount of code
  that must be verified for safety/security before flight." We report two
  numbers: a **DWARF / elf-to-sloc** count (distinct source lines that actually
  emitted object code — the closer proxy for structural-coverage effort) and, as
  a secondary **upper bound**, a `cloc` count of every compiled source file.
- **Image size** — recorded as a sanity bound only, not a score (see the note
  below); build variability makes it a poor scalar metric.
- **Boots?** and **workload passes?** — the config is only valid if the target
  still runs (boot-test in QEMU as in [Hello World init](./minimal-linux/HelloWorldInit.md)).

### Counting kernel SLOC

Use the [`sloc-counter`](./minimal-linux/sloc-counter) script (in
`minimal-linux/`). It offers two
kernel counts:

- **`dwarf` (headline)** — the elf-to-sloc approach: distinct `file:line`
  entries in the DWARF line table of a `vmlinux` built with `CONFIG_DEBUG_INFO`,
  i.e. only source lines that actually emitted object code. This is the number
  to track for certification effort. It matches the method used in the ELISA
  research (see below).
- **`kernel` (upper bound)** — wraps [`cloc`](https://github.com/AlDanial/cloc)
  over the sources actually compiled for your `.config` (from
  `compile_commands.json`), mirroring the Unikraft build-time SLOC approach
  ([unikraft/unikraft#1880](https://github.com/unikraft/unikraft/pull/1880)). It
  counts every non-comment line of each compiled file, so it runs roughly **2x**
  the DWARF number.

```sh
# headline: distinct source lines that emitted object code
docs/minimal-linux/sloc-counter dwarf /path/to/linux/vmlinux
# -> e.g. 171739   (needs CONFIG_DEBUG_INFO; override disassembler via $OBJDUMP)

# upper bound: cloc over compiled sources
docs/minimal-linux/sloc-counter kernel /path/to/linux
# -> e.g. 342997
```

Both are cheap because the kernel records an exact compile command per object
and a DWARF line table per line of emitted code.

### Measuring the image (sanity bound only)

Image size is worth a glance as an upper bound, but is a poor scalar success
metric: it depends on compression, bootloader wrapping, compiler version and
optimization level, and even build-host speed. Track it to stay under a ceiling
(e.g. "well under a few MiB"), not as a score. To measure both forms:

```sh
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image Image.gz
stat -c%s arch/arm64/boot/Image      # raw
stat -c%s arch/arm64/boot/Image.gz   # compressed

file arch/arm64/boot/Image           # -> Linux kernel ARM64 boot executable Image
file arch/arm64/boot/Image.gz        # -> gzip compressed data ...
```

### Measured results (LTS v6.18.52, arm64)

The rows below were produced by following this walkthrough: build the config
(with `CONFIG_DEBUG_INFO` for the DWARF count), boot-test it in QEMU with the
[Hello World init](./minimal-linux/HelloWorldInit.md) initramfs, then measure with
`sloc-counter dwarf` and `sloc-counter kernel`.

**Feature-group progression** — starting from `tinyconfig` + serial and adding
one subsystem group at a time toward `defconfig`. The groups are the subsystems
that separate `tinyconfig` from `defconfig` (found with `scripts/diffconfig`):

| Step                | DWARF SLOC | cloc SLOC (upper bound) | Image (raw) | Boots? |
| ------------------- | ---------- | ----------------------- | ----------- | ------ |
| tinyconfig + serial | 171,739    | 342,997                 | 2.9 MiB     | yes    |
| + `NET`             | 273,678    | 521,825                 | 4.1 MiB     | yes    |
| + block / `EXT4`    | 319,767    | 597,973                 | 4.6 MiB     | yes    |
| + `PCI` / `USB`     | 346,568    | 649,022                 | 5.1 MiB     | yes    |
| defconfig (full)    | 1,212,643  | 2,748,291               | 47 MiB      | yes    |

Every step still boots the workload. The progression shows what each subsystem
group costs in verifiable code: the network stack alone roughly *doubles* the
DWARF SLOC over the serial-only baseline, and the jump from a curated minimal set
to full `defconfig` is ~7x. The serial baseline enables only `TTY`,
`SERIAL_AMBA_PL011`, `SERIAL_AMBA_PL011_CONSOLE`, `PRINTK`, `BINFMT_ELF`, and
`BLK_DEV_INITRD` (enough to exec the initramfs `/init` and print to the `virt`
machine's PL011 console).

For a deeper comparison against published minimal configs (Boeing, ELISA LFSCS)
and how these counts relate to prior measurements, see
[Minimal Kernel Config Analysis](./minimal-linux/KernelConfigAnalysis.md).

### Beyond size: complexity

SLOC and image size measure *how much* code ships, but not *how hard it is to
verify* or *how deterministic it is* — separate concerns that matter for a
certification/partitioning argument (DO-178C, AMC 20-193). Those need their own
definitions and metrics (structural, configuration, coupling, runtime/timing,
interface surface). See
[Measuring Linux Kernel Complexity](./minimal-linux/KernelComplexity.md) for build-time and
runtime approaches and how to scope them to the certification objective.

## Further reduction opportunities

With no init system and no general user space, the libc linked by the
application is the dominant user-space footprint — so the libc choice matters
more here than in a normal distro:

- **glibc** — broadest compatibility, but drags in desktop-oriented assumptions
  we've otherwise removed by dropping init and the general user space.
- **musl / non-glibc** — smaller and simpler to reason about, and a better fit
  for a PID 1 application that only needs a narrow slice of libc.
  Higher-assurance targets benefit from the reduced surface.

Because the baseline already assumes only the libc features the application
calls (reduced POSIX surface), a cross-toolchain build against musl is a natural
next reduction step — fewer library entry points also means fewer kernel
features pulled in.

The same "measure the footprint" discipline from the kernel applies to user
space. To make the point concrete, compare our basic example — a single
statically linked PID 1 init — against progressively fuller user spaces: a
minimal one built on BusyBox, and a conventional one built on systemd. BusyBox
is far smaller than a full distro user space, yet still bundles hundreds of
applets (shell, coreutils, init, etc.); systemd adds a full init and service
manager on top. None of that is needed by our no-init baseline. Counting
user-space SLOC alongside the kernel SLOC shows how much verification surface
the direct-init approach avoids.

We count with the same [`sloc-counter`](./minimal-linux/sloc-counter) script, using its
`files` mode for the single-file init and `tree` mode for a whole source tree
(both wrap [`cloc`](https://github.com/AlDanial/cloc)):

```sh
docs/minimal-linux/sloc-counter files ainit.c        # -> 10
docs/minimal-linux/sloc-counter tree  busybox-1.36.1  # -> 189050
docs/minimal-linux/sloc-counter tree  systemd-257     # -> 684593
```

The figures below are full-source-tree C/C++ counts:

| User space    | Version | SLOC (C + headers) | Notes                                                                                 |
| ------------- | ------- | ------------------ | ------------------------------------------------------------------------------------- |
| Basic example | —       | 10                 | single static init (`ainit.c`); only the libc paths the app calls                     |
| BusyBox       | 1.36.1  | 189,050            | hundreds of applets (shell, coreutils, init), most unused by the workload             |
| systemd       | 257     | 684,593            | full init system: units, journald, dependency graph — far more than a PID 1 app needs |

These are whole-tree numbers; a real build compiles only a configured subset, so
the shipped footprint is smaller. For an apples-to-apples "what actually ships"
figure, count only the compiled sources — the Unikraft script does this by
parsing the build log / `make -n` output rather than the whole tree, and
optionally runs `gcc -E` first to drop `#ifdef`'d-out code. Whichever method you
pick, apply it identically to every row and record the delta so the reduction
from "just the application" vs "a general-purpose user space" is explicit.

## Hello cFS

The same method applies to a real flight workload. Applying kernel minimization
to the NASA Core Flight System (cFS) is covered in its own document:
[Hello cFS](./minimal-linux/KernelMinimizationCFS.md).

## References

### This walkthrough

- [`sloc-counter`](./minimal-linux/sloc-counter) — the cloc-based SLOC script used for the
  Metrics tables (kernel/tree/files modes).
- [Hello World init](./minimal-linux/HelloWorldInit.md) — build the minimal static PID 1 init
  and pack it into an initramfs for QEMU (the workload booted in this
  walkthrough).
- [Hello cFS](./minimal-linux/KernelMinimizationCFS.md) — the same method applied to the NASA
  Core Flight System.
- [Certification progression](./minimal-linux/CertificationProgression.md) — separate track on
  moving a minimized kernel toward higher assurance levels.
- [Measuring Linux Kernel Complexity](./minimal-linux/KernelComplexity.md) — build-time and
  runtime complexity metrics (distinct from size).
- [Minimal Kernel Config Analysis](./minimal-linux/KernelConfigAnalysis.md) — comparison
  against published minimal configs (Boeing, LFSCS) and prior measurements.
- [Nix-based kernel configuration walk-through](../demos/AvioNix-demo/NixBasedKernelConfig.md)
  — higher-level, reproducible config approach.
- [`cloc`](https://github.com/AlDanial/cloc) — SLOC counter used for the Metrics
  tables, and Unikraft's build-time SLOC reporting
  ([unikraft/unikraft#1880](https://github.com/unikraft/unikraft/pull/1880))
  that counts only the compiled sources.

### Prior research

ELISA:

- [Minimum Linux Requirements for Executing a Minimal Application](https://github.com/elisa-tech/wg-lfscs/blob/main/lfscs-meetings/resources/Minimum_Linux_Requirements_for_Executing_a_Minimal_Application.md)
  — LFSCS study that derived a minimal kernel config by tracing a minimal
  program (the same trace-to-config method as
  [Evaluating an executable](#evaluating-an-executable)); its config is measured
  as the "ELISA LFSCS minimal" row in
  [Minimal Kernel Config Analysis](./minimal-linux/KernelConfigAnalysis.md).
- LFSCS [`min_prog_trace`](https://github.com/elisa-tech/wg-lfscs/tree/main/min_prog_trace)
  — minimal program used in the study / related tracing work.
- [kconfig-safety-check](https://github.com/elisa-tech/kconfig-safety-check)
  — ELISA safety-configuration tool (more cyber/quality focused than DO-178C,
  but a useful reference).
- [Stack memory management by the Linux kernel](https://github.com/elisa-tech/wg-lfscs/blob/main/Stack%20memory%20management%20by%20Linux%20kernel.md)
  and [kernel configurations for stack memory protection](https://github.com/elisa-tech/wg-lfscs/blob/main/kernel-configurations-for-stack-memory-protection.md).

Boeing:

- Original 5.x minimal configuration —
  [Boeing/linux@f5d4b42](https://github.com/Boeing/linux/commit/f5d4b42051b045fb667d69eeb0272a89dde6ba20)
  (see the commit description for capabilities and limitations).
- 6.x minimal configuration (reference only, not finished) —
  [linux-6.14-not-finished.txt](https://github.com/user-attachments/files/25343272/linux-6.14-not-finished.txt).

Other:

- [under-view/tiny-linux-kconfigs](https://github.com/under-view/tiny-linux-kconfigs/tree/master/linux-6.12)
  — community minimal kconfigs (an alternative bottom-up starting point).
- [Minimal buildroot aarch64-virt config](https://github.com/afbjorklund/minimal-buildroot/blob/main/board/qemu/aarch64-virt/linux.config)
  — less minimal (enables ext4 + ATA/SCSI); listed for comparison.
- [Kernel config parser (rokc)](https://git.afnix.fr/rokc/rokc).
- [Nix kernel config expression](https://github.com/elisa-tech/wg-aerospace/blob/c66da7a41bea478b34aef96db5a34d3e40b8381a/demos/AvioNix-demo/pkgs/minimal-linux-kernel.nix#L77-L196).
- ["A Study of Linux Kernel Configuration" (arXiv:2206.00789)](https://arxiv.org/pdf/2206.00789)
  — background on the Kconfig variability space.

### Workload / subsystem tracing

- Upstream [workload-tracing admin guide](https://docs.kernel.org/admin-guide/workload-tracing.html).
- ELISA [Discovering Linux kernel subsystems used by a workload](https://github.com/elisa-tech/ELISA-White-Papers/blob/master/Processes/Discovering_Linux_kernel_subsystems_used_by_a_workload.md)
  and the [OpenAPS subsystem-discovery blog](https://elisa.tech/blog/2022/02/02/discovery-linux-kernel-subsystems-used-by-openaps/).
