{ pkgs, ... }: {
  plugins = {
    treesitter = {
      enable = true;
      grammarPackages = pkgs.vimPlugins.nvim-treesitter.passthru.allGrammars;
      settings = {
        auto_install = false;
        ensure_installed = [ ];
        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<CR>";
            scope_incremental = "<CR>";
            node_incremental = "<TAB>";
            node_decremental = "<S-TAB>";
          };
        };
      };
    };
    treesitter-textobjects = {
      enable = true;
      settings = {
        select = {
          enable = true;
          keymaps = {
            "af" = {
              query_group = "@function.outer";
              desc = "select outer part of function";
            };
            "if" = {
              query_group = "@function.inner";
              desc = "select inner part of function";
            };
            "ac" = {
              query_group = "@class.outer";
              desc = "select outer part of class";
            };
            "ic" = {
              query_group = "@class.outer";
              desc = "select outer part of class";
            };
            "s" = {
              query_group = "@scope";
              desc = "select language scope";
            };
          };
        };
      };
    };
  };
}
