# SPDX-License-Identifier: MIT
#
# Dockerfile to install Copilot and make it available to the user
#
# This file is designed to support a Docker Build on both AMD64 and ARM64
#
# checkov:skip=CKV_DOCKER_2: no health check
FROM ubuntu:26.10

# Options
# 22.04, jammy-20260109, jammy
# 24.04, noble-20260113, noble, latest
# 25.04, plucky-20251001, plucky
# 25.10, questing-20251217, questing, rolling
# 26.04, resolute-20260724.1, resolute
# 26.10, stonking-20260705, stonking, devel

# Avoid questions during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
      build-essential=* \
      bash-completion=* \
      cpio=* \
      file=* \
      git=* \
      git-lfs=* \
      less=* \
      locales=* \
      screen=* \
      sudo=* \
      qemu-system-arm=* \
      qemu-system-misc=* \
      qemu-system-x86=* \
      tmux=* \
      unzip=* \
      vim=* \
      wget=* \
      && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

# Install Copilot / Haskell via Ogma as depends
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      alex=* \
      cabal-install=* \
      happy=* \
      ghc=* \
      libbz2-dev=* \
      libexpat1-dev=* \
      libghc-copilot-dev=* \
      make=* \
      cmake=* \
      zlib1g-dev=* \
      ogma=* \
      pkg-config=* \
      software-properties-common=* \
      && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

# Host packages required to build the ELISA meta-aerospace layer (cFS on
# Space Grade Linux) via kas. Based on the Yocto Project required host
# packages plus kas (see meta-aerospace/README.cfs.md and
# https://sgl.elisa.tech/building.html).
# hadolint ignore=DL3008
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      gawk=* \
      diffstat=* \
      texinfo=* \
      chrpath=* \
      socat=* \
      python3=* \
      python3-pip=* \
      python3-venv=* \
      python3-pexpect=* \
      python3-git=* \
      python3-jinja2=* \
      python3-subunit=* \
      debianutils=* \
      iputils-ping=* \
      xz-utils=* \
      zstd=* \
      lz4=* \
      libacl1=* \
      && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

# Install kas into an isolated venv and expose it on PATH (PEP 668 safe).
# Mirrors the SGL PIC64-HPSC build instructions' use of pip-installed kas.
RUN python3 -m venv /opt/kas && \
    /opt/kas/bin/pip install --no-cache-dir kas && \
    ln -s /opt/kas/bin/kas /usr/local/bin/kas && \
    kas --version

# To be able to generate a toolchain with locales, enable one UTF-8 locale
RUN sed -i 's/# \(en_US.UTF-8\)/\1/' /etc/locale.gen && \
    /usr/sbin/locale-gen

# Pass environment variables during a build to represent a version
ARG CI_COMMIT_SHA="Local"
ARG CI_PIPELINE_URL="Local"
ARG DOCKERFILE_AUTHOR="Local"
ARG DOCKERFILE_DATE="Local"
ARG DOCKERFILE_COMMIT="Local"

# Create some version metadata in "/.VERSION"
RUN echo "Creation Date: $(date -u +'%Y-%m-%dT%H:%M:%SZ')" > /.VERSION && \
    echo "CI COMMIT:     ${CI_COMMIT_SHA}"          >> /.VERSION && \
    echo "CI Pipeline:   ${CI_PIPELINE_URL}"        >> /.VERSION && \
    echo "CI Env Kernel: $(uname -a)"               >> /.VERSION && \
    echo "Dockerfile:"                              >> /.VERSION && \
    echo "  URL:    https://github.com/elisa-tech/wg-aerospace/blob/main/demos/copilot/src/monitors/Dockerfile" >> /.VERSION && \
    echo "  Author: ${DOCKERFILE_AUTHOR}"  >> /.VERSION && \
    echo "  Date:   ${DOCKERFILE_DATE}"    >> /.VERSION && \
    echo "  COMMIT: ${DOCKERFILE_COMMIT}"  >> /.VERSION && \
    cat /.VERSION

# Stage default user
RUN echo "ubuntu ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ubuntu \
    && chmod 0440 /etc/sudoers.d/ubuntu
# hadolint ignore=SC2016
RUN echo 'export PATH=/opt/ghc/8.6.5/bin:/opt/cabal/2.4/bin:/home/ubuntu/.cabal/bin/:$PATH' >> /home/ubuntu/.bashrc && \
    echo 'if [ -f /etc/bash_completion ]; then . /etc/bash_completion; elif [ -f /usr/share/bash-completion/bash_completion ]; then . /usr/share/bash-completion/bash_completion; fi' >> /home/ubuntu/.bashrc && \
    chown -R ubuntu:ubuntu /home/ubuntu
USER ubuntu
WORKDIR /home/ubuntu

# Transparent uid:gid setup for manual container use
# Moved here as the copy will always reset cached history for everything that follows
USER root
COPY demos/env/entry.sh /entry.sh
RUN chmod 777 /entry.sh && chown root:root /entry.sh
USER ubuntu

# Check that tools seem to run as normal user
RUN ghci --version && \
    ogma --help

ENTRYPOINT ["/entry.sh"]
