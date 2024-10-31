{ pkgs, ... }: {
  plugins = {
    lsp.servers.texlab.enable = true;
    vimtex = {
      enable = true;
      texlivePackage = pkgs.texlive.combined.scheme-full;
      settings = {
        quickfix_mode = 2;
        view_method = "zathura";
      };
    };
  };
  globals.maplocalleader = ",";
}
