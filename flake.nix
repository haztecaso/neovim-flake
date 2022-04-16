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
    profiles = import ./profiles.nix;
  in {
    overlay = final: prev: {
      rnix-lsp = inputs.rnix-lsp.defaultPackage.${final.system};
      neovim-nightly = neovim.defaultPackage.${final.system};
      neovimPlugins = lib.mkNeovimPlugins { inherit inputs plugins; pkgs = final;};
      neovimBase = lib.mkNeovim { pkgs = final; config = profiles.base; };
      neovimFull = lib.mkNeovim { pkgs = final; config = profiles.full; };
    };
  } // utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs { inherit system; overlays = [self.overlay]; };
  in rec {
    packages = {
      neovimBase = pkgs.neovimBase;
      neovimFull = pkgs.neovimFull;
    };

    defaultPackage = packages.neovimFull;

    lib = {
      mkNeovim = config: lib.mkNeovim { inherit pkgs config; };
    };

    defaultApp = {
      type = "app";
      program = "${packages.neovimFull}/bin/nvim";
    };

    devShell = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [ packages.neovimFull ];
    };
  });
}
