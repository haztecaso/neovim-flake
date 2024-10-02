{ ... }: {
  plugins = {
    treesitter = {
      enable = true;
      settings = {
        # ensure_installed = "all";
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
      select = {
        enable = true;
        keymaps = {
          "af" = { query = "@function.outer"; desc = "select outer part of function"; };
          "if" = { query = "@function.inner"; desc = "select inner part of function"; };
          "ac" = { query = "@class.outer"; desc = "select outer part of class"; };
          "ic" = { query = "@class.outer"; desc = "select outer part of class"; };
          "s" = { query = "@scope"; desc = "select language scope"; };
        };
      };
    };
  };
}
