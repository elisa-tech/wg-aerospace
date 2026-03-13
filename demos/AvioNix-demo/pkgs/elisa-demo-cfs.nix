# SPDX-FileCopyrightText: 2026 wucke13
#
# SPDX-License-Identifier: Apache-2.0

{
  stdenv,
  fetchFromGitHub,
  cmake,
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

  nativeBuildInputs = [ cmake ];

  env = {
    # TODO remove this hack which convinces CMake to ignore incompatibilities
    CMAKE_POLICY_VERSION_MINIMUM = "3.5";
  };

  dontUnpack = true;
  prePatch = ''
    # merge/copy over the upstream cFS repo into local tree
    cp --recursive --no-target-directory --update=none -- ${cFS} .

    # copy a sample def and makefile
    cp --recursive -- cfe/cmake/sample_defs .
    cp -- cfe/cmake/Makefile.sample Makefile

    # make sure everything is writable
    chmod --recursive -- u+w .
  '';

  dontUseCmakeConfigure = true; # use the Makefile as entry point for configure and build
  enableParallelBuilding = true; # the build is CMake generated, so probably safe to parallelize
  buildFlags = [ "SIMULATION=native" ];
  makeFlags = [ "DESTDIR=${placeholder "out"}" ];
}
