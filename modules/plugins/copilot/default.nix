{ pkgs, ... }: {
  startPlugins = with pkgs.neovimPlugins; [
    copilot-lua
  ];
}
