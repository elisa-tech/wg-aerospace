# SPDX-FileCopyrightText: 2024-2026 wucke13
#
# SPDX-License-Identifier: Apache-2.0

{
  lib,
  modulesPath,
  pkgs,
  flakeRoot,
  ...
}:

{
  imports = [
    (modulesPath + "/profiles/perlless.nix")
  ];

  config = {
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    boot.kernelPackages = pkgs.linuxPackagesFor (
      pkgs.callPackage (flakeRoot + "/pkgs/minimal-linux-kernel.nix") { }
    );

    boot.kernelPatches = [
      {
        name = "enable-cFS-dependencies";
        patch = null;
        structuredExtraConfig = {
          # These are needed for cFS
          POSIX_MQUEUE = lib.kernel.yes;
          SYSVIPC = lib.kernel.yes;
        };
      }
    ];

    zorn.boot.kernelDebugging.enable = true; # enable gdb launcher script generation
    zorn.boot.kernelDebugging.enableKernelDebugConfigOptions = true; # compile kernel with debugging aids
    zorn.boot.standaloneInitramdisk.enable = true; # enable creation of a standalone initramdisk
    # zorn.boot.standaloneInitramdisk.useTailoredQemu = false; # use this to avoid compiling QEMU
    zorn.debloat.enable = true;

    # avoid any software installed by default
    # TODO filter this via nixos/modules/config/system-path.nix
    # See https://github.com/NixOS/nixpkgs/issues/32405 for further info
    environment.systemPackages = lib.mkForce [
      # essentials
      pkgs.bashInteractive # required, it is the default login shell and in the system closure anyhow
      pkgs.coreutils
      pkgs.systemd

      # goodies already included in the system closure
      pkgs.acl
      pkgs.attr
      pkgs.bzip2
      pkgs.cpio
      pkgs.dbus
      pkgs.dosfstools
      pkgs.findutils
      pkgs.fuse
      pkgs.getent
      pkgs.gnugrep
      pkgs.gnused
      pkgs.gzip
      pkgs.kexec-tools
      pkgs.kmod
      pkgs.libcap
      pkgs.ncurses
      pkgs.nettools
      pkgs.shadow
      pkgs.su
      pkgs.util-linux
      pkgs.xz
      pkgs.zstd

      # debugging aids
      pkgs.gdb
      # pkgs.iproute2
      # pkgs.netcat
      # pkgs.socat
      # pkgs.strace

      # ELISA demo software
      pkgs.elisa-demo-python-light

      # add source to rootfs
      (pkgs.writeShellApplication {
        # break exit
        # up
        name = "debug-cfs";
        text = ''
          set -x
          CPU="''${1:-cpu1}"

          pushd -- "${pkgs.enableDebugging pkgs.elisa-demo-cfs}/exe/$CPU"
          gdb --eval-command='set substitute-path /build/src/cfs ${pkgs.srcOnly pkgs.elisa-demo-cfs}' \
            "core-$CPU"
        '';
      })

    ];

    # use this to add packages to the early boot stage
    boot.initrd.systemd.initrdBin = [ ];

    # setup users
    users.mutableUsers = false;

    # NOTE reconsider these choices for production use!
    # `users.users.<name>.hashedPassword` can be used to declare a password without leaking it
    boot.initrd.systemd.emergencyAccess = true;
    services.openssh.settings.PermitRootLogin = "yes";
    users.users.root.initialPassword = "root";

    # add our applications
    systemd.services.elisa-demo-cfs =
      let
        cfsPkg = pkgs.enableDebugging pkgs.elisa-demo-cfs;
      in
      {
        wantedBy = [ "multi-user.target" ];
        serviceConfig.ExecStart = cfsPkg + "/exe/cpu1/core-cpu1";
        serviceConfig.WorkingDirectory = cfsPkg + "/exe/cpu1/";
      };
  };
}
