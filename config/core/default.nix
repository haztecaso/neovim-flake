{ pkgs, ... }: {
  imports = with builtins;
    map (fn: ./${fn})
      (filter (fn: fn != "default.nix") (attrNames (readDir ./.)));
  clipboard.providers.xsel.enable = true;

  plugins = {
    commentary.enable = true;
    lastplace.enable = true;
    nix.enable = true;
    nvim-autopairs.enable = true;
    nvim-colorizer.enable = true;
    repeat.enable = true;
    which-key.enable = true;
    gitsigns.enable = true;
  };

  extraPlugins = with pkgs.vimPlugins; [ vim-eunuch vim-visual-multi ];
}
