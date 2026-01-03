# Environment Setup

This environment utilizes a Docker container.  This gives us the benefit of a consistent environment where applications can run the same way in development, testing, and production. Containers provide isolation, preventing dependencies from interfering with each other, and simplify setup. This approach integrates well with CI/CD pipelines, and fosters collaboration by enabling developers to share environments easily.

Compatible with Docker release/API v27+ in the following Operating Environments.
- Linux (AMD64/ARM64)
  - Ubuntu 22.04+
- Windows 10+ (AMD64/ARM64)
  - Windows Services for Linux (WSL) 2.0 running the "Ubuntu 24.04.1 LTS" Distribution

## Start Here

The first step is to get a shell/terminal.
- Linux Desktop, `ctrl-shift 't'` should open a window.
- Windows, `Press Win + R, type cmd or powershell, and hit Enter.`  Then list WSL distros with `wsl.exe -l`.
  - If a `Ubuntu*` is found, execute `wsl.exe -d <Ubuntu name from list>` to get a bash shell.
  - If the Ubuntu distro isn't found or the list fails to display
    - (Powershell) Enable WSL - `wsl --install -d Ubuntu-24.04` and reboot.  Then try the above commands again to list the WSL distros & launch Ubuntu.
    - If the `Enable WSL` didn't work, WSL may require additional Windows Features to be enabled
      - Right-click on the Windows Start menu icon, choose Search and type Windows Features. Select the top entry (category Control panel) to enable or turn off Windows-Features. The Windows-Features dialog will be opened.
      - Select in the upcoming dialog the check box for Virtual Machine Platform from the bottom of the list and press the OK button. Applying the changes may take a few minutes. Finally, press the Restart now button to reboot the computer.  Then try the above commands again to list the WSL distros & launch Ubuntu.
      - Note: Virtualization extensions are required, and may need to be enabled if above steps fail - https://support.microsoft.com/en-us/windows/enable-virtualization-on-windows-c5578302-6e43-4b4b-a449-8ced115f58e1

Next, in the shell started above
- Change directory to your home `cd ~`
- Clone use case codebase `git clone https://github.com/elisa-tech/wg-aerospace.git` and `cd wg-aerospace`.
- Navigate to `./demos/env`, run our [environment setup script](../env/setup-env.sh) as a normal user with sudoers rights `bash ./setup-env.sh`. If this script failed with a "Sudo is disabled on that computer" error.  For Windows 11 WSL, to enable Sudo, navigate to Settings > System > For Developers and toggle on the Enable sudo option.
- Setup so your user can directly use docker `sudo usermod -aG docker "${SUDO_USER:-$USER}"`
- Start a new shell so that your user gains Docker rights (e.g., could just type `bash` enter).  Then run a test container `docker run hello-world`

The last step is to try out the [Basic Demo](../copilot/BasicDemo.md) using this new environment.

## References

### Recreating our Prebuilt Docker image

The [Dockerfile](./Dockerfile) was used in the [AeroWG CICD](https://gitlab.com/elisa-tech/aero-wg/aero-wg-ci/-/blob/main/.gitlab-ci.yml?ref_type=heads) to compose and publish the image into the [registry](https://gitlab.com/elisa-tech/aero-wg/aero-wg-ci/container_registry).  The CICD yml offers an example of how to compose and publish.
