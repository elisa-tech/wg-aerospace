# SPDX-FileCopyrightText: 2026 wucke13
#
# SPDX-License-Identifier: Apache-2.0

{ stdenv, pkgsBuildBuild }:

stdenv.mkDerivation {
  name = "copilot-monitor";

  src = ../../copilot/src/monitors;

  nativeBuildInputs = [
    (pkgsBuildBuild.haskellPackages.ghcWithPackages (
      ps: with ps; [
        copilot
        copilot-c99
        copilot-language
      ]
    ))
  ];

  /*
    TODO

    In theory, there would be a possibility to patch all the deployment/docker/cross-compilation
    stuff out of the Makefile and to use it for actual compilation, i.e. via an `awk` script akin
    the following. However, at the current extent of complication, its just simpler to reproduce the
    three compiler invocations actually needed.
  */

  #postPatch = ''
  #  mv -- Makefile Makefile.old
  #  awk \
  #    '$1 ~ /\w+PREFIX\w*$/ && ":=" == $2 {print $1, " ?= \"\"" ; next} {print}' \
  #    Makefile.old > Makefile
  #  cat Makefile
  #'';

  # Generate the C-code using Copilot
  configurePhase = ''
    runHook preConfigure

    for FILE in Main.hs MainSyslogClock.hs
    do
      runghc -- "$FILE"
    done

    runHook postConfigure
  '';

  # Compile the C code into executables
  buildPhase = ''
    runHook preBuild

    $CC -DLOG_PATH=\"log_file\" -DNOTAIL main_syslog.c elisa-v2.c -o main_syslog_local
    $CC -DLOG_PATH=\"syslog_file\" -DCLOSE_AT_END -DNOTAIL main_syslog_time.c elisa-time.c -o main_syslog_test
    $CC -DLOG_PATH=\"syslog_file\" main_syslog_time.c elisa-time.c -o main_syslog_time
    $CC main_syslog.c elisa-v2.c -o main_syslog

    runHook postBuild
  '';

  # Deploy the executables in the $out/bin directory
  installPhase = ''
    runHook preInstall

    install -D --mode 555 --target-directory "$out/bin/" \
      main_syslog{,_local,_test,_time}

    runHook postInstall
  '';
}
