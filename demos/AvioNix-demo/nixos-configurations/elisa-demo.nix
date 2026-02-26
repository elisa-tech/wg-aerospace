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
      # pkgs.iproute2
      # pkgs.netcat
      # pkgs.socat
      # pkgs.strace

      # ELISA demo software
      pkgs.elisa-demo-python-light
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
    systemd.sockets.elisa-demo-python-light = {
      socketConfig.ListenFIFO = "%t/%N-input.fifo";
    };
    systemd.services.elisa-demo-python-light = {
      wantedBy = [ "multi-user.target" ];
      requires = [ "%N.socket" ];
      serviceConfig.ExecStart = lib.meta.getExe' pkgs.elisa-demo-python-light "lightServer";
      serviceConfig.Restart = "always";
      # The lightServer requires stdin to not immediately return EOF, otherwise it crashes. Hence
      # we allocate a FIFO for it. This allows allows sending REPL like commands to the light server
      # despite it being a properly running service.
      serviceConfig.StandardInput = "socket";
      serviceConfig.StandardOutput = "journal";
      serviceConfig.StandardError = "journal";
    };

    systemd.services.elisa-demo-copilot-light = {
      wantedBy = [ "multi-user.target" ];
      # The copilot monitor doesn't actually interface with the syslog(2) kernel API, but instead
      # just reads a file. To make it consume the relevant log, we pipe `journalctl` with an
      # appropriate output format to its stdin and pass /dev/stdin as the syslog file.
      serviceConfig.ExecStart = "/bin/sh -c 'journalctl --follow --output=short-monotonic | ${lib.meta.getExe' pkgs.elisa-demo-copilot-light "main_syslog_time"} /dev/stdin'";
      serviceConfig.Restart = "always";
    };

    systemd.services.elisa-demo-python-switch = {
      wantedBy = [ "multi-user.target" ];
      after = [ "elisa-demo-python-light.service" ];
      serviceConfig.ExecStart = lib.meta.getExe' pkgs.elisa-demo-python-light "switch";
      serviceConfig.Restart = "always";
    };
  };
}
