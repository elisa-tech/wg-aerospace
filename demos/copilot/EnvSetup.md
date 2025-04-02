# Environment Setup

This environment utilizes a Docker container.  This gives us the benefit of a consistent environment where applications can run the same way in development, testing, and production. Containers provide isolation, preventing dependencies from interfering with each other, and simplify setup. This approach integrates well with CI/CD pipelines, and fosters collaboration by enabling developers to share environments easily.

Compatible with Docker release/API v27+ in the following Operating Environments.
- Linux (AMD64)
  - Ubuntu 22.04+
- Windows 10+ (AMD64)
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
- Clone use case codebase `git clone https://github.com/elisa-tech/wg-aerospace.git` and `cd wg-aerospace`.
- Navigate to `./demos/env`, run our [environment setup script](../env/setup-env.sh) as a normal user with sudoers rights `./setup-env.sh`. If this script failed with a "Sudo is disabled on that computer" error.  For Windows 11 WSL, to enable Sudo, navigate to Settings > System > For Developers and toggle on the Enable sudo option.

The last step is to switch to the specific demo folder and follow the instructions following these commands in a shell:
- `cd demos/copilot/src/monitors`
- `make prep`
- `cabal update`
  - Which downloads the latest package list from hackage.haskell.org and should result in:
  - "Package list of hackage.haskell.org has been updated."
- `cabal v2-install --lib copilot copilot-core copilot-c99 copilot-language copilot-theorem copilot-libraries copilot-interpreter copilot-prettyprinter`
  - Which should result in:
  - "Up to date"
- `make`
- `make run`
- This will open a window in a TMUX environment with 3 sub-windows:
  - The monitoring application
  - The light server application
  - The switch application
- In the latter, the command to run is already prepared as:
  - `python3 ../python/switch.py`
  - ....which can be run to start the demo
- To exit the TMUX environment:
  - Press `CTRL+B`
  - type `kill-session`

## References

### Recreating our Prebuilt Docker image

The [Dockerfile](./Dockerfile) was used in the [AeroWG CICD](https://gitlab.com/elisa-tech/aero-wg-ci/-/blob/main/.gitlab-ci.yml?ref_type=heads) to compose and publish the image into the [registry](https://gitlab.com/elisa-tech/aero-wg-ci/container_registry).  The CICD yml offers an example of how to compose and publish.