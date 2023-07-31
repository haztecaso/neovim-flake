{ pkgs, ... }: {
  startPlugins = with pkgs.neovimPlugins; [
    copilot-lua
  ];
  extraPackages = [ pkgs.nodejs ];
}
