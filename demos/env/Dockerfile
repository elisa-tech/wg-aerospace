# SPDX-License-Identifier: MIT
#
# Dockerfile to install Copilot and make it available to the user
#
# This file is designed to support a Docker Build on both AMD64 and ARM64
#
FROM ubuntu:26.04
# Options
# 22.04, jammy-20260109, jammy
# 24.04, noble-20260113, noble, latest
# 25.04, plucky-20251001, plucky
# 25.10, questing-20251217, questing, rolling
# 26.04, resolute-20260106.1, resolute, devel

# Avoid questions during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
      build-essential=* \
      cpio=* \
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
      alex=3.5.* \
      happy=1.20.* \
      ghc=9.6.* \
      libbz2-dev=1.0.* \
      libexpat1-dev=2.7.* \
      libghc-copilot-dev=4.* \
      zlib1g-dev=1:1.3.dfsg+really1.3.* \
      ogma=1.10.* \
      pkg-config=1.8.* \
      software-properties-common=0.119 \
      && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

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
RUN deluser --remove-home ubuntu || true
RUN useradd -ms /bin/bash user
RUN echo "user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/user \
    && chmod 0440 /etc/sudoers.d/user
# hadolint ignore=SC2016
RUN echo 'export PATH=/opt/ghc/8.6.5/bin:/opt/cabal/2.4/bin:/home/user/.cabal/bin/:$PATH' >> /home/user/.bashrc && \
    chown -R user:user /home/user
USER user
WORKDIR /home/user

# Transparent uid:gid setup for manual container use
# Moved here as the copy will always reset cached history for everything that follows
USER root
COPY entry.sh /entry.sh
RUN chmod 777 /entry.sh && chown root:root /entry.sh
USER user

# Check that tools seem to run as normal user
RUN ghci --version && \
    ogma --help

# HEALTHCHECK instruction is not applicable in this context.
ENTRYPOINT ["/entry.sh"]
