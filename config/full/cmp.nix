{
  plugins = {
    cmp-nvim-lsp.enable = true;
    cmp-buffer.enable = true;
    copilot-cmp.enable = true;
    cmp-path.enable = true;
    cmp_luasnip.enable = false;
    cmp-cmdline.enable = true;
    cmp-latex-symbols.enable = true;
    cmp = {
      enable = true;
      autoEnableSources = false;
      settings = {
        experimental.ghost_text = true;
        sources.__raw = ''
          cmp.config.sources({
            { name = 'copilot' },
            { name = 'nvim_lsp' },
            { name = 'path' },
            -- { name = 'luasnip' },
            { name = 'cmdline' },
            { name = 'latex_symbols' },
            -- { name = 'buffer', option = { get_bufnrs = function() return vim.api.nvim_list_bufs() end }},
          })
        '';
        # snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        mapping.__raw = ''
          cmp.mapping.preset.insert({
                ['<C-j>'] = cmp.mapping.select_next_item(),
                ['<C-k>'] = cmp.mapping.select_prev_item(),
                ['<C-e>'] = cmp.mapping.abort(),

                ['<C-b>'] = cmp.mapping.scroll_docs(-4),

                ['<C-f>'] = cmp.mapping.scroll_docs(4),

                ['<C-Space>'] = cmp.mapping.complete(),

                ['<S-CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),

                -- Taken from https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
                -- to stop interference between cmp and luasnip

                ['<CR>'] = cmp.mapping(function(fallback)
                      if cmp.visible() then
                       -- if luasnip.expandable() then
                       --     luasnip.expand()
                       -- else
                              cmp.confirm({
                                  select = true,
                              })
                       -- end
                      else
                          fallback()
                      end
                  end),

                ["<Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  -- elseif luasnip.locally_jumpable(1) then
                  --   luasnip.jump(1)
                  else
                    fallback()
                  end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  -- elseif luasnip.locally_jumpable(-1) then
                  --   luasnip.jump(-1)
                  else
                    fallback()
                  end
                end, { "i", "s" }),
              })
        '';
      };
    };
  };
  extraConfigLuaPre = ''
    local cmp = require 'cmp'

    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' },
        { name = 'buffer' }
      }, {
        {
          name = 'cmdline',
          option = {
            ignore_cmds = { 'Man', '!' }
          }
        }
      })
    })
  '';
}
