<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Minimal Kernel Config Analysis

A companion to the draft
[kernel-minimization guide](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html)
and this repo's [aerospace framing](../SoftwareMinimization.md). The draft
guide is the clean, iterate-through-it walkthrough; this page collects the
deeper comparison against published minimal configs and prior measurements, so
the guide stays focused.

The following figures are retained from earlier LTS v6.18.52 arm64 notes,
not revalidated with the current `scripts/kernel-sloc`. DWARF estimates and
compiled-file counts have different scope; the latter includes inactive
branches but omits included headers, so it is not a strict upper bound. See
the draft guide's "Counting kernel SLOC" section for the current method.

## Reference configs

Published minimal configs, each mapped onto the v6.18 tree with
`make olddefconfig` and measured the same way:

| Reference config               | DWARF SLOC | cloc SLOC | Image (raw) | Boots? | #139 published (elf-to-sloc) |
| ------------------------------ | ---------- | --------- | ----------- | ------ | ---------------------------- |
| Boeing 5.x `minimal_defconfig` | 167,469    | 332,838   | 2.9 MiB     | yes    | 100,058 (on 5.x, aarch64)    |
| ELISA LFSCS minimal            | 210,675    | 399,119   | 4.4 MiB     | no\*   | 139,066 (on 6.6.39, aarch64) |

\* The LFSCS config maps onto v6.18 but does not boot our QEMU `virt` setup
unchanged (the study targeted an x86 build; the config lacks our arm64
`virt`/PL011 console pieces). It is included for the SLOC comparison, not as a
bootable target.

Sources: Boeing arm64 `minimal_defconfig` from
[Boeing/linux@f5d4b42](https://github.com/Boeing/linux/commit/f5d4b42051b045fb667d69eeb0272a89dde6ba20);
ELISA LFSCS minimal from
[`min_prog_trace/kernel.config`](https://github.com/elisa-tech/wg-lfscs/tree/main/min_prog_trace),
produced by the LFSCS ftrace study of a minimal application
([`min_prog_trace/README.md`](https://github.com/elisa-tech/wg-lfscs/blob/main/min_prog_trace/README.md)),
which traces the kernel functions a near-empty C program actually reaches.

## How close are we to the #139 measurements?

The earlier tiny-config notes report 342,997 compiled-file SLOC and 171,739
DWARF SLOC, roughly a 2:1 ratio. This illustrates the difference between the
metrics, not proof that all counting implementations produce equivalent results.

The figures in [issue #139](https://github.com/elisa-tech/wg-aerospace/issues/139)
use different kernel versions and configurations. Kernel version, resolved
defaults, compiler, debug information, and counting-tool revision can all affect
the result. Re-run with matched inputs before attributing a difference to one cause.
For current, fully reproducible measurements and methodology on the v7.3-rc5 tree,
see [Hello Init (Practice)](./HelloInit.md).

## Historical Progression & User-Space Sizing (v6.18 Notes)

The following figures reflect earlier exploratory notes on LTS v6.18.52 (ARM64), retained
to document historical context and comparison with issue #139:

### Subsystem addition progression (reported LTS v6.18.52, arm64)

| Configuration | DWARF SLOC | Compiled-file SLOC | Image (raw) | Reported boot |
| :--- | :--- | :--- | :--- | :--- |
| `tinyconfig` + boot/serial options | 171,739 | 342,997 | 2.9 MiB | yes |
| + networking | 273,678 | 521,825 | 4.1 MiB | yes |
| + block / EXT4 | 319,767 | 597,973 | 4.6 MiB | yes |
| + PCI / USB | 346,568 | 649,022 | 5.1 MiB | yes |
| `defconfig` (monolithic) | 1,212,643 | 2,748,291 | 47 MiB | yes |

### User-space footprint comparison (glibc static vs full trees)

| User Space Component | Scope | Source SLOC | Static ELF (Stripped) |
| :--- | :--- | :--- | :--- |
| Basic PID 1 (`ainit`) | Single application file (excluding libc) | 10 lines | 532,408 B (~520 KB) |
| BusyBox 1.36.1 | Whole C/header source tree | 189,050 lines | ~1.2 MiB |
| systemd 257 | Whole C/header source tree | 684,593 lines | — |

*Note on libc overhead:* In static binaries, linked libc dominates small application
footprints (e.g. glibc adds ~532 KB of baseline code even for a 10-line `hello world`).
Using an alternative C library like musl is a candidate optimization when minimizing
user-space payload size.

## Notes on specific configs

- Some of the Boeing configuration work looked at angles of removing complexity
  for certification; this analysis is not at that level — it compares size/SLOC,
  not the certification rationale behind individual options.
- The [minimal-buildroot aarch64-virt config](https://github.com/afbjorklund/minimal-buildroot/blob/main/board/qemu/aarch64-virt/linux.config)
  is less minimal than it appears — it enables a full ext4 filesystem and the
  ATA/SCSI subsystems — so it is a weaker starting point than `tinyconfig` or the
  Boeing/LFSCS configs.
