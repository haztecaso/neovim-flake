{
  description = "Neovim configurations for different environments.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";

    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rnix-lsp = {
      url = "github:nix-community/rnix-lsp";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Vim plugins
    completion-nvim = { url = "github:nvim-lua/completion-nvim"; flake = false; };
    gruvbox = { url = "github:morhetz/gruvbox"; flake = false; };
    nvim-lightbulb = { url = "github:kosayoda/nvim-lightbulb"; flake = false; };
    nvim-lspconfig = { url = "github:neovim/nvim-lspconfig"; flake = false; };
    nvim-treesitter = { url = "github:nvim-treesitter/nvim-treesitter"; flake = false;};
    nvim-treesitter-context = { url = "github:romgrk/nvim-treesitter-context"; flake = false;};
    nvim-which-key = { url = "github:folke/which-key.nvim"; flake = false; };
    vim-nix = { url = "github:LnL7/vim-nix"; flake = false; };
  };

  outputs = { self, nixpkgs, utils, neovim, ... }@inputs: let
    lib = import ./lib.nix;
    plugins = [
      "completion-nvim"
      "gruvbox"
      "nvim-lightbulb"
      "nvim-lspconfig"
      "nvim-treesitter"
      "nvim-treesitter-context"
      "nvim-which-key"
      "vim-nix"
    ];
  in {
    overlay = final: prev: {
      rnix-lsp = inputs.rnix-lsp.defaultPackage.${final.system};
      neovim-nightly = neovim.defaultPackage.${final.system};
      neovimPlugins = lib.mkNeovimPlugins { inherit inputs plugins; pkgs = final;};
    };
  } // utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs { inherit system; overlays = [self.overlay]; };
    mkNeovim = config: lib.mkNeovim { inherit pkgs config; };
  in rec {
    packages = {
      neovimBase = mkNeovim {
        gruvbox.enable = true;
      };
      neovimFull = mkNeovim {
        gruvbox.enable = true;
        lsp = {
          enable = true;
          lightbulb = true;
          languages = {
            bash       = true;
            clang      = true;
            css        = true;
            docker     = true;
            html       = true;
            json       = true;
            nix        = true;
            python     = true;
            tex        = true;
            typescript = true;
            vimscript  = true;
            yaml       = true;
          };
        };
        languages = {
          latex.enable = true;
        };
      };
    };

    defaultPackage = packages.neovimFull;

    lib = { inherit mkNeovim; };

    defaultApp = {
      type = "app";
      program = "${packages.neovimFull}/bin/nvim";
    };

    devShell = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [ packages.neovimFull ];
    };
  });
}
