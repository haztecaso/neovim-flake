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

    tidal = { url = "github:mitchmindtree/tidalcycles.nix"; };

    # Plugins
    chatgpt = { url = "github:jackMort/ChatGPT.nvim"; flake = false; };
    nvim-neoclip = { url = "github:AckslD/nvim-neoclip.lua"; flake = false; };
    nvim-which-key = { url = "github:folke/which-key.nvim"; flake = false; };
    obsidian-nvim = { url = "github:epwalsh/obsidian.nvim"; flake = false; };
    telescope-repo = { url = "github:cljoly/telescope-repo.nvim"; flake = false; };
    vim-enuch = { url = "github:tpope/vim-eunuch"; flake = false; };
  };

  outputs = { self, nixpkgs, utils, neovim, ... }@inputs:
    let
      lib = import ./lib.nix;
      overlay = final: prev: {
        neovim-nightly = neovim.defaultPackage.${final.system};
        mkNeovim = config: lib.mkNeovim { inherit config; pkgs = final; };
        mkNeovimNightly = config: lib.mkNeovimNightly { inherit config; pkgs = final; };
        neovimPlugins = lib.mkPlugins {
          inherit inputs; plugins = [
          "chatgpt"
          "nvim-neoclip"
          "nvim-which-key"
          "obsidian-nvim"
          "telescope-repo"
          "vim-enuch"
        ];
          pkgs = final;
        };
        neovimDefault = lib.mkNeovim {
          pkgs = final;
          config = {
            completion.enable = true;
            snippets.enable = true;
            lsp = {
              enable = true;
              languages = {
                bash = true;
                clang = true;
                css = true;
                docker = true;
                html = true;
                json = true;
                lean = false;
                lua = true;
                nix = true;
                php = true;
                python = true;
                tex = true;
                typescript = true;
                vimscript = true;
                yaml = true;
              };
            };
            plugins = {
              ack = true;
              commentary = true;
              enuch = true;
              fugitive = true;
              gitgutter = true;
              gruvbox = true;
              lastplace = true;
              nix = true;
              repeat = true;
              telescope = true;
              tidal = false;
              toggleterm = true;
              treesitter = true;
              vim-airline = true;
              vim-visual-multi = true;
              vimtex = true;
              vinegar = true;
            };
          };
        };
        neovimBase = lib.mkNeovim {
          pkgs = final;
          config = {
            completion.enable = true;
            snippets.enable = true;
            lsp.enable = false;
            plugins = {
              ack = true;
              commentary = true;
              enuch = true;
              fugitive = true;
              gitgutter = true;
              gruvbox = true;
              lastplace = true;
              nix = true;
              repeat = true;
              telescope = false;
              tidal = false;
              toggleterm = true;
              treesitter = false;
              vim-airline = true;
              vim-visual-multi = true;
              vimtex = true;
              vinegar = true;
            };
          };
        };
        # neovimFull = lib.mkNeovim { pkgs = final; config = profiles.full; };
        lean-language-server = (final.callPackage (import ./pkgs/lean-language-server) { nodejs = final."nodejs-18_x"; }).lean-language-server;
      };
    in
    {
      inherit overlay;
      hydraJobs =
        let
          system = "x86_64-linux";
          pkgs = import nixpkgs { inherit system; overlays = [ self.overlay ]; };
        in
        {
          # neovimFull.${system} = pkgs.neovimFull;
          neovimBase.${system} = pkgs.neovimBase;
          neovimWebDev.${system} = pkgs.neovimWebDev;
        };
    } // utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; overlays = [ self.overlay inputs.tidal.overlays.default ]; };
      in
      rec {
        packages = {
          neovimBase = pkgs.neovimBase;
          # neovimFull = pkgs.neovimFull;
          neovimDefault = pkgs.neovimDefault;
          lean-language-server = pkgs.lean-language-server;
          default = packages.neovimDefault;
        };

        apps.default = {
          type = "app";
          program = "${packages.neovimDefault}/bin/nvim";
        };

        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            # packages.neovimFull
            nodePackages.node2nix
            packages.lean-language-server
          ];
        };
      });
}
