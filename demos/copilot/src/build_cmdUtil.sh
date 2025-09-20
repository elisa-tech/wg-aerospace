#!/bin/bash

set -e

BASE_DIR="/demo/elisa_emulation"
CMDUTIL_DIR="$BASE_DIR/cFS/tools/cFS-GroundSystem/Subsystems/cmdUtil"
EXTRACTED_CPIO_DIR="$BASE_DIR/extracted_cpio"
DEST_DIR="$EXTRACTED_CPIO_DIR/usr/cfs_build/arm-linux-gnu/default_cpu1/cpu1"

echo "Building cmdUtil..."

# 1. Overwrite the Makefile with the required content
cat > "$CMDUTIL_DIR/Makefile" << 'EOF'
# Set the full path to your cross-compiler
CROSS_COMPILER := /demo/elisa_emulation/aarch64-buildroot-linux-musl_sdk-buildroot/bin/aarch64-linux-gcc

all:
	$(CROSS_COMPILER) -o cmdUtil SendUdp.c cmdUtil.c

debug:
	$(CROSS_COMPILER) -o cmdUtil -DDEBUG -g SendUdp.c cmdUtil.c

thirtytwo:
	$(CROSS_COMPILER) -o cmdUtil -DDEBUG -g -m32 SendUdp.c cmdUtil.c
EOF

# 2. Build cmdUtil
cd "$CMDUTIL_DIR"
make

# 3. Copy the built cmdUtil binary to the extracted rootfs
echo "Copying cmdUtil to rootfs..."
sudo cp cmdUtil "$DEST_DIR/"

echo "cmdUtil build and copy completed."
