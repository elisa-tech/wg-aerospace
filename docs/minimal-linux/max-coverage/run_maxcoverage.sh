#!/usr/bin/env bash
# SPDX-License-Identifier: CC-BY-SA-4.0
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
WORK_DIR="$REPO_ROOT/tmp/run_maxcoverage_$$"
LINUX_SRC="$REPO_ROOT/linux"

echo "=== Max Coverage Walkthrough Verification ==="
echo "Workspace: $WORK_DIR"

if [ ! -d "$LINUX_SRC" ]; then
	echo "ERROR: Linux kernel tree not found at $LINUX_SRC"
	exit 1
fi

mkdir -p "$WORK_DIR/linux"
git -C "$LINUX_SRC" archive --format=tar HEAD | tar -x -C "$WORK_DIR/linux"
cd "$WORK_DIR/linux"

export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-

echo "[1/5] Building GCOV tinyconfig kernel..."
make tinyconfig >/dev/null 2>&1
./scripts/config \
	-e PRINTK -e TTY -e SERIAL_AMBA_PL011 -e SERIAL_AMBA_PL011_CONSOLE \
	-e BINFMT_ELF -e BLK_DEV_INITRD -d MODULES \
	-e DEBUG_FS -e SYSFS -e PROC_FS -e DEVTMPFS -e DEVTMPFS_MOUNT \
	-e GCOV_KERNEL -e GCOV_PROFILE_ALL \
	-e FUTEX -e POSIX_TIMERS -e SHMEM -e MEMFD_CREATE -e ADVISE_SYSCALLS \
	-e RUNTIME_TESTING_MENU \
	-e KUNIT \
	-e DEBUG_LOCKING_API_SELFTESTS \
	-e STATIC_KEYS_SELFTEST \
	-e ATOMIC64_SELFTEST \
	-e TEST_BITMAP \
	-e TEST_SORT \
	-e TEST_LIST_SORT \
	-e TEST_HEXDUMP \
	-e TEST_KSTRTOX \
	-e TEST_XARRAY \
	-e TEST_MAPLE_TREE \
	-e TEST_RHASHTABLE \
	-e TEST_IDA \
	-e TEST_BITOPS \
	-d DEBUG_INFO_NONE -e DEBUG_KERNEL -e DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT \
	-d DEBUG_INFO_BTF -d DEBUG_INFO_SPLIT
make olddefconfig >/dev/null 2>&1
make clean >/dev/null 2>&1
make -j"$(nproc)" Image >/dev/null 2>&1

echo "[2/5] Assembling Alpine minirootfs & stress-ng..."
cd "$WORK_DIR"
wget -q https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/aarch64/alpine-minirootfs-3.20.3-aarch64.tar.gz
mkdir -p rootfs-alpine
tar -xzf alpine-minirootfs-3.20.3-aarch64.tar.gz -C rootfs-alpine
mkdir -p rootfs-alpine/proc rootfs-alpine/sys rootfs-alpine/dev \
	rootfs-alpine/tmp rootfs-alpine/sys/kernel/debug

wget -q https://dl-cdn.alpinelinux.org/alpine/v3.20/community/aarch64/stress-ng-0.17.08-r0.apk
tar -xzf stress-ng-0.17.08-r0.apk -C rootfs-alpine

for dep in \
	main/aarch64/libbsd-0.12.2-r0.apk \
	main/aarch64/libmd-1.1.0-r0.apk \
	main/aarch64/liblksctp-1.0.19-r5.apk \
	community/aarch64/judy-1.0.5-r1.apk; do
	wget -q "https://dl-cdn.alpinelinux.org/alpine/v3.20/$dep"
	tar -xzf "$(basename "$dep")" -C rootfs-alpine
done

echo "[3/5] Building Syzkaller reproducer & /init launcher..."
if [ ! -d "$WORK_DIR/syzkaller" ]; then
	git clone https://github.com/google/syzkaller "$WORK_DIR/syzkaller"
fi
(cd "$WORK_DIR/syzkaller" && git checkout 432c00775d20929a96fd4987f9ef01a50e6fd277 && make prog2c) >/dev/null 2>&1

"$WORK_DIR/syzkaller/bin/syz-prog2c" -os linux -arch arm64 -trace -prog "$REPO_ROOT/docs/minimal-linux/max-coverage/corpus.syz" >syz-repro.c
mkdir -p rootfs-alpine/opt/syzkaller
aarch64-linux-gnu-gcc -static -O2 -o rootfs-alpine/opt/syzkaller/syz-repro syz-repro.c

aarch64-linux-gnu-gcc -static -O2 -o rootfs-alpine/init "$REPO_ROOT/docs/minimal-linux/max-coverage/init-maxcoverage.c"
(cd rootfs-alpine && find . | cpio -o -H newc 2>/dev/null) | gzip >initramfs-alpine.cpio.gz

echo "[4/5] Running QEMU multi-stage execution..."
set +e
timeout 12m qemu-system-aarch64 -machine virt -cpu cortex-a57 -m 1024M -nographic \
	-kernel linux/arch/arm64/boot/Image -initrd initramfs-alpine.cpio.gz \
	-append 'console=ttyAMA0 nokaslr' >qemu-gcov.log 2>&1 || true
set -e

echo "[5/5] Reconstructing checkpoints & computing differential coverage..."
sed -n '/===GCOV_STAGE0_BOOT_START===/,/===GCOV_STAGE0_BOOT_END===/p' qemu-gcov.log | grep -v '===' | tr -d '\r' | base64 -d >gcda-stage0-boot.tar.gz
sed -n '/===GCOV_STAGE1_PROCSYS_START===/,/===GCOV_STAGE1_PROCSYS_END===/p' qemu-gcov.log | grep -v '===' | tr -d '\r' | base64 -d >gcda-stage1-procsys.tar.gz
sed -n '/===GCOV_STAGE2_STRESSNG_START===/,/===GCOV_STAGE2_STRESSNG_END===/p' qemu-gcov.log | grep -v '===' | tr -d '\r' | base64 -d >gcda-stage2-stressng.tar.gz
sed -n '/===GCOV_STAGE3_SYZKALLER_START===/,/===GCOV_STAGE3_SYZKALLER_END===/p' qemu-gcov.log | grep -v '===' | tr -d '\r' | base64 -d >gcda-stage3-syzkaller.tar.gz

cd linux
python3 "$REPO_ROOT/docs/minimal-linux/max-coverage/reconstruct_stage.py" ../gcda-stage0-boot.tar.gz stage0_boot
python3 "$REPO_ROOT/docs/minimal-linux/max-coverage/reconstruct_stage.py" ../gcda-stage1-procsys.tar.gz stage1_procsys
python3 "$REPO_ROOT/docs/minimal-linux/max-coverage/reconstruct_stage.py" ../gcda-stage2-stressng.tar.gz stage2_stressng
python3 "$REPO_ROOT/docs/minimal-linux/max-coverage/reconstruct_stage.py" ../gcda-stage3-syzkaller.tar.gz stage3_syzkaller

python3 "$REPO_ROOT/docs/minimal-linux/max-coverage/diff_gcov.py"

echo "=== Max Coverage Verification Complete ==="
cd "$REPO_ROOT"
rm -rf "$WORK_DIR"
