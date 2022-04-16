{
  base = {
    gruvbox.enable = true;
  };

  full = {
    gruvbox.enable = true;
    lsp = {
      enable = true;
      lightbulb = true;
      languages = {
        bash       = true;
        clang      = true;
        css        = true;
        docker     = true;
        html       = true;
        json       = true;
        nix        = true;
        python     = true;
        tex        = true;
        typescript = true;
        vimscript  = true;
        yaml       = true;
      };
    };
    languages = {
      latex.enable = true;
    };
  };
}
