{ pkgs, ... }: {
  imports = [
    ./settings.nix
    ./keymaps.nix

    ./colorschemes/gruvbox.nix

    ./completion/cmp.nix
    ./completion/copilot.nix
    ./completion/schemastore.nix

    ./treesitter.nix
    ./lsp/lsp.nix
    ./lsp/conform.nix
    ./lsp/fidget.nix

    ./chatgpt.nix

    # ./git/fugitive.nix
    ./git/gitsigns.nix
    ./git/lazygit.nix

    ./snippets/luasnip.nix

    ./ui/lualine.nix
    ./ui/telescope.nix

    ./utils/ack.nix
    ./utils/vinegar.nix
    ./utils/undotree.nix
    ./utils/nvterm.nix
  ];

  clipboard.providers.xsel.enable = true;

  plugins = {
    commentary.enable = true;
    lastplace.enable = true;
    nix.enable = true;
    nvim-autopairs.enable = true;
    nvim-colorizer.enable = true;
    repeat.enable = true;
    which-key.enable = true;
  };

  extraPlugins = with pkgs.vimPlugins; [ vim-eunuch vim-visual-multi ];
}
