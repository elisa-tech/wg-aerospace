# SPDX-FileCopyrightText: 2025-2026 wucke13
#
# SPDX-License-Identifier: Apache-2.0

{ python3Packages }:

python3Packages.buildPythonApplication {
  name = "elisa-demo-copilot-python-light";
  src = ../../copilot/src/python;
  pyproject = true;
  build-system = [ python3Packages.setuptools ];

  # logging to stdout/stderr is nice desirable
  postPatch = ''
    substituteInPlace appConfiguration.py \
      --replace-fail 'CONSOLE_LOGGING_ENABLED = False' 'CONSOLE_LOGGING_ENABLED = True' \
      --replace-fail 'LOG_FILE_LOGGING_ENABLED = True' 'LOG_FILE_LOGGING_ENABLED = False'
  '';
}
