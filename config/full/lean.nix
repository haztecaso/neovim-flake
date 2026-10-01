{
  plugins.lean = {
    enable = true;
  };

  # Don't let nixvim pull in its own global pkgs.lean4 (nixpkgs build) onto
  # PATH ahead of each project's own toolchain (e.g. via direnv/flake.nix).
  # lean.nvim just runs bare `lake serve`/`lean --server`, so if nixvim's
  # global lean4 shadows the project one, they build .olean files with
  # different (incompatible) binaries, and whichever tool writes
  # .lake/build last invalidates the other's cache -> constant "please
  # rebuild" prompts. Disabling this makes lean.nvim resolve `lake`/`lean`
  # purely from PATH, i.e. whatever toolchain the shell nvim was launched
  # from provides.
  dependencies.lean.enable = false;
}
