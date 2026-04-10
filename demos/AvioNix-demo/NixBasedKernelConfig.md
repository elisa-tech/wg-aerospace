<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Nix-based kernel configuration options, walk-through

The goal of this document is to provide means to change the kernel config to an extent that it gets minimal to your needs on an abstraction level higher than the actual kernel config file.
There are many more dimensions to it like target hardware and/or kernel version, but this is a starting point.
Switching on/off certain features of the kernel this way ensures that also dependencies are covered and reduced the amount of parameters to a minimum in the first place.

## General workflow:

1. Assuming you have a Nix environment and checked out the wg-aerospace repository,
2. Enable/disable kernel options in the `minimal-linux-kernel.configfile`
3. Have Nix build the actual kernel configuration out of it

## Exemplary workflow:

1. Checkout the repository from GIT to your home directory (into the wg-aerospace subfolder)
2. Go to: `~/wg-aerospace/demos/AvioNix-demo`
3. Inspect the file `pkgs/minimal-linux-kernel.nix`

- (Repo-Link: https://github.com/elisa-tech/wg-aerospace/blob/c66da7a41bea478b34aef96db5a34d3e40b8381a/demos/AvioNix-demo/pkgs/minimal-linux-kernel.nix#L77)
- You will find in that file the section `structuredExtraConfig`, like:

```nix
{
  /* ... */
  structuredExtraConfig = with lib.kernel; {
    # nixos nags about these
    AUTOFS_FS = yes;
    MODULES = yes;
    CRYPTO_HMAC = yes;
    CRYPTO_SHA256 = yes;
    SECCOMP = yes;
    /* ... */
  };
  /* ... */
}
```

4. To actually make kernel config out of this meta-config, you can build the actual kernel config file with this command:

```bash
nix build .\#minimal-linux-kernel.configfile
```

5. The result will be created written to a kernel config file that can be found under the symlink `result` (which you may want to save and/or further customize)
6. As an example: Lets say you want to switch off IPv6 to study the effect, then change the parameter in this section accordingly

```patch
--- a/demos/AvioNix-demo/pkgs/minimal-linux-kernel.nix
+++ b/demos/AvioNix-demo/pkgs/minimal-linux-kernel.nix
@@ -115,7 +115,7 @@

       # network
       INET = yes;
-      IPV6 = yes;
+      IPV6 = no;
       NET = yes;
       NETDEVICES = yes; # otherwise systemd-resolved can't bind using SO_BINDTOIFINDEX
       PACKET = yes; # otherwise sytemd-networkd fails to acquire DHCP leases
```

7. Compile again using the nix command from above
8. You could now compare the two generated kernel config file to see the effect. As an example, for switching off IPv6, the result in removed/changed kernel config parameters is:

- [removed] `CONFIG_NET_IP_TUNNEL=y`
- [removed] `CONFIG_INET_TUNNEL=y`
- [removed] `CONFIG_IPV6=y` (and related CONFIG_IV6_XXX parameters)
- [removed] `CONFIG_IPV6_SIT=y`
- [removed] `CONFIG_IPV6_NDISC_NODETYPE=y`
- [removed] `CONFIG_DST_CACHE=y`
- [removed] `CONFIG_GRO_CELLS=y`
- [removed] `CONFIG_CRYPTO_LIB_SHA1=y`
- [removed] `CONFIG_CRYPTO_LIB_SHA1_ARCH=y`

9. You could now dive further into it by e.g. inspecting what effect it has on the kernel size, source code, functions calls etc.
10. You could share a specific nix (kernel) configuration you are using (maybe for a specific architecture / use-case) with the group to reproduce.
