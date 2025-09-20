#!/bin/bash

set -e

BASE_DIR="/demo/elisa_emulation"
CFS_BUILD_DIR="$BASE_DIR/cFS/build-elisa"
EXTRACTED_CPIO_DIR="$BASE_DIR/extracted_cpio"
ROOTFS_CPIO_GZ="$BASE_DIR/rootfs.cpio.gz"

echo "Starting post-build setup..."

# 1. Extract rootfs.cpio.gz into extracted_cpio directory
mkdir -p "$EXTRACTED_CPIO_DIR"
echo "Uncompressing rootfs.cpio.gz..."
sudo gunzip -c "$ROOTFS_CPIO_GZ" > "$BASE_DIR/rootfs.cpio_uncompressed"

echo "Extracting rootfs.cpio_uncompressed into $EXTRACTED_CPIO_DIR..."
sudo cpio -i -R +0:+0 -n -F "$BASE_DIR/rootfs.cpio_uncompressed" --make-directories --preserve-modification-time --no-absolute-filenames --directory="$EXTRACTED_CPIO_DIR"

# 2. Copy cFS build output into extracted_cpio/usr/
echo "Copying cFS build output to extracted_cpio/usr/ ..."
sudo cp -r "$CFS_BUILD_DIR" "$EXTRACTED_CPIO_DIR/usr/"

# 3. Rename build-elisa to cfs_build
echo "Renaming build-elisa to cfs_build..."
sudo mv "$EXTRACTED_CPIO_DIR/usr/build-elisa" "$EXTRACTED_CPIO_DIR/usr/cfs_build"

# 4. Create cf directory
CF_DIR="$EXTRACTED_CPIO_DIR/usr/cfs_build/arm-linux-gnu/default_cpu1/cpu1/cf"
echo "Creating cf directory at $CF_DIR..."
sudo mkdir -p "$CF_DIR"

# 5. Copy and rename startup script
echo "Copying and renaming startup script..."
sudo cp "$BASE_DIR/cFS/sample_defs/cpu1_cfe_es_startup.scr" "$CF_DIR/"
sudo mv "$CF_DIR/cpu1_cfe_es_startup.scr" "$CF_DIR/cfe_es_startup.scr"

# 6. Copy application shared objects
echo "Copying application shared objects..."
APPS=(
  "cfe_assert"
  "ci_lab"
  "to_lab"
  "sample_app"
  "sample_lib"
  "sch_lab"
)

for app in "${APPS[@]}"; do
  sudo cp "$CFS_BUILD_DIR/arm-linux-gnu/default_cpu1/apps/$app/$app.so" "$CF_DIR/"
done

# 7. Copy table files
echo "Copying table files..."
TABLES=(
  "to_lab_sub.tbl"
  "sample_app_tbl.tbl"
  "sch_lab_table.tbl"
)

for tbl in "${TABLES[@]}"; do
  sudo cp "$CFS_BUILD_DIR/tables/staging/cpu1/cf/$tbl" "$CF_DIR/"
done

echo "Post-build setup completed."
