# SPDX-FileCopyrightText: 2024-2025 wucke13
#
# SPDX-License-Identifier: Apache-2.0

lib:

let
  # imports
  inherit (builtins) readDir;
  inherit (lib.attrsets) filterAttrs mapAttrs';
  inherit (lib.strings) removeSuffix;

  # generates an attribute set where each name is the filename of a file in pkgs, while the
  # coresponding value is the path to that file

  isNixFile = n: t: lib.strings.hasSuffix ".nix" n && t == "regular";

  # Get NixOS configs from a directory
  nixosConfigurationsFromDirectory =
    let
      inherit (lib.attrsets) concatMapAttrs;
      inherit (lib.path) append;
      inherit (lib.strings) hasSuffix removeSuffix;
      inherit (lib.trivial) pathExists;

      # Generate an attrset corresponding to a given directory.
      # This function is outside `packagesFromDirectoryRecursive`'s lambda expression,
      #  to prevent accidentally using its parameters.
      processDir =
        {
          directory,
          callNixosSystem,
          recursionDepth,
          ...
        }@args:
        concatMapAttrs (
          name: type:
          # for each directory entry
          let
            path = append directory name;
          in
          if recursionDepth <= 0 then
            { }
          else if type == "directory" then
            {
              # recurse into directories
              "${name}" = nixosConfigurationsFromDirectory (
                args
                // {
                  directory = path;
                  recursionDepth = recursionDepth - 1;
                }
              );
            }
          else if type == "regular" && hasSuffix ".nix" name then
            let
              nameWithoutSuffix = removeSuffix ".nix" name;
            in
            {
              # call .nix files
              ${nameWithoutSuffix} = callNixosSystem nameWithoutSuffix path;
            }
          else if type == "regular" then
            {
              # ignore non-nix files
            }
          else
            throw ''
              zornlib.nixosConfigurationsFromDirectory: Unsupported file type ${type} at path ${toString path}
            ''
        ) (builtins.readDir directory);
    in
    {
      nixosSystem,
      directory,
      callNixosSystem ? _: path: nixosSystem { modules = [ path ]; },
      recursionDepth ? 1,
      ...
    }@args:
    let
      defaultPath = append directory "configuration.nix";
    in
    if pathExists defaultPath then
      # if `${directory}/configuration.nix` exists, call it directly
      callNixosSystem (builtins.baseNameOf directory) defaultPath
    else
      processDir (args // { inherit callNixosSystem recursionDepth; });
in
{
  zornlib = {

    # Get a map from file name (with the .nix extension removed) to full path of the .nix file
    # Only considers top-level files
    nixFilesToAttrset =
      dir:
      mapAttrs' (n: _: {
        name = removeSuffix ".nix" n;
        value = dir + "/${n}";
      }) ((filterAttrs isNixFile) (readDir dir));

    # Get a list of all Nix files withing a folder, recursively traversing all its subdirs
    nixFilesToListRecursive =
      dir: lib.lists.filter (lib.strings.hasSuffix ".nix") (lib.filesystem.listFilesRecursive dir);

    inherit nixosConfigurationsFromDirectory;
  };
}
// lib
