# Environment Setup

This environment utilizes a Docker container.  This gives us the benefit of a consistent environment where applications can run the same way in development, testing, and production. Containers provide isolation, preventing dependencies from interfering with each other, and simplify setup. This approach integrates well with CI/CD pipelines, and fosters collaboration by enabling developers to share environments easily.

Compatible with Docker release/API v27+ in the following Operating Environments.
- Linux
  - Ubuntu 22.04+
- Windows 10+
  - Windows Services for Linux (WSL) 2.0 running the "Ubuntu 24.04.1 LTS" Distribution

## Start Here

The first step is to get a shell.  
- Linux Desktop, `ctrl-shift 't'` should open a window.
- Windows, `Press Win + R, type cmd or powershell, and hit Enter.`  Then `wsl.exe -d Ubuntu`.  If the Ubuntu distro isn't found, see [WSL setup](https://documentation.ubuntu.com/wsl/en/latest/guides/install-ubuntu-wsl2/).

Next, in the terminal, try to run `docker --version`.  If the command fails to be found, follow the [install instructions](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository).

The last step is to retrieve the Docker image which has been prebuilt with all the necessary tools to experience the demo scenarios.  The following command should be executed in the terminal to pull the image and drop you at a prompt inside the environment.  You can call this command again in the future and it will reuse the cached image (if a newer isn't available.)

```
docker run -it \
  -e HOST_UID="$(id -u)" \
  -e HOST_GID="$(id -g)" \
  -v ~/.ssh:/home/user/.ssh \
  -v ~/.gitconfig:/home/user/.gitconfig \
  -v $HOME:/wip registry.gitlab.com/elisa-tech/aero-wg-ci/copilot:latest
```

Note, this image is setup with `sudo` and the user should be able to `sudo apt update` and install any missing dependencies.

## References

### Recreating our Prebuilt Docker image

The [Dockerfile](./Dockerfile) was used in the [AeroWG CICD](https://gitlab.com/elisa-tech/aero-wg-ci/-/blob/main/.gitlab-ci.yml?ref_type=heads) to compose and publish the image into the [registry](https://gitlab.com/elisa-tech/aero-wg-ci/container_registry).  The CICD yml offers an example of how to compose and publish.

### Manual container setup

1) Get container

```
docker run -it ubuntu:22.04
# Should drop you to a root shell

```

2) Install copilot

```
# Notes from https://github.com/Copilot-Language/copilot?tab=readme-ov-file#other-linux-distributions

apt update
apt-get install -y build-essential git pkg-config ghc cabal-install libz-dev #  install a Haskell compiler (GHC)
cabal update
cabal v2-install --lib copilot                #  install Copilot from Hackage
ghci <<< 'import Language.Copilot'            #  test that Copilot is available - success is - ghci> ghci> Leaving GHCi.
```