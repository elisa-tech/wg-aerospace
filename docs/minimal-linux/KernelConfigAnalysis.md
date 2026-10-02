<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Minimal Kernel Config Analysis

A companion to the [Kernel Minimization](../KernelMinimization.md) guide. The
guide is the clean, iterate-through-it walkthrough; this page collects the
deeper comparison against published minimal configs and prior measurements, so
the guide stays focused.

All numbers here were produced with the same
[`sloc-counter`](./sloc-counter) script (see
[Kernel Minimization → Counting kernel SLOC](../KernelMinimization.md#counting-kernel-sloc)),
measured on LTS v6.18.52, arm64, built with `CONFIG_DEBUG_INFO`. The DWARF /
elf-to-sloc count (source lines that actually emitted object code) is the
headline; the `cloc` count (every compiled source line) is a secondary upper
bound.

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
[`min_prog_trace/kernel.config`](https://github.com/elisa-tech/wg-lfscs/tree/main/min_prog_trace).

## How close are we to the #139 measurements?

The **method** reproduces faithfully: on the same tiny + serial v6.18 `vmlinux`,
`sloc-counter kernel` (cloc) reports 342,997 and `sloc-counter dwarf`
(elf-to-sloc) reports 171,739 — a steady **2.0x** ratio, exactly the
"whole-compiled-file vs object-code-traceable" difference the ELISA researchers
described. Our DWARF numbers are therefore directly comparable in _kind_ to the
elf-to-sloc figures published in #139.

The **absolute numbers are higher than #139's**, and the dominant reason is
**kernel version**, not method: #139 measured on 5.x (Boeing) and 6.6.39 (LFSCS)
and `tinyconfig` on v6.12 (80,936), whereas we measure on v6.18.52, and the
kernel grows materially between releases. A secondary factor is that mapping an
older `defconfig`/`.config` onto v6.18 with `olddefconfig` pulls in newer
defaults. To reproduce #139's numbers exactly you would build at their kernel
versions; to track _our_ baseline going forward, use the progression table in
the guide. This analysis supersedes the ad-hoc measurements collected in
[issue #139](https://github.com/elisa-tech/wg-aerospace/issues/139).

## Notes on specific configs

- Some of the Boeing configuration work looked at angles of removing complexity
  for certification; this analysis is not at that level — it compares size/SLOC,
  not the certification rationale behind individual options.
- The [minimal-buildroot aarch64-virt config](https://github.com/afbjorklund/minimal-buildroot/blob/main/board/qemu/aarch64-virt/linux.config)
  is less minimal than it appears — it enables a full ext4 filesystem and the
  ATA/SCSI subsystems — so it is a weaker starting point than `tinyconfig` or the
  Boeing/LFSCS configs.
