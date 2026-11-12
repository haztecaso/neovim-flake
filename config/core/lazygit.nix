{
  plugins.lazygit.enable = true;
  keymaps = [
    {
      mode = "n";
      key = "<leader>gg";
      action = "<cmd>LazyGit<CR>";
      options = {
        desc = "LazyGit (root dir)";
      };
    }
  ];

  extraConfigLua = ''
    require("telescope").load_extension("lazygit")

    -- lazygit.nvim returns to the window that launched it on exit. When a file
    -- was opened in a new tab meanwhile (nvim-remote preset), stay on that tab.
    local lazygit_tab
    vim.api.nvim_create_autocmd("TabNewEntered", {
      callback = function()
        if vim.g.lazygit_opened == 1 then
          lazygit_tab = vim.api.nvim_get_current_tabpage()
        end
      end,
    })
    vim.g.lazygit_on_exit_callback = function()
      local tab = lazygit_tab
      lazygit_tab = nil
      if tab and vim.api.nvim_tabpage_is_valid(tab) then
        vim.api.nvim_set_current_tabpage(tab)
      end
    end
  '';
}
