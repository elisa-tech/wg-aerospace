# SPDX-FileCopyrightText: 2025-2026 wucke13
#
# SPDX-License-Identifier: Apache-2.0
{ pkgsCross }:

pkgsCross.aarch64-multiplatform.callPackage (
  {
    lib,
    fetchFromGitHub,
    stdenv,
    buildLinux,
    pkgsCross,
    ...
  }@args:

  let
    src = fetchFromGitHub {
      owner = "Boeing";
      repo = "linux";
      rev = "f5d4b42051b045fb667d69eeb0272a89dde6ba20";
      hash = "sha256-J+05JVap98M6uGNYooJR26Ab+xHvgCf8nSOcHVEJYBM=";
    };
    version = "5.15.91"; # the commit message wrongfully claims 5.15.124

    # Make this derivation behave like if it was just a call to `buildLinux { ... }`, by passing
    # through any arguments to it (like `features`, `randomstructSeed` or `kernelPatches` for example)
    passthroughArgs =
      removeAttrs args [
        "buildLinux"
        "baseKernel"
        "linux_latest"
        "kernelSrc"
        "kernelVersion"
      ]
      // {
        /*
          `pkgs/os-specific/linux/kernel/generic.nix` unconditionally adds defaults from
          `lib/systems/platforms.nix`, in particular `stdenv.hostPlatform.linux-kernel.extraConfig`,
          to `extraConfig`. That is particularly bad, as there is no easy way to get rid of it.

          Upstream PR: https://github.com/NixOS/nixpkgs/pull/413059
        */
        stdenv =
          let
            removeByPath =
              pathList: set:
              lib.updateManyAttrsByPath [
                {
                  path = lib.init pathList;
                  update = old: lib.filterAttrs (n: v: n != (lib.last pathList)) old;
                }
              ] set;
          in
          removeByPath [ "hostPlatform" "linux-kernel" "extraConfig" ] stdenv;
      };

    # arguments to the `buildlinux` function defined in `pkgs/os-specific/linux/kernel/generic.nix`
    buildLinuxArgs = with (lib.kernel.whenHelpers version); {
      inherit src version;
      autoModules = false;
      kernelPreferBuiltin = true;
      enableCommonConfig = false; # only use our structuredExtraConfig
      defconfig = "minimal_defconfig";
      structuredExtraConfig = with lib.kernel; {
        DEBUG_INFO = yes; # otherwise the elf-to-sloc tool won't work
        MODULES = yes; # TODO remove this
      };
      ignoreConfigErrors = false;
    };
  in
  # Pinpointing to aarch64 because that is the only arch for which the boeing `minimal_defconfig` exists
  buildLinux (buildLinuxArgs // passthroughArgs)
) { }
