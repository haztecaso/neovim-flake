{ config, lib, pkgs, ... }:
{
  vim = {
    startPlugins = with pkgs.neovimPlugins; [ 
      nvim-which-key
    ];

    nnoremap = {
     "<leader>wc" = "<cmd>close<cr>";
     "<leader>wh" = "<cmd>split<cr>";
     "<leader>wv" = "<cmd>vsplit<cr>";
    };

    luaConfigRC = ''
      local wk = require("which-key")

      wk.register({
        w = {
          name = "window",
          c = { "Close Window"},
          h = { "Split Horizontal" },
          v = { "Split Vertical" },
        },
      }, { prefix = "<leader>" })
    '';
  };
}
