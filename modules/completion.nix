{ config, lib, pkgs, ... }:
let
  cfg = config.completion;
  filterNonNull = builtins.filter (x: x != null);
in
{
  options.completion = with lib; {
    enable = mkEnableOption "Wether to enable nvim-cmp";
  };
  config = lib.mkIf cfg.enable {
    startPlugins = with pkgs.vimPlugins; filterNonNull [
      cmp-buffer
      cmp-cmdline
      cmp-path
      cmp-latex-symbols
      nvim-cmp
    ];

    snippets.enable = true;

    configRC = ''
      set completeopt=menu,menuone,noselect
    '';

    luaConfigRC = ''
            local cmp = require 'cmp'

      	  cmp.setup {
      		snippet = {
      		  expand = function(args)
      			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      		  end,
      		},
      		mapping = {
      		  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      		  ['<C-f>'] = cmp.mapping.scroll_docs(4),
      		  ['<C-Space>'] = cmp.mapping.complete(),
      		  ['<C-e>'] = cmp.mapping.abort(),
      		  ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      		},
      		sources = {
      		  { name = 'nvim_lsp' },
      		  { name = 'vsnip' },
      		  { name = 'path' },
      		  { name = 'buffer' },
                { name = 'latex_symbols' },
      		},
              experimental = { native_menu = true, },
      	  }
    '';
  };
}
