# SPDX-FileCopyrightText: 2026 wucke13
#
# SPDX-License-Identifier: Apache-2.0

{
  fetchurl,
  linuxKernel,
}:

let
  src = fetchurl {
    url = "https://www.kernel.org/pub/linux/kernel/v6.x/linux-${version}.tar.xz";
    hash = "sha256-J4PUIRIJX5XFEOG0IfBW34y/qEX5BAxhFQgENKd6d2s=";
  };
  version = "6.6.39";

  configfile = fetchurl {
    # on 2026-02-13 this was the latest revision, dating back to 2025-03-04
    url = "https://raw.githubusercontent.com/elisa-tech/wg-lfscs/660dc88b358261b83492348811efd554e959dcc5/min_prog_trace/kernel.config";
    hash = "sha256-KvgiKOPTS0jjTpFRWbrPSIhk/eR2T6VSowXvrH8cTKk=";
  };

  kernel =
    (linuxKernel.manualConfig {
      inherit configfile src version;
      config.CONFIG_DEBUG_INFO = "y"; # otherwise the elf-to-sloc tool won't work
    }).overrideAttrs
      {
        outputs = [
          "dev"
          "out"
        ];
        postInstall = ''
          mkdir --parent -- $dev
          cp -- vmlinux $dev/
        '';
      };
in
kernel
