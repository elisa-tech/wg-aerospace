# SPDX-FileCopyrightText: 2024-2025 wucke13
#
# SPDX-License-Identifier: Apache-2.0

{ lib, ... }:

{

  imports = [ ./minimal.nix ];

  config = {
    nixpkgs.buildPlatform = lib.mkForce "x86_64-linux";
    nixpkgs.hostPlatform = lib.mkForce "armv7l-linux";
  };
}
