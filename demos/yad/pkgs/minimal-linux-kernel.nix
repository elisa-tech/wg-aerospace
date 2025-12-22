# SPDX-FileCopyrightText: 2025 wucke13
#
# SPDX-License-Identifier: Apache-2.0

{
  lib,
  stdenv,
  buildLinux,
  baseKernel ? linux_latest,
  linux_latest ? builtins.throw "`linux_latest` must be passed if `kernelSrc` is not passed!",
  kernelSrc ? null,
  kernelVersion ? null,
  ...
}@args:

assert lib.assertMsg (
  kernelSrc != null -> kernelVersion != null
) "If compiling kernel from scratch given a `kernelSrc`, `version` must be provided as well";

let
  # use `kernel{Src,Version}`, fall back to `baseKernel.{Src,Version}`
  src = args.kernelSrc or baseKernel.src;
  version = args.kernelVersion or baseKernel.version;

  # helper functions for conditional kernel config options
  mkIf = x: if x then lib.kernel.yes else lib.kernel.unset;
  hpl = stdenv.hostPlatform;

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
    defconfig = "tinyconfig";

    /*
      A powerpc build does not automagically set KBUILD_IMAGE, but without it, the install script
      only ever installs vmlinux to $out. When KBUILD_IMAGE is set, the install script works as
      intended.
    */
    extraMakeFlags = lib.lists.optional hpl.isPower "KBUILD_IMAGE=arch/powerpc/boot/${stdenv.hostPlatform.linux-kernel.target}";

    structuredExtraConfig = with lib.kernel; {
      # nixos nags about these
      AUTOFS_FS = yes;
      MODULES = yes;
      CRYPTO_HMAC = yes;
      CRYPTO_SHA256 = yes;
      SECCOMP = yes;

      # essentials
      BINFMT_ELF = yes;
      BINFMT_SCRIPT = yes; # otherwise shebangs wont work for systemd services
      BLK_DEV_INITRD = yes;
      CRYPTO = yes;
      CRYPTO_USER_API_HASH = yes;
      DMI = mkIf hpl.isx86;
      DMIID = mkIf hpl.isx86;
      FILE_LOCKING = yes; # otherwise libmount fails to updat the userpace mount table
      MULTIUSER = yes;
      # SMP = yes; # enable multi-core support

      # armv7 specials
      AEABI = mkIf hpl.isArmv7; # we assume eabi in the userspace for NixOS on armv7l
      ARCH_MULTI_V7 = mkIf hpl.isArmv7; # enable Cortex-A support, avoid µ-controller Linux
      ARCH_VIRT = mkIf hpl.isArmv7; # enable virtualization support
      ARM_THUMBEE = mkIf hpl.isArmv7; # ThumbEE may be used by our userspace
      COMPAT_32BIT_TIME = mkIf hpl.isArmv7; # otherwise glibc's pthread_once exits with exit code 4
      MMU = mkIf hpl.isArmv7; # enable MMU
      NEON = mkIf hpl.isArmv7; # we assume neon is available
      VFP = mkIf hpl.isArmv7; # target is gnueabihf -> hardware floating point unit support

      # powerpc specials
      ALTIVEC = mkIf hpl.isPower;
      CORENET_GENERIC = mkIf hpl.isPower;
      E6500_CPU = mkIf hpl.isPower; # most interesting for us is the e6500 in the T2080
      KERNEL_GZIP = mkIf hpl.isPower;
      PPC64 = mkIf hpl.isPower64;
      PPC_BOOK3E_64 = mkIf hpl.isPower; # embedded PPC, not IBM server grade
      PPC_QEMU_E500 = mkIf hpl.isPower;

      # network
      INET = yes;
      IPV6 = yes;
      NET = yes;
      NETDEVICES = yes; # otherwise systemd-resolved can't bind using SO_BINDTOIFINDEX
      PACKET = yes; # otherwise sytemd-networkd fails to acquire DHCP leases

      # erofs support
      EROFS_FS = yes;
      EROFS_FS_POSIX_ACL = yes;
      EROFS_FS_XATTR = yes;

      # overlayfs support
      OVERLAY_FS = yes;

      # squashfs support
      BLOCK = yes;
      BLK_DEV_LOOP = yes;
      MISC_FILESYSTEMS = yes;
      SQUASHFS = yes;
      SQUASHFS_ZSTD = yes;
      SQUASHFS_CHOICE_DECOMP_BY_MOUNT = yes; # make `mount -o threads=multi` work

      # tmpfs support
      SHMEM = yes; # required for TMPFS
      TMPFS = yes;
      TMPFS_POSIX_ACL = yes;
      TMPFS_XATTR = yes;

      # glibc
      FUTEX = yes; # for pthreads implementation

      # systemd requirements form the manual
      DEVTMPFS = yes;
      CGROUPS = yes;
      INOTIFY_USER = yes;
      SIGNALFD = yes;
      TIMERFD = yes;
      EPOLL = yes;
      UNIX = yes;
      SYSFS = yes;
      PROC_FS = yes;
      FHANDLE = yes;

      # systemd goodies from the manual
      NET_NS = whenOlder "5.5" yes;
      USER_NS = whenOlder "5.5" yes;
      SECCOMP_FILTER = yes;
      NET_SCHED = yes;
      NET_SCH_FQ_CODEL = yes;
      KCMP = yes;
      EVENTFD = yes; # systemd calls it config_event_fd

      # unofficial systemd requirements
      POSIX_TIMERS = yes; # required for systemd-update-utmp
      RSEQ = yes; # used by systemd-update-utmp

      # IO
      PRINTK = yes;
      SERIAL_8250 = mkIf hpl.isx86;
      SERIAL_8250_CONSOLE = mkIf hpl.isx86;
      SERIAL_AMBA_PL011 = mkIf hpl.isAarch;
      SERIAL_AMBA_PL011_CONSOLE = mkIf hpl.isAarch;
      TTY = yes;

      # make the kernel behave better as a guest
      HYPERVISOR_GUEST = mkIf hpl.isx86;
      KVM_GUEST = mkIf hpl.isx86;
      PARAVIRT = mkIf (hpl.isx86 || hpl.isAarch);
      # PARAVIRT_SPINLOCKS = yes; # requires `SMP = yes;`
      VIRTIO = yes;
      VIRTIO_CONSOLE = yes;
      X86_X2APIC = mkIf hpl.isx86;

      # virtio networking
      ETHERNET = yes;
      PCI = yes;
      VIRTIO_MENU = yes;
      VIRTIO_NET = yes;
      VIRTIO_PCI = yes;
    };
    ignoreConfigErrors = false;
  };
in
buildLinux (buildLinuxArgs // passthroughArgs)
