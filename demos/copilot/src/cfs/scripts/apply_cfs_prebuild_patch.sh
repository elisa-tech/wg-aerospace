#!/bin/bash

set -e

BASE_DIR="/demo/elisa_emulation/cFS"
SDK_DIR="/demo/monitors/aarch64-buildroot-linux-musl_sdk-buildroot"

echo "Starting patch script..."

cd "$BASE_DIR"

# 1. Copy toolchain file
echo "Copying toolchain file..."
cp -a sample_defs/toolchain-arm-cortexa8_neon-linux-gnueabi.cmake sample_defs/toolchain-arm-linux-gnu.cmake

# 2. Patch sample_defs/toolchain-arm-linux-gnu.cmake
echo "Patching sample_defs/toolchain-arm-linux-gnu.cmake..."
sed -i 's|SET(CMAKE_C_COMPILER.*|SET(CMAKE_C_COMPILER                    "'"$SDK_DIR"'/bin/aarch64-linux-gcc")|' sample_defs/toolchain-arm-linux-gnu.cmake
sed -i 's|SET(CMAKE_CXX_COMPILER.*|SET(CMAKE_CXX_COMPILER                  "'"$SDK_DIR"'/bin/aarch64-linux-g++")|' sample_defs/toolchain-arm-linux-gnu.cmake
sed -i 's|SET(CMAKE_FIND_ROOT_PATH.*|SET(CMAKE_FIND_ROOT_PATH                "'"$SDK_DIR"'/aarch64-buildroot-linux-musl/sysroot")|' sample_defs/toolchain-arm-linux-gnu.cmake

# 3. Patch sample_defs/targets.cmake
echo "Patching sample_defs/targets.cmake..."
sed -i 's|SET(cpu1_SYSTEM.*|SET(cpu1_SYSTEM arm-linux-gnu)|' sample_defs/targets.cmake

# 4. Remove line '#include <sys/signal.h>' from os-posix.h
OS_POSIX_H="$BASE_DIR/osal/src/os/posix/inc/os-posix.h"
echo "Removing '#include <sys/signal.h>' from $OS_POSIX_H..."
sed -i '/#include <sys\/signal.h>/d' "$OS_POSIX_H"

# 5. Add 'execinfo' to target_link_libraries in CMakeLists.txt
CMAKELISTS="$BASE_DIR/psp/CMakeLists.txt"
echo "Adding 'execinfo' to target_link_libraries in $CMAKELISTS..."

# Check if execinfo is already present to avoid duplicates
if ! grep -q 'execinfo' "$CMAKELISTS"; then
  # Use awk to insert execinfo before the closing parenthesis of the PRIVATE block
  awk '
  # Flag to track if inside the PRIVATE target_link_libraries block
  /target_link_libraries\(psp-\${CFE_PSP_TARGETNAME} PRIVATE/ {
    print
    in_block=1
    next
  }
  in_block && /^\)/ {
    print "    execinfo"
    print
    in_block=0
    next
  }
  {
    print
  }
' "$CMAKELISTS" > "${CMAKELISTS}.tmp" && mv "${CMAKELISTS}.tmp" "$CMAKELISTS"
else
  echo "'execinfo' already present in target_link_libraries."
fi

echo "Patch script completed."
