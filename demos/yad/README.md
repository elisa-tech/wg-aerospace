# Yet Another Demo

- Build the kernel
  - ```bash
    nix build .\#nixosConfigurations.elisa-demo.config.boot.kernelPackages.kernel
    ```

- Build the kernel config file
  - ```bash
    nix build .\#nixosConfigurations.elisa-demo.config.boot.kernelPackages.kernel.configfile
    ```

- Build the initrd
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

# Building separate initrd and squashfs

```bash
nix build --out-link initrd .\#nixosConfigurations.elisa-demo.config.system.build.initialRamdisk
nix build --out-link squashfs .\#nixosConfigurations.elisa-demo.config.system.build.squashfsStore
```

# Build all …

- … NixOS configs

  ```bash
  nix build $(nix eval --raw .\#nixosConfigurations --apply 'x: (builtins.concatStringsSep " " (builtins.map (y: ".#nixosConfigurations.${y}.config.system.build.toplevel") (builtins.attrNames x)))')
  ```

- … packages
  ```bash
  nix build $(nix eval --raw .\#packages.x86_64-linux --apply 'x: (builtins.concatStringsSep " " (builtins.map (y: ".#${y}") (builtins.attrNames x)))')
  ```
