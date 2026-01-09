# SPDX-FileCopyrightText: 2024-2025 wucke13
#
# SPDX-License-Identifier: Apache-2.0

{ lib, ... }:

{

  imports = [ ./elisa-demo.nix ];

  config = {
    nixpkgs.buildPlatform = lib.mkForce "aarch64-linux";
    nixpkgs.hostPlatform = lib.mkForce "aarch64-linux";
  };
}
