# SPDX-FileCopyrightText: 2024-2025 wucke13
#
# SPDX-License-Identifier: Apache-2.0

# treefmt.nix
{ ... }:
{
  # Used to find the project root
  projectRootFile = "flake.nix";
  programs.actionlint.enable = true;
  programs.black.enable = true;
  programs.clang-format.enable = true;
  programs.nixfmt.enable = true;
  programs.prettier.enable = true;
  programs.rustfmt.enable = true;
  programs.taplo.enable = true; # formats TOML files
}
