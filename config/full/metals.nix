{ pkgs, ... }: {
  extraPlugins = [ pkgs.vimPlugins.nvim-metals ];
  extraConfigLua = ''
    local metals = require ('metals');
    local metals_config = vim.tbl_deep_extend("force", metals.bare_config(), {
    })

    local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {"scala", "sbt"},
      callback = function()
        metals.initialize_or_attach(metals_config)
      end,
      group = nvim_metals_group,
    })
  '';
}
