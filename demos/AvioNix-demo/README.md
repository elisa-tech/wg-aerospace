# AvioNix Demonstrator

This is another attempt at providing a meaningful demo. On the [Product Profiles](../../docs/product-profiles.md) ontology, this effort maps to Software Level E and possibly Software Level D. It features a slimmed down Linux kernel (<300 kSLoC) and slimmed down systemd, but a fairly comprehensive Linux userspace.

## Nix FAQ

- **What is Nix?** Nix is a (functional, declarative) programming language geared towards package management. Nix expressions can be evaluated to build recipes ("derivations"). When a derivation is successfully built ("realized") it produces a folder in Nix' build cache on your machine (the "Nix store", usually under `/nix/store/`).
- **What is Nix about?**
  - Reproducible. Nix goes to great length to ensure that a build which works on my machine also works on your machine.
  - Declarative. Rather than a set of imperative commands that modify an environment of unknown state into another, hopefully desired but still partially unknown state ("take a Debian container, run these `apt-get` commands, then run `make`"), Nix tries to be declarative upfront. If a library is required to build something, Nix expressions describing the building of that library are required, too. Luckily, the [`nixpkgs`](https://github.com/NixOS/nixpkgs) contain over [100,000 package build descriptions](https://repology.org/repositories/statistics/newest) spread over ~4 million lines of Nix expressions contributed by ~9000 contributors over the last 20 years.
  - One tool. Nix substitutes and/or abstracts over other methods to install toolchains and packages the like. Generally speaking, almost every build is just a single command away.
  - Mixed toolchains. Per default, Nix works without a singular global environment. Compilers, tools, libraries, ... are cached in the Nix store, and only made visible to build environments if explicitly declared input to the given build. You may have three variants of the same GCC 15.2.0 (i.e. with different patches applied) on the same computer, without conflict.
  - Powerful abstraction over cross compilation. Nix natively supports cross compilation, distinguishing `buildPlatform` (the computer a package is built on), `hostPlatform` (the computer the package shall be executable on) and the `targetPlatform` (for the special case that the package is a compiler, what computer that compiler shall be able to generate code for).
- **How is a derivation built under the hood?** In the end, a derivation just declares a "builder" program to be executed, with a set of arguments ("args") passed, and possibly some environment variables ("env") set. The execution of builder takes place in a decently well isolated, container-like sandbox to assure reproducibility (which could be compromised by the leaking of a globally installed toolchain into the build environment). Most often, the builder is `bash`, and the arguments is a shell script which via environment variables is tailored to build a certain thing. Somewhat derogatory, Nix sometimes is referred to as a fancy pre-processor for bash.
- **How do I install Nix to build stuff from this repo?**
  - \[Linux/OS X/Windows\] Using an OCI container engine like Docker or Podman
    - Run the `nixos/nix` container (i.e. `podman run -it nixos/nix`)
    - Enable the flakes feature:

    ```bash
    echo experimental-features = flakes nix-command >> /etc/nix/nix.conf
    ```

    - Per default, the containerized Nix is not sandboxing its builders. This should not be a problem, however, be advised to read the [brief paragraph about it](https://hub.docker.com/r/nixos/nix#limitations).

  - \[Linux, any distro\] Using the official installer
    - Follow the instructions from <https://nixos.org/download/#nix-install-linux>
    - Enable the flakes feature:
      ```bash
      mkdir --parent -- ~/.config/nix
      echo experimental-features = flakes nix-command >> ~/.config/nix/nix.conf
      ```
  - \[Windows\] Using the Windows Subsystem for Linux (WSL) image
    - Follow the instructions from <https://github.com/nix-community/NixOS-WSL?tab=readme-ov-file#quick-start>
    - Enable the flakes feature:
      ```bash
      mkdir --parent -- ~/.config/nix
      echo experimental-features = flakes nix-command >> ~/.config/nix/nix.conf
      ```
  - **Note**: While Nix provides awesome abstractions for cross compilation especially regarding processor architectures, some software simply is not designed to be cross compiled. This foremost hits cross compilation across OSes; it is for example notoriously hard to cross compile from a non OS X system for OS X, especially if Apple foundational libraries are required. More relevant to this use-case, not all Linux tools cross compile well from foreign OSes to Linux. The aforementioned installation notes are tailored with this in mind: The WSL runs native Linux tools (via syscall translation for WSL 1 and via a VM for WSL 2), and Docker on OS X as on Windows uses a Linux VM too. You might succeed to build some of the packages here i.e. using Nix on OS X natively, but we do not test this route --- you are on your own.

- **What are flakes?** This is a newish way to organize Nix expressions. Flakes provide an opinionated way to expose entry functions (think like `int main()` for C) for Nix expressions. If you want to deep dive, <https://jade.fyi/blog/flakes-arent-real/> provides a lot of background and commentary on the technical design, pros and cons of flakes.
- **What is a closure?** A closure refers to the sum of all things reachable by/enclosed in a given context. For a package, the closure thus means all other packages which it needs at run-time, for example all dynamically linked libraries.
- **What is NixOS?** NixOS is a Linux distribution built upon the foundation of Nix and the `nixpkgs`. At is core, a Linux distribution is just a package management mechanism (for NixOS that is Nix) and a set of packages containing kernel & userspace (all to be found in the `nixpkgs`).
- **Do I need NixOS to use this repo?** No, the stuff in this repo only needs Nix for building, you don't need to install NixOS on your development machine. Nonetheless, you are in fact building slim NixOS installations, as some of the build outputs here use NixOS internals to provide a bootable Linux userland and Linux kernel.
- **I want to learn more, where do I start?**
  - [How Nix works](https://nixos.org/guides/how-nix-works/): A brief introduction on both Nix and NixOS, highlighting the main concepts
  - [Nix manual](https://nixos.org/manual/nix/stable): Quite formal, lengthy, detailed, covers the Nix language, the tool command line
  - [Nix pills](https://nixos.org/guides/nix-pills/): A guide gradually pulling away the curtain behind the technical foundation and core design of Nix
  - [Nixpkgs manual](https://nixos.org/manual/nixpkgs/stable/): Very formal, lengthy, detailed explanation of the nixpkgs and most relevant conventions within it
  - [NixOS manual](https://nixos.org/manual/nixos/stable/): Very formal, lengthy, detailed explanation of NixOS; this is what explains all the configuration options set within [`nixos-configurations`](./nixos-configurations)
  - [Nix vs. Docker](https://www.devzero.io/blog/nix-vs-docker/): A fair comparison between Nix and Docker, comparing overlap and divergence in operation and capabilities
  - [What to expect (good and bad) from using Nix/NixOS](https://pierrezemb.fr/posts/nixos-good-bad-ugly/): An experience report from a new user on perceived advantages and frustrations going the Nix way

## Build Instructions

- Build the kernel
  - ```bash
    nix build .\#nixosConfigurations.elisa-demo.config.boot.kernelPackages.kernel
    ```

- Build the kernel config file
  - ```bash
    nix build .\#nixosConfigurations.elisa-demo.config.boot.kernelPackages.kernel.configfile
    ```

- Build the fat ramdisk (initrd + squashfs)
  - ```bash
    nix build .\#nixosConfigurations.elisa-demo.config.system.build.standaloneRamdisk
    ```

- Build the toplevel system closure
  - ```bash
    nix build .\#nixosConfigurations.elisa-demo.config.system.build.toplevel
    ```

- Build and run as VM
  - ```bash
    nix run .\#nixosConfigurations.elisa-demo.config.system.build.standaloneRamdiskVm
    ```

- Build initrd
  - The Nix expressions in this repo concatenate a small initrd with a squashfs to create a fat, freestanding ramdisk that requires no further storage device. You may however build both the initrd and the squashfs image individually:
  - ```bash
    nix build --out-link initrd .\#nixosConfigurations.elisa-demo.config.system.build.initialRamdisk
    nix build --out-link squashfs .\#nixosConfigurations.elisa-demo.config.system.build.squashfsStore
    ```

## Build all …

- … NixOS configs

  ```bash
  nix build $(nix eval --raw .\#nixosConfigurations --apply 'x: (builtins.concatStringsSep " " (builtins.map (y: ".#nixosConfigurations.${y}.config.system.build.toplevel") (builtins.attrNames x)))')
  ```

- … packages
  ```bash
  nix build $(nix eval --raw .\#packages.x86_64-linux --apply 'x: (builtins.concatStringsSep " " (builtins.map (y: ".#${y}") (builtins.attrNames x)))')
  ```

**Note**: Sometimes it is interesting to just build everything that can be built.

## Advanced Debugging and Tooling

- Launch the kernel in QEMU with GDB attached
  ```bash
  nix run .\#nixosConfigurations.elisa-demo.config.system.build.gdbLauncher
  ```
- Count the distinct source lines of code for the Linux kernel use in the demo
  ```bash
  nix build .\#nixosConfigurations.elisa-demo.config.system.build.kernel.dev
  nix run .\#elf-to-sloc result-dev/vmlinux > /dev/null
  ```
