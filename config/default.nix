{ pkgs, ... }:
{
  imports = [
    ./settings.nix
    ./keymaps.nix

    ./colorschemes/gruvbox.nix

    ./completion/cmp.nix
    ./completion/copilot.nix

    ./treesitter.nix

    # ./git/fugitive.nix
    ./git/gitsigns.nix
    ./git/lazygit.nix

    ./snippets/luasnip.nix

    ./ui/lualine.nix
    ./ui/telescope.nix

    ./utils/ack.nix
    ./utils/vinegar.nix
  ];

  clipboard.providers.xsel.enable = true;

  plugins = {
    which-key.enable = true;
    commentary.enable = true;
    lastplace.enable = true;
    nix.enable = true;
    repeat.enable = true;
  };

  extraPlugins = with pkgs.vimPlugins; [
    vim-eunuch
    vim-visual-multi
  ];
}
