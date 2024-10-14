{ pkgs, ... }:
{
  imports = [
    ./settings.nix
    ./keymaps.nix

    ./colorschemes/gruvbox.nix

    ./completion/cmp.nix
    ./completion/copilot.nix

    ./treesitter.nix
    ./lsp.nix
    ./conform.nix
    ./fidget.nix

    # ./git/fugitive.nix
    ./git/gitsigns.nix
    ./git/lazygit.nix

    ./snippets/luasnip.nix

    ./ui/lualine.nix
    ./ui/telescope.nix

    ./utils/ack.nix
    ./utils/vinegar.nix
    ./utils/undotree.nix
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

  extraPlugins = with pkgs.vimPlugins; [
    vim-eunuch
    vim-visual-multi
  ];
}
