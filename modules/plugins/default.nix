{ config, lib, pkgs, ... }:
let
  cfg = config.plugins;
  optionalFile = path:
    if builtins.pathExists path then builtins.readFile path
    else "";
  importConfig = name:
    let
      path = if builtins.pathExists ./${name} then ./${name} else ./${name}.nix;
      configRC = optionalFile ./${name}/config.vim;
      luaConfigRC = optionalFile ./${name}/config.lua;
    in
    {
      inherit name;
      value = import path { inherit pkgs; }
        // lib.optionalAttrs (configRC != "") { inherit configRC; }
        // lib.optionalAttrs (luaConfigRC != "") { inherit luaConfigRC; };
    };
  importedConfigs = builtins.listToAttrs (map importConfig [
    "ChatGPT"
    "ack"
    "fugitive"
    "gitgutter"
    "gruvbox"
    "telescope"
    "toggleterm"
    "treesitter"
    "vimtex"
  ]);
  configs = importedConfigs // {
    commentary.startPlugins = [ pkgs.vimPlugins.vim-commentary ];
    enuch.startPlugins = [ pkgs.neovimPlugins.vim-enuch ];
    lastplace.startPlugins = [ pkgs.vimPlugins.vim-lastplace ];
    nix.startPlugins = [ pkgs.vimPlugins.vim-nix ];
    nvim-which-key.startPlugins = [ pkgs.neovimPlugins.nvim-which-key ];
    repeat.startPlugins = [ pkgs.vimPlugins.repeat ];
    vim-airline = {
      startPlugins = [ pkgs.vimPlugins.vim-airline ];
      globals = {
        "airline#extensions#tabline#enabled" = "1";
        "airline_symbols_ascii" = "1";
      };
    };
    vim-visual-multi.startPlugins = [ pkgs.vimPlugins.vim-visual-multi ];
    vinegar = {
      startPlugins = [ pkgs.vimPlugins.vim-vinegar ];
      globals = {
        "netrw_liststyle" = "3";
        "netrw_banner" = "0";
      };
    };
    tidal = {
      startPlugins = [ pkgs.vimPlugins.vim-tidal ];
      globals = {
        "tidal_target" = "terminal";
      };
    };
  };
in
{
  options.plugins = builtins.mapAttrs (name: _: lib.mkEnableOption "Wether to enable ${name}.") configs;
  config = lib.mkMerge (lib.mapAttrsToList (plugin: config: lib.mkIf cfg.${plugin} config) configs);
}
