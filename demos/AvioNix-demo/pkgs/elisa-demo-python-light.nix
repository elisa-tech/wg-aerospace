# SPDX-FileCopyrightText: 2025-2026 wucke13
#
# SPDX-License-Identifier: Apache-2.0

{ python3Packages }:

python3Packages.buildPythonApplication {
  name = "elisa-demo-copilot-python-light";
  src = ../../copilot/src/python;
  pyproject = true;
  build-system = [ python3Packages.setuptools ];
}
