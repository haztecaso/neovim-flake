{ pkgs, ... }: {
  startPlugins = with pkgs.vimPlugins; [
    ChatGPT-nvim
    nui-nvim
    plenary-nvim
    telescope-nvim
  ];
  extraPackages = [ pkgs.pass ];
}
