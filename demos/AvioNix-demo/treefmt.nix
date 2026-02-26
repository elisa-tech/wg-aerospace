# SPDX-FileCopyrightText: 2024-2026 wucke13
#
# SPDX-License-Identifier: Apache-2.0

# treefmt.nix
{ ... }:
{
  # Used to find the project root
  projectRootFile = ".git/config";
  programs.actionlint.enable = true;
  programs.black.enable = true;
  programs.clang-format.enable = true;
  programs.nixfmt.enable = true;
  programs.prettier.enable = true;
  programs.rustfmt.enable = true;
  programs.taplo.enable = true; # formats TOML files

  # Large chunks of this repo are not canonicalized using the formatters configured above, so we
  # ignore them for now
  settings.excludes = [
    ".github/workflows/ci.yml"
    ".github/workflows/latex.yml"
    ".github/workflows/license-check.yml"
    ".github/workflows/lint.yml"
    "Contributing.md"
    "LICENSE"
    "LICENSES/*"
    "README.md"
    "REUSE.toml"
    "demos/Readme.md"
    "demos/copilot/*"
    "demos/docs/*"
    "demos/env/*"
    "demos/test-results/*"
    "docs/*"
    "literature-database/*"
    "meeting-minutes/*"
    "presentations/*"
  ];
}
