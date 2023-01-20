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
          local cmp_ultisnips_mappings = require 'cmp_nvim_ultisnips.mappings'

      	  cmp.setup {
      		snippet = {
      		  expand = function(args)
                vim.fn["UltiSnips#Anon"](args.body)
      		  end,
      		},
      		mapping = {
              ["<Tab>"] = cmp.mapping(
                function(fallback)
                  cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
                end,
                { "i", "s", }
              ),
              ["<S-Tab>"] = cmp.mapping(
                function(fallback)
                  cmp_ultisnips_mappings.jump_backwards(fallback)
                end,
                { "i", "s", }
              ),
      		  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      		  ['<C-f>'] = cmp.mapping.scroll_docs(4),
      		  ['<C-Space>'] = cmp.mapping.complete(),
      		  ['<C-e>'] = cmp.mapping.abort(),
      		  ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      		},
      		sources = {
      		  { name = 'ultisnips' },
      		  { name = 'nvim_lsp' },
      		  { name = 'path' },
              { name = 'buffer',
                option = {
                  get_bufnrs = function()
                    return vim.api.nvim_list_bufs()
                  end
                }
              },
      		},
            view = {
              entries = {name = 'custom', selection_order = 'near_cursor' }
            },
      	  }
    '';
  };
}
