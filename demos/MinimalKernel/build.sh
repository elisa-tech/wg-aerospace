# Aerospace WorkingGroup CICD

## Minimal Linux Kernel

### Reproduce locally

Windows
1) Install Docker Desktop
2) Start a Powershell

Linux
1) Install Docker
2) Start shell

Common Steps

After setting up your respective environment above and you're at the shell prompt.

1. Pull/run container used as CI job "image" with `registry.gitlab.com` prefix as shown below.
    ```
    docker run -it --user root registry.gitlab.com/buildroot.org/buildroot/base:20230207.1123
    ```
1. Get the latest build script and run it.
    ```
    wget https://gitlab.com/elisa-tech/aero-wg-ci/-/raw/main/build.sh
    chmod 755 build.sh && ./build.sh
    ```
1. Run the qemu emulation line per the CI job definition. (https://gitlab.com/elisa-tech/aero-wg-ci/-/blob/main/.gitlab-ci.yml?ref_type=heads#L10)
