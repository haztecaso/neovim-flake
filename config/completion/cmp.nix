{
  plugins = {
    cmp-nvim-lsp.enable = true;
    cmp-buffer.enable = true;
    copilot-cmp.enable = true;
    cmp-path.enable = true;
    cmp-nvim-ultisnips.enable = true;
    cmp-cmdline.enable = true;
    cmp-latex-symbols.enable = true;
    cmp = {
      enable = true;
      autoEnableSources = false;
      settings = {
        experimental.ghost_text = true;
        sources.__raw = ''
          cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'copilot' },
            { name = 'path' },
            { name = 'ultisnips' },
            { name = 'cmdline' },
            { name = 'latex_symbols' },
            { name = 'buffer', option = {
              get_bufnrs = function() return vim.api.nvim_list_bufs() end 
            }},
          })
        '';
        snippet.expand = "function(args) vim.fn['UltiSnips#Anon'](args.body) end";
        mapping.__raw = ''
          cmp.mapping.preset.insert({
            ["<Tab>"] = cmp.mapping(
                function(fallback)
                    -- cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
                    cmp_ultisnips_mappings.jump_forwards(fallback)
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
            -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            ['<CR>'] = cmp.mapping.confirm({ select = true }), 
          })
        '';
      };
    };
  };
  extraConfigLuaPre = ''
    local cmp = require 'cmp'
    cmp_ultisnips_mappings = require 'cmp_nvim_ultisnips.mappings'

    cmp.setup.cmdline('/', {
        completion = { autocomplete = false },
        sources = {
            -- { name = 'buffer' }
            { name = 'buffer', opts = { keyword_pattern = [=[[^[:blank:]].*]=] } }
        }
    })

    cmp.setup.cmdline(':', {
        completion = { autocomplete = false },
        sources = cmp.config.sources({
            { name = 'path' }
            }, {
            { name = 'cmdline' }
        })
    })
  '';
}
