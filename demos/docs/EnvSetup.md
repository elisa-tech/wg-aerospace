<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Environment Setup

This environment uses a Dev Container backed by Docker.
That gives us a consistent environment where applications run the same way in development, testing, and CI.
The container is built locally on demand from the repo's Dockerfile instead of being pulled from a prebuilt registry image.

Before opening the devcontainer, make sure Docker is installed on the host. If you are using the command-line flow, the [environment setup script](../env/setup-env.sh) is still the host bootstrap for Docker, local permissions, and devcontainer CLI prerequisites.
If you prefer, you can still install the devcontainer CLI manually with `npm install -g @devcontainers/cli`, or install the Dev Containers extension in VS Code and use its built-in command.

Compatible with Docker release/API v27+ in the following Operating Environments.

- Linux (AMD64/ARM64)
  - Ubuntu 22.04+
- Windows 10+ (AMD64/ARM64)
  - Windows Services for Linux (WSL) 2.0 running the "Ubuntu 24.04.1 LTS" Distribution

## Start Here

The first step is to get a shell/terminal.

- Linux Desktop, `ctrl-shift 't'` should open a window.
- Windows, `Press Win + R, type cmd or powershell, and hit Enter.` Then list WSL distros with `wsl.exe -l`.
  - If a `Ubuntu*` is found, execute `wsl.exe -d <Ubuntu name from list>` to get a bash shell.
  - If the Ubuntu distro isn't found or the list fails to display
    - (Powershell) Enable WSL - `wsl --install -d Ubuntu-24.04` and reboot. Then try the above commands again to list the WSL distros & launch Ubuntu.
    - If the `Enable WSL` didn't work, WSL may require additional Windows Features to be enabled
      - Right-click on the Windows Start menu icon, choose Search and type Windows Features. Select the top entry (category Control panel) to enable or turn off Windows-Features. The Windows-Features dialog will be opened.
      - Select in the upcoming dialog the check box for Virtual Machine Platform from the bottom of the list and press the OK button. Applying the changes may take a few minutes. Finally, press the Restart now button to reboot the computer. Then try the above commands again to list the WSL distros & launch Ubuntu.
      - Note: Virtualization extensions are required, and may need to be enabled if above steps fail - <https://support.microsoft.com/en-us/windows/enable-virtualization-on-windows-c5578302-6e43-4b4b-a449-8ced115f58e1>

Next, in the shell started above

- If you want the VS Code flow, install the Dev Containers extension first.
- If you want the command-line flow, run the environment setup script first to set up Docker and the `devcontainer` CLI.

- Change directory to your home `cd ~`
- Clone use case codebase `git clone https://github.com/elisa-tech/wg-aerospace.git` and `cd wg-aerospace`.
- Navigate to `./demos/env` and run `bash ./setup-env.sh` as a normal user. If this script failed with a "Sudo is disabled on that computer" error, enable Sudo in Windows 11 WSL under Settings > System > For Developers.
- Open the repository in VS Code and use the Dev Containers command, or use the command-line `devcontainer` CLI.
- The first start builds the environment locally from [the devcontainer definition](../../.devcontainer/devcontainer.json) and [Dockerfile](../env/Dockerfile).
- Then open a shell in the container and run the demo commands from there.

The last step is to try out the [Basic Demo](../copilot/BasicDemo.md) using this new environment.

## References

### Recreating the devcontainer

The [Dockerfile](../env/Dockerfile) backs the repo's [devcontainer configuration](../../.devcontainer/devcontainer.json) and the GitHub Actions workflow. It is built locally on first use instead of pulling a prepublished registry image.
