<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Environment building notes

The information talks about the process and background notes used to develop the Docker environment used to run the demos. The specific emulated environments are described [here.](../docs/embedded-environments/Readme.md)

CI that builds and stores our images - <https://gitlab.com/elisa-tech/aero-wg/aero-wg-ci>

## Development

- Make sure to lint `docker run --rm -i hadolint/hadolint < Dockerfile`
- If storage gets full, prune the Docker system `docker system prune -f -a`

### ARM

- Used a ARM64 host from AWS and Ubuntu 24.x

- Matt and Martin verified the following on a Windows 11 ARM64 WSL for the commit this was added with.

```
# uname -a
Linux martin-surface2 6.6.87.2-microsoft-standard-WSL2 #1 SMP PREEMPT_DYNAMIC Thu Jun  5 18:31:42 UTC 2025 aarch64 aarch64 aarch64 GNU/Linux

# cat  /etc/os-release
PRETTY_NAME="Ubuntu 24.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.3 LTS (Noble Numbat)"
VERSION_CODENAME=noble
ID=ubuntu
ID_LIKE=debian
HOME_URL="[https://www.ubuntu.com/"](https://www.ubuntu.com/%22)
SUPPORT_URL="[https://help.ubuntu.com/"](https://help.ubuntu.com/%22)
BUG_REPORT_URL="[https://bugs.launchpad.net/ubuntu/"](https://bugs.launchpad.net/ubuntu/%22)
PRIVACY_POLICY_URL="[https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"](https://www.ubuntu.com/legal/terms-and-policies/privacy-policy%22)
UBUNTU_CODENAME=noble
LOGO=ubuntu-logo
```

### Manual build of NASA tools

Here's the section of steps to manually build Haskell and all the pieces to get
a functional Ogma/Copilot environment. The container build today can use Ubuntu
pkg feed pre-builts instead of this sequence.

```
# Build Haskell env from source
ENV BOOTSTRAP_HASKELL_NONINTERACTIVE=1
ENV BOOTSTRAP_HASKELL_VERBOSE=1
ENV BOOTSTRAP_HASKELL_GHC_VERSION=8.6.5
ENV GHCUP_INSTALL_BASE_PREFIX=/opt
RUN apt-get update && \
    apt-get install -y \
      alex \
      curl \
      happy \
      libbz2-dev \
      libexpat-dev \
      libncurses-dev \
      libtinfo5 \
      libz-dev \
      pkg-config \
      software-properties-common \
      && \
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh && \
    ls /opt/.ghcup/bin && /opt/.ghcup/bin/ghcup gc --cache && \
    rm -rf /root/.cabal/packages/* /opt/.ghcup/cache/ghc-8.6.5-a /opt/.ghcup/cache/stack* && \
    . /opt/.ghcup/env && \
    cabal clean && \
    echo 'source /opt/.ghcup/env' >> /root/.bashrc && \
    apt-get remove -y \
      alex \
      curl \
      happy \
      libbz2-dev \
      libexpat-dev \
      libncurses-dev \
      libz-dev \
      pkg-config \
      software-properties-common \
      && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo 'source /opt/.ghcup/env' >> /home/user/.bashrc && \
    chown -R user:user /home/user
USER user
WORKDIR /home/user

# Install Copilot - cabal was stable on a small ARM machine with extra args setting limits
#                     e.g., --jobs=1 --ghc-options="+RTS -M200M -RTS"
RUN sudo apt-get update && \
    sudo apt-get install -y \
      clang \
      libbz2-dev \
      libgmp-dev \
      lld \
      lldb \
      llvm \
      && \
    . /opt/.ghcup/env && \
    cabal v2-update && \
    cabal v2-install --lib \
    copilot-4.5.1 \
    copilot-c99-4.5.1 \
    copilot-interpreter-4.5.1 \
    copilot-language-4.5.1 \
    copilot-libraries-4.5.1 \
    copilot-theorem-4.5.1 && \
    git clone https://github.com/nasa/ogma.git && \
    cd ogma && \
    cabal v2-install ogma-cli:ogma && \
    echo 'export PATH=$HOME/.local/bin/:$PATH' >> /home/user/.bashrc && \
    cd .. && \
    rm -rf ogma && \
    cabal clean && \
    rm -rf ~/.cache/cabal/packages/* && \
    sudo apt-get remove -y \
      clang \
      lld \
      lldb \
      llvm \
      && \
    sudo apt-get -y autoremove && \
    sudo apt-get -y clean && \
    sudo rm -rf /var/lib/apt/lists/*

ENV PATH=/home/user/.local/bin/:$PATH
```
