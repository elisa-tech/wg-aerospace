The Nix based tool chain assumes the `flake.nix` to be in the repo root. The `workflow` symlinks in this dir helps to make it able to
update/format the `.github/workflow/{meta,nix}.yaml` files:

1. The AvioNix demo can stay mostly self-contained in a subdir
2. The exception to this are the two GitHub Actions workflow files, which have to be in `$PRJ_ROOT/.github/workflows`, as GitHub Actions does not follow symlinks
3. For the `update-ci` helper, everything within the `AvioNix-demo` dir appears as if that was in the repo's root dir (via the `AvioNix-demo/.github/workflows -> ../../../.github/workflows` symlink)
