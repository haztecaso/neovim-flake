{ config, lib, pkgs, ... }:
let
cfg = config.base;
in
{
  options.base = with lib; {
    disableArrows = mkOption {
      type = types.bool;
      description = "Set to prevent arrow keys from moving cursor";
    };
    basePlugins = mkOption {
      type = types.bool;
      description = "Base plugins";
    };
  };
  config = {
    base = with lib; {
      disableArrows = mkDefault false; 
    };

    startPlugins = with pkgs.vimPlugins; with pkgs.neovimPlugins; [
      vim-airline
    ];

    globals = {
      "airline#extensions#tabline#enabled" = "1";
      "airline_symbols_ascii" = "1";
    };

  };
}
