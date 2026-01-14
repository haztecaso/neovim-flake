{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixvim, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      imports = [ inputs.flake-parts.flakeModules.easyOverlay ];

      perSystem = { config, pkgs, system, ... }:
        let
          nixvimLib = nixvim.lib.${system};
          mkModule = imports: {
            imports = builtins.map (input: ./config/${input}) imports;
          };
          nvimPackage = imports:
            nixvim.legacyPackages.${system}.makeNixvimWithModule {
              inherit pkgs;
              module = mkModule imports;
            };
          coreModules = [ "settings.nix" "core" ];
          fullModules = coreModules ++ [ "full" ];
          latexModules = fullModules ++ [ "latex.nix" ];
          startupCheckLua = pkgs.writeText "nvim-startup-check.lua" ''
            vim.schedule(function()
              local output = vim.api.nvim_exec2('messages', { output = true }).output or ""
              local trimmed = vim.fn.trim(output)
              if trimmed ~= "" then
                vim.api.nvim_err_writeln("Unexpected Neovim startup messages:\n" .. trimmed)
                vim.cmd("cquit 1")
              else
                vim.cmd("cquit 0")
              end
            end)
          '';
        in {
          packages = {
            default = nvimPackage coreModules;
            full = nvimPackage fullModules;
            latex = nvimPackage latexModules;
          };

          overlayAttrs = { nvim = { inherit (config.packages) core full; }; };

          checks = {
            default = nixvimLib.check.mkTestDerivationFromNixvimModule {
              inherit pkgs;
              module = mkModule fullModules;
            };
            core = nixvimLib.check.mkTestDerivationFromNixvimModule {
              inherit pkgs;
              module = mkModule coreModules;
            };
            full = nixvimLib.check.mkTestDerivationFromNixvimModule {
              inherit pkgs;
              module = mkModule fullModules;
            };
            latex = nixvimLib.check.mkTestDerivationFromNixvimModule {
              inherit pkgs;
              module = mkModule latexModules;
            };
            startup =
              pkgs.runCommand "nvim-full-startup-clean" { } ''
                set -euo pipefail
                export HOME=$PWD/home
                export XDG_STATE_HOME=$HOME/.local/state
                export XDG_CACHE_HOME=$HOME/.cache
                export XDG_DATA_HOME=$HOME/.local/share
                export XDG_RUNTIME_DIR=$HOME/.local/run
                mkdir -p "$XDG_STATE_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME" "$XDG_RUNTIME_DIR"
                ${nvimPackage fullModules}/bin/nvim --headless "+luafile ${startupCheckLua}"
                touch $out
              '';
          };

          formatter = pkgs.nixfmt-rfc-style;
        };
    };
}
