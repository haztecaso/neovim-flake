{ config, lib, pkgs, ... }:
let
  cfg = config;
  wrapLuaConfig = luaConfig: ''
    lua << EOF
    ${luaConfig}
    EOF
  '';
  mkMappingOption = it: lib.mkOption ({
    default = { };
    type = with lib.types; attrsOf (nullOr str);
  } // it);
in {
  options = with lib; {
    commonConfig = mkOption {
      description = "Common config";
      type = types.lines;
      default = builtins.readFile ../common.vim;
    };

    configRC = mkOption {
      description = "vimrc contents";
      type = types.lines;
      default = "";
    };

    luaConfigRC = mkOption {
      description = "vim lua config";
      type = types.lines;
      default = "";
    };

    leader = mkOption {
      description = "nvim mapleader";
      type = types.str;
      default = ",";
    };

    localleader = mkOption {
      description = "nvim maplocalleader";
      type = types.str;
      default = ".";
    };

    startPlugins = mkOption {
      description = "List of plugins to startup";
      default = [ ];
      type = with types; listOf package;
    };

    optPlugins = mkOption {
      description = "List of plugins to optionally load";
      default = [ ];
      type =  with types; listOf package;
    };

    globals = mkOption {
      default = {};
      description = "Set containing global variable values";
      type = types.attrs;
    };

    nnoremap = mkMappingOption {
      description = "Defines 'Normal mode' mappings";
    };

  };

  imports = [
    ./gruvbox.nix
    ./base.nix
    ./lsp.nix
    ./latex.nix
    ./completion.nix
  ];

  config = let
    filterNonNull = mappings: lib.filterAttrs (name: value: value != null) mappings;
    globalsScript = lib.mapAttrsFlatten(name: value: "let g:${name}=${builtins.toJSON value}") (filterNonNull cfg.globals);

    matchCtrl = it: builtins.match "Ctrl-(.)(.*)" it;
    mapKeybinding = it:
      let groups = matchCtrl it; in if groups == null then it else "<C-${lib.toUpper (lib.head groups)}>${lib.head (lib.tail groups)}";
      mapVimBinding = prefix: mappings: lib.mapAttrsFlatten (name: value: "${prefix} ${mapKeybinding name} ${value}") (filterNonNull mappings);

    nnoremap = mapVimBinding "nnoremap" config.nnoremap;
  in {
    configRC = ''
      let mapleader = "${cfg.leader}"
      let maplocalleader = "${cfg.localleader}"
      ${cfg.commonConfig}
      ${wrapLuaConfig cfg.luaConfigRC}
      ${lib.concatStringsSep "\n" nnoremap}
      ${lib.concatStringsSep "\n" globalsScript}
    '';
  };

}
