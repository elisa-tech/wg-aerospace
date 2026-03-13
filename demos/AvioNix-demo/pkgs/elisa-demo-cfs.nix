# SPDX-FileCopyrightText: 2026 wucke13
#
# SPDX-License-Identifier: Apache-2.0

{
  stdenv,
  fetchFromGitHub,
  cmake,
  haskellPackages,
}:

let
  cFS = fetchFromGitHub {
    owner = "nasa";
    repo = "cFS";
    rev = "v6.7.0a";
    hash = "sha256-BdCBIsm66Iunf+1XdSUbOLg7Le4elQOjYAxSHifD+t8=";
    fetchSubmodules = true;
  };

in

stdenv.mkDerivation {
  name = "elisa-demo-cfs";

  nativeBuildInputs = [
    cmake
    haskellPackages.ogma-cli
  ];

  env = {
    # TODO remove this hack which convinces CMake to ignore incompatibilities
    CMAKE_POLICY_VERSION_MINIMUM = "3.5";

    # ogma fails to parse UTF-8 files with a rather cryptic error when the local doesn't support UTF-8
    # See https://github.com/nasa/ogma/issues/390 for more info
    LC_ALL = "C.UTF-8";
  };

  src = ../../copilot/src;

  prePatch = ''
    # merge/copy over the upstream cFS repo into local tree
    cd -- cfs
    cp --recursive --no-target-directory --update=none -- ${cFS} .

    # copy a sample def and makefile
    cp --recursive -- cfe/cmake/sample_defs .
    cp -- cfe/cmake/Makefile.sample Makefile

    # make sure everything is writable
    chmod --recursive -- u+wX ..
    BASE_DIR=$(pwd)

    # 3. Patch sample_defs/targets.cmake
    echo "Patching sample_defs/targets.cmake..."
    sed -i 's|SET(cpu1_SYSTEM.*|SET(cpu1_SYSTEM arm-linux-gnu)|' sample_defs/targets.cmake
    sed -i 's|\(SET(cpu1_APPLIST[^)]\+\)|\1 copilot_app lights_app switch_app|' sample_defs/targets.cmake
    sed -i -e '/^!/{i\
    CFE_APP, copilot_app, COPILOT_APP_Main,   COPILOT_APP,  50,   16384, 0x0, 0;\
    CFE_APP, lights_app,  LIGHTS_APP_Main,    LIGHTS_APP,   50,   16384, 0x0, 0;\
    CFE_APP, switch_app,  SWITCH_APP_Main,    SWITCH_APP,   50,   16384, 0x0, 0;
    ;q}' sample_defs/cpu1_cfe_es_startup.scr

    # 5. Add 'execinfo' to target_link_libraries in CMakeLists.txt
    CMAKELISTS="$BASE_DIR/psp/CMakeLists.txt"
    echo "Adding 'execinfo' to target_link_libraries in $CMAKELISTS..."

    # preprocess the copilot stuff
    ogma cfs \
      --input-file elisa_usecase/expressions.json \
      --app-target-dir apps/ \
      --app-template-dir updated_template/ \
      --variable-db elisa_usecase/db.json \
      --input-format elisa_usecase/json-format.cfg \
      --prop-format literal \
      --template-vars elisa_usecase/extra-vars.json
    cp -- ../monitors/Main.hs apps/copilot_app/fsw/src/
    cp -- ../monitors/Auxiliary.hs apps/copilot_app/fsw/src/
  '';

  dontUseCmakeConfigure = true; # use the Makefile as entry point for configure and build
  enableParallelBuilding = true; # the build is CMake generated, so probably safe to parallelize
  buildFlags = [ "SIMULATION=native" ];
  postBuild = ''
    pushd tools/cFS-GroundSystem/Subsystems/cmdUtil
    make
    popd
  '';
  makeFlags = [ "DESTDIR=${placeholder "out"}" ];
}
