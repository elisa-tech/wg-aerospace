# SPDX-FileCopyrightText: 2026 wucke13
#
# SPDX-License-Identifier: Apache-2.0

{
  lib,
  stdenv,
  pkgsBuildBuild,
  fetchFromGitLab,
  cmake,
  doxygen,
  graphviz,
  pkg-config,
  qt6,
  boost,
  spdlog,
  libxmlxx5,

  enableGui ? true,
}:

let

  fetchFromGitLabDefault = {
    domain = "git.thomas-vogt.de";
    owner = "thomas-vogt";
  };

  repos = [
    {
      repo = "arinc_615a";
      rev = "1c6ad761872ef09eb822b1c84a3850b8ba26df9f";
      hash = "sha256-mIm+zO/bt22jBdaq8E9VldMW+ZfQmURt+j5fvS8Urqs=";
    }
    {
      repo = "arinc_645";
      rev = "44574e567a8e8f11901a916d0e9709dbad03799b";
      hash = "sha256-uMkBG/XQxSym501rtOLNP1tGiDzlH0gyvr5Ny+ubnO4=";
    }
    {
      repo = "arinc_665";
      rev = "37dbbbc6be20eea571342ae1fbb4d9a2c2f5ab79";
      hash = "sha256-a/lsemShAb4Zx4XWTNyupO33JMQYbL3k4JCmJjytPYo=";
    }
    {
      repo = "commands";
      rev = "d5a47ba8f62c371f014a1fdd6ac2de57880f09e5";
      hash = "sha256-w/11EJZrQtehkD8AyFJOT2Bt3JeLZMECgS4WvD+F0Ck=";
    }
    {
      repo = "helper";
      rev = "ab8a4b2d15cff3e8ad12be597bb30d47e4b788b4";
      hash = "sha256-jIdhXRMyhPxlOfQX2yuleRsUl78qQUW5vZDlyjkqKBo=";
    }
    {
      repo = "qt_icon_resources";
      rev = "fc97402abcd911fed3917e2576ecfa7cb262a738";
      hash = "sha256-xxV01Uuy9FBI99dHh+fPRGzJEkLRZKpesnjw1wsH2N4=";
    }
    {
      repo = "tftp";
      rev = "fb32586d7bb55df7f525f734a07646a31699a9a2";
      hash = "sha256-cGD4VQS+wSiaBzCPkalEe0FDMPy0vPNPJQ+LcGmzCHw=";
    }
  ];

  reposFetched = lib.attrsets.genAttrs' repos (
    { repo, ... }@x:
    {
      name = repo;
      value = fetchFromGitLab (fetchFromGitLabDefault // { name = repo; } // x);
    }
  );

  getHashes = pkgsBuildBuild.writeShellApplication {
    name = "get-hashes";
    text = lib.strings.concatStrings (
      lib.lists.map (
        { url, repo, ... }:
        ''
          hash=$(nix-prefetch-url --type sha256 --unpack -- "${url}")
          echo -e '\nrepo:' ${lib.strings.escapeShellArg repo}
          nix hash to-sri --type sha256 -- "$hash"
        ''
      ) (lib.attrsets.attrValues reposFetched)
    );
  };

in
stdenv.mkDerivation {
  name = "ARINC-615A-tool-suite";

  srcs = lib.attrsets.attrValues reposFetched;
  sourceRoot = "arinc_615a";

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    pkg-config
  ]
  ++ lib.lists.optional enableGui qt6.wrapQtAppsHook;

  buildInputs = [
    boost
    libxmlxx5
    spdlog
  ]
  ++ lib.lists.optionals enableGui [
    qt6.qtbase
    qt6.qtsvg
  ];

  prePatch = ''
    chmod --recursive u+w -- ..

    for repo in ../*
    do
      if [[ "$repo" -ef "$PWD" ]]
      then
        continue
      fi
      mv -- "$repo" ./
    done

    shopt -s globstar
    sed --regexp-extended \
      's/^cmake_minimum_required\((\s?VERSION +[0-9.]+\s?)\)/cmake_minimum_required( VERSION ${cmake.version} )/' \
      --in-place ../**/{CMakeLists.txt,*.cmake}
    shopt -u globstar
  '';

  passthru = {
    inherit getHashes;
  };

  meta = {
    description = "ARINC 615A Tool Suite";
    longDescription = ''
      This project provides libraries and application implementing the ARINC 615A Data Loading
      Protocol.
    '';
    homepage = "https://git.thomas-vogt.de/thomas-vogt/arinc_615a";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ wucke13 ];
    platforms = lib.platforms.all;
  };
}
