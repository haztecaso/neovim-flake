{
  description = "Neovim configurations for different environments.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";

    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "utils";
      };
    };

    rnix-lsp = {
      url = "github:nix-community/rnix-lsp";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "utils";
      };
    };

    # Vim plugins
    nvim-which-key = { url = "github:folke/which-key.nvim"; flake = false; };

  };

  outputs = { self, nixpkgs, utils, neovim, ... }@inputs:
    let
      lib = import ./lib.nix;
      mkNeovim = lib.mkNeovim;
      mkNeovimPlugins = lib.mkNeovimPlugins;
      plugins = [
        "nvim-which-key"
      ];
      overlay = final: prev: {
        rnix-lsp = inputs.rnix-lsp.defaultPackage.${final.system};
        neovim-nightly = neovim.defaultPackage.${final.system};
        mkNeovim = config: mkNeovim { inherit config; pkgs = final; };
        neovimPlugins = mkNeovimPlugins { inherit inputs plugins; pkgs = final; };
        neovimBase = mkNeovim { };
        neovimWebDev = mkNeovim {
          pkgs = final;
          config = {
            completion.enable = true;
            snippets.enable = true;
            lsp = {
              enable = true;
              lightbulb = true;
              languages = {
                bash = true;
                css = true;
                docker = true;
                html = true;
                json = true;
                python = true;
                typescript = true;
                yaml = true;
              };
            };
          };
        };
        neovimFull = mkNeovim {
          pkgs = final;
          config = {
            completion.enable = true;
            snippets.enable = true;
            lsp = {
              enable = true;
              lightbulb = true;
              languages = {
                bash = true;
                clang = true;
                css = true;
                docker = true;
                html = true;
                json = true;
                lean = false;
                nix = true;
                python = true;
                tex = true;
                typescript = true;
                vimscript = true;
                yaml = true;
              };
            };
          };
        };
        lean-language-server = (final.callPackage (import ./lean-language-server) { nodejs = final."nodejs-12_x"; }).lean-language-server;
      };
    in
    {
      inherit overlay;
      hydraJobs = let
        system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system; overlays = [ self.overlay ]; };
      in {
        # neovimFull.${system} = pkgs.neovimFull;
        neovimBase.${system} = pkgs.neovimBase;
        neovimBase.${system} = pkgs.neovimWebDev;
      };
    } // utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; overlays = [ self.overlay ]; };
      in
      rec {
        packages = {
          neovimBase = pkgs.neovimBase;
          neovimFull = pkgs.neovimFull;
          neovimWebDev = pkgs.neovimWebDev;
          lean-language-server = pkgs.lean-language-server;
          default = packages.neovimFull;
        };


        apps.default = {
          type = "app";
          program = "${packages.neovimFull}/bin/nvim";
        };

        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [ packages.neovimFull nodePackages.node2nix ];
        };
      }) // {
      };
}
