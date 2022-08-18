{ pkgs, ... }:
{

  imports = [
    ./core.nix
    ./completion.nix
    ./gruvbox.nix
    ./lsp.nix
    ./plugins.nix
    ./snippets.nix
  ];

  startPlugins = with pkgs.vimPlugins; with pkgs.neovimPlugins; [
    vim-airline
  ];

  globals = {
    "airline#extensions#tabline#enabled" = "1";
    "airline_symbols_ascii" = "1";
  };

  nmap = {
    "<leader><Space>" = ":nohlsearch<cr>";
    "<leader>o" = "<C-W>\\|<C-W>_";
    "<leader>i" = "<C-W>=";
    "<leader>s" = ":setlocal spell!";
    "<leader>p" = ":setlocal paste!";
    "<C-n>" = "gt";
    "<C-b>" = "gT";
  };

}
