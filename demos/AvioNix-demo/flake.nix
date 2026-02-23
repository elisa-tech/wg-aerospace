# SPDX-FileCopyrightText: 2024-2026 wucke13
#
# SPDX-License-Identifier: Apache-2.0

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
    minimal-nixos.inputs.flake-utils.follows = "flake-utils";
    minimal-nixos.inputs.nixpkgs.follows = "nixpkgs";
    minimal-nixos.inputs.treefmt-nix.follows = "treefmt-nix";
    minimal-nixos.url = "github:wucke13/minimal-nixos";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
      ...
    }@inputs:
    let
      lib = import (inputs.minimal-nixos + "/lib.nix") nixpkgs.lib;
    in
    {
      overlays.default = import ./overlay.nix;

      # NixOS Configurations
      nixosConfigurations = (
        lib.attrsets.mapAttrs (
          name: nixFile:
          nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs;
              flakeRoot = ./.;
            };
            modules = [
              inputs.minimal-nixos.nixosModules.default
              nixFile
              {
                nixpkgs.overlays = [
                  inputs.minimal-nixos.overlays.default
                  self.overlays.default
                ];
                system.name = lib.mkDefault name;
              }
            ];
          }
        ) (lib.zornlib.nixFilesToAttrset ./nixos-configurations)
      );
    }
    // (inputs.flake-utils.lib.eachSystem [ "aarch64-linux" "x86_64-linux" ] (
      system:
      let
        # nixpkgs instance for the current sytem with our overlay applied
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            inputs.minimal-nixos.overlays.default
            self.overlays.default
          ];
        };

        treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
      in
      {
        # generate local packages + goodies
        packages = pkgs.zornpkgs // pkgs.elisapkgs;

        # for `nix fmt`
        formatter = treefmtEval.config.build.wrapper;

        # for `nix flake check`
        checks = {
          formatting = treefmtEval.config.build.check self;
        };
      }
    ));
}
