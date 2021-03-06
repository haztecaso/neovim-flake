{ config, lib, pkgs, ... }:
let
  cfg = config;
  mkMappingOption = it: lib.mkOption ({
    default = { };
    type = with lib.types; attrsOf (nullOr str);
  } // it);
in
{
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

    startPlugins = mkOption {
      description = "List of plugins to startup";
      default = [ ];
      type = with types; listOf package;
    };

    optPlugins = mkOption {
      description = "List of plugins to optionally load";
      default = [ ];
      type = with types; listOf package;
    };

    globals = mkOption {
      default = { };
      description = "Set containing global variable values";
      type = types.attrs;
    };

    nnoremap = mkMappingOption { description = "Defines 'Normal mode' mappings"; };
    inoremap = mkMappingOption { description = "Defines 'Insert and Replace mode' mappings"; };
    vnoremap = mkMappingOption { description = "Defines 'Visual and Select mode' mappings"; };
    xnoremap = mkMappingOption { description = "Defines 'Visual mode' mappings"; };
    snoremap = mkMappingOption { description = "Defines 'Select mode' mappings"; };
    cnoremap = mkMappingOption { description = "Defines 'Command-line mode' mappings"; };
    onoremap = mkMappingOption { description = "Defines 'Operator pending mode' mappings"; };
    tnoremap = mkMappingOption { description = "Defines 'Terminal mode' mappings"; };

    nmap = mkMappingOption { description = "Defines 'Normal mode' mappings"; };
    imap = mkMappingOption { description = "Defines 'Insert and Replace mode' mappings"; };
    vmap = mkMappingOption { description = "Defines 'Visual and Select mode' mappings"; };
    xmap = mkMappingOption { description = "Defines 'Visual mode' mappings"; };
    smap = mkMappingOption { description = "Defines 'Select mode' mappings"; };
    cmap = mkMappingOption { description = "Defines 'Command-line mode' mappings"; };
    omap = mkMappingOption { description = "Defines 'Operator pending mode' mappings"; };
    tmap = mkMappingOption { description = "Defines 'Terminal mode' mappings"; };
  };

  config =
    let
      filterNonNull = mappings: lib.filterAttrs (name: value: value != null) mappings;
      globalsScript = lib.mapAttrsFlatten (name: value: "let g:${name}=${builtins.toJSON value}") (filterNonNull cfg.globals);

      matchCtrl = it: builtins.match "Ctrl-(.)(.*)" it;
      mapKeybinding = it:
        let groups = matchCtrl it; in if groups == null then it else "<C-${lib.toUpper (lib.head groups)}>${lib.head (lib.tail groups)}";
      mapVimBinding = prefix: mappings: lib.mapAttrsFlatten (name: value: "${prefix} ${mapKeybinding name} ${value}") (filterNonNull mappings);

      nnoremap = mapVimBinding "nnoremap" cfg.nnoremap;
      inoremap = mapVimBinding "inoremap" cfg.inoremap;
      vnoremap = mapVimBinding "vnoremap" cfg.vnoremap;
      xnoremap = mapVimBinding "xnoremap" cfg.xnoremap;
      snoremap = mapVimBinding "snoremap" cfg.snoremap;
      cnoremap = mapVimBinding "cnoremap" cfg.cnoremap;
      onoremap = mapVimBinding "onoremap" cfg.onoremap;
      tnoremap = mapVimBinding "tnoremap" cfg.tnoremap;

      nmap = mapVimBinding "nmap" cfg.nmap;
      imap = mapVimBinding "imap" cfg.imap;
      vmap = mapVimBinding "vmap" cfg.vmap;
      xmap = mapVimBinding "xmap" cfg.xmap;
      smap = mapVimBinding "smap" cfg.smap;
      cmap = mapVimBinding "cmap" cfg.cmap;
      omap = mapVimBinding "omap" cfg.omap;
      tmap = mapVimBinding "tmap" cfg.tmap;

    in
    {
      configRC = ''
        ${lib.concatStringsSep "\n" globalsScript}
        ${cfg.commonConfig}

        " Lua config from neovim module option `luaConfigRC`
        lua << EOF
            ${cfg.luaConfigRC}
        EOF

        " mappings from neovim module
        ${builtins.concatStringsSep "\n" nnoremap}
        ${builtins.concatStringsSep "\n" inoremap}
        ${builtins.concatStringsSep "\n" vnoremap}
        ${builtins.concatStringsSep "\n" xnoremap}
        ${builtins.concatStringsSep "\n" snoremap}
        ${builtins.concatStringsSep "\n" cnoremap}
        ${builtins.concatStringsSep "\n" onoremap}
        ${builtins.concatStringsSep "\n" tnoremap}
        ${builtins.concatStringsSep "\n" nmap}
        ${builtins.concatStringsSep "\n" imap}
        ${builtins.concatStringsSep "\n" vmap}
        ${builtins.concatStringsSep "\n" xmap}
        ${builtins.concatStringsSep "\n" smap}
        ${builtins.concatStringsSep "\n" cmap}
        ${builtins.concatStringsSep "\n" omap}
        ${builtins.concatStringsSep "\n" tmap}

        " https://stackoverflow.com/a/8462159
        function! EnsureDirExists (dir)
          if !isdirectory(a:dir)
            if exists("*mkdir")
              call mkdir(a:dir,'p')
              echo "Created directory: " . a:dir
            else
              echo "Please create directory: " . a:dir
            endif
          endif
        endfunction
      '';
    };

}
