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

    # Plugins
    nvim-neoclip = { url = "github:AckslD/nvim-neoclip.lua"; flake = false; };
    nvim-which-key = { url = "github:folke/which-key.nvim"; flake = false; };
    telescope-repo = { url = "github:cljoly/telescope-repo.nvim"; flake = false; };
    vim-enuch = { url = "github:tpope/vim-eunuch"; flake = false;};
  };

  outputs = { self, nixpkgs, utils, neovim, ... }@inputs:
    let
      lib = import ./lib.nix;
      plugins = [
        "nvim-neoclip"
        "nvim-which-key"
        "telescope-repo"
        "vim-enuch"
      ];
      overlay = final: prev: {
        rnix-lsp = inputs.rnix-lsp.defaultPackage.${final.system};
        neovim-nightly = neovim.defaultPackage.${final.system};
        mkNeovim = config: lib.mkNeovim { inherit config; pkgs = final; };
        mkNeovimNightly = config: lib.mkNeovimNightly { inherit config; pkgs = final; };
        neovimPlugins = lib.mkPlugins { inherit inputs plugins; pkgs = final; };
        neovimBase = lib.mkNeovim { pkgs = final; };
        neovimWebDev = lib.mkNeovim {
          pkgs = final;
          config = {
            completion.enable = true;
            snippets.enable   = true;
            telescope.emable  = true;
            lsp = {
              enable    = true;
              lightbulb = true;
              languages = {
                bash       = true;
                css        = true;
                docker     = true;
                html       = true;
                json       = true;
                python     = true;
                typescript = true;
                yaml       = true;
              };
            };
          };
        };
        neovimFull = lib.mkNeovim {
          pkgs = final;
          config = {
            completion.enable = true;
            snippets.enable   = true;
            telescope.enable  = true;
            lsp = {
              enable    = true;
              lightbulb = true;
              languages = {
                bash       = true;
                clang      = true;
                css        = true;
                docker     = true;
                html       = true;
                json       = true;
                lean       = true;
                nix        = true;
                python     = true;
                tex        = true;
                typescript = true;
                vimscript  = true;
                yaml       = true;
              };
            };
          };
        };
        lean-language-server = (final.callPackage (import ./pkgs/lean-language-server) { nodejs = final."nodejs-18_x"; }).lean-language-server;
      };
    in
    {
      inherit overlay;
      hydraJobs = let
        system = "x86_64-linux";
        pkgs = import nixpkgs { inherit system; overlays = [ self.overlay ]; };
      in {
        neovimFull.${system} = pkgs.neovimFull;
        neovimBase.${system} = pkgs.neovimBase;
        neovimWebDev.${system} = pkgs.neovimWebDev;
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
          nativeBuildInputs = with pkgs; [ 
            packages.neovimFull 
            nodePackages.node2nix 
            packages.lean-language-server
          ];
        };
      }) // {
      };
}
