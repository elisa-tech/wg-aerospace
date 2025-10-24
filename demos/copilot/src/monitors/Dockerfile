# SPDX-License-Identifier: MIT
#
# Dockerfile to install Copilot and make it available to the user
#
#
# This file is specific to versions of Ubuntu strictly before 23.04. After that
# version, Copilot became included in Ubuntu as a package.
#
FROM ubuntu:focal

# Avoid questions during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
      build-essential \
      cpio \
      git \
      git-lfs \
      less \
      locales \
      screen \
      sudo \
      qemu-system-arm \
      qemu-system-misc \
      qemu-system-x86 \
      tmux \
      unzip \
      vim \
      wget \
      && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

# Install Copilot dependencies
RUN apt-get update && \
    apt-get install -y \
      alex \
      happy \
      libbz2-dev \
      libexpat-dev \
      libz-dev \
      pkg-config \
      software-properties-common \
      && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*
RUN add-apt-repository ppa:hvr/ghc && \
    apt-get update && \
    apt-get install -y \
      ghc-8.6.5 \
      cabal-install-2.4 \
      && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

# To be able to generate a toolchain with locales, enable one UTF-8 locale
RUN sed -i 's/# \(en_US.UTF-8\)/\1/' /etc/locale.gen && \
    /usr/sbin/locale-gen

# Stage default user
RUN useradd -ms /bin/bash user
RUN echo "user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/user \
    && chmod 0440 /etc/sudoers.d/user
RUN echo 'export PATH=/opt/ghc/8.6.5/bin:/opt/cabal/2.4/bin:/home/user/.cabal/bin/:$PATH' >> /home/user/.bashrc && \
    chown -R user:user /home/user
# Transparent uid:gid setup for manual container use
COPY entry.sh /entry.sh
RUN chmod 777 /entry.sh && chown root:root /entry.sh
USER user
WORKDIR /home/user

# Install Copilot
ENV PATH=/opt/ghc/8.6.5/bin:/opt/cabal/2.4/bin:/home/user/.cabal/bin/:$PATH
RUN cabal v2-update
RUN cabal v2-install --lib \
    copilot-4.5.1 \
    copilot-c99-4.5.1 \
    copilot-interpreter-4.5.1 \
    copilot-language-4.5.1 \
    copilot-libraries-4.5.1 \
    copilot-theorem-4.5.1

# Install Ogma
RUN cd && \
    git clone https://github.com/nasa/ogma.git && \
    cd ogma && \
    cabal v2-install ogma-cli:ogma && \
    cd && \
    rm -rf ogma

# Check that tools seem to run
RUN ghci --version && ogma --help

ENTRYPOINT ["/entry.sh"]
