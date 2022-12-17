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

    leader = mkOption {
      description = "nvim mapleader";
      type = types.str;
      default = ",";
    };

    localleader = mkOption {
      description = "nvim maplocalleader";
      type = types.str;
      default = ";";
    };

    updatetime = mkOption {
      type = types.int;
      description = "Set updatetime (milliseconds)";
      default = 100;
    };

    lineNumberMode = mkOption {
      type = with types; enum [ "relative" "number" "relNumber" "none" ];
      description = "How line numbers are displayed. none, relative, number, relNumber";
      default = "number";
    };

    cursorline = mkOption {
      type = types.bool;
      description = "Set cursorline.";
      default = true;
    };

    splitNatural = mkOption {
      type = types.bool;
      description = "New splits will open below instead of on top and to the right instead of to the left.";
      default = true;
    };

    tab = {
      width = mkOption {
        type = types.int;
        description = "Set the width of tabs";
        default = 4;
      };
      expand = mkOption {
        type = types.bool;
        description = "Enable tab expansion";
        default = true;
      };
      smart = mkOption {
        type = types.bool;
        description = "Enable smart tabs";
        default = true;
      };
    };

    indent = {
      auto = mkOption {
        type = types.bool;
        description = "Enable auto indent";
        default = true;
      };
      smart = mkOption {
        type = types.bool;
        description = "Enable smart indent";
        default = true;
      };
    };

    backup = {
      enable = mkOption {
        type = types.bool;
        description = "Enable nvim backup.";
        default = true;
      };
      dir = mkOption {
        type = types.str;
        description = "Backup directory (relative to $HOME)";
        default = ".local/share/nvim/backup/";
      };
    };

    swap = {
      enable = mkOption {
        type = types.bool;
        description = "Enable nvim swap.";
        default = true;
      };
      dir = mkOption {
        type = types.str;
        description = "Swap directory (relative to $HOME)";
        default = ".local/share/nvim/swap/";
      };
    };

    undo = {
      enable = mkOption {
        type = types.bool;
        description = "Enable nvim undo.";
        default = true;
      };
      dir = mkOption {
        type = types.str;
        description = "Undo directory (relative to $HOME)";
        default = ".local/share/nvim/undo/";
      };
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

    mapWindowMovements = mkOption {
      type = types.bool;
      description = "Map <C-j>, <C-k>, <C-h> and <C-l> to window movements.";
      default = true;
    };
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

      writeIf = cond: msg: if cond then msg else "";
      toString = builtins.toString;
    in
    {
      configRC = ''
        ${lib.concatStringsSep "\n" globalsScript}
        ${cfg.commonConfig}

        let mapleader = "${cfg.leader}"
        let maplocalleader = "${cfg.localleader}"

        set tabstop=${toString cfg.tab.width}
        set shiftwidth=${toString cfg.tab.width}
        set softtabstop=${toString cfg.tab.width}
        ${writeIf cfg.tab.smart "set smarttab"}
        ${writeIf cfg.tab.expand "set expandtab"}

        ${writeIf cfg.indent.auto "set autoindent"}
        ${writeIf cfg.indent.smart "set smartindent"}

        ${writeIf (cfg.lineNumberMode == "relative") "set relativenumber"}
        ${writeIf (cfg.lineNumberMode == "number") "set number"}
        ${writeIf (cfg.lineNumberMode == "relNumber") "set number relativenumber"}

        ${writeIf cfg.cursorline "set cursorline"}

        ${writeIf cfg.splitNatural "set splitbelow splitright"}


        " Lua config from neovim module option `luaConfigRC`
        lua << EOF
            ${cfg.luaConfigRC}
        EOF

        set updatetime=${toString cfg.updatetime}

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

        ${writeIf cfg.mapWindowMovements ''
          map <C-j> <C-W>j
          map <C-k> <C-W>k
          map <C-h> <C-W>h
          map <C-l> <C-W>l
        ''}

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
        ${writeIf cfg.backup.enable ''
          call EnsureDirExists($HOME . '/${cfg.backup.dir}')
          set backupdir=~/${cfg.backup.dir}
        ''}
        ${writeIf cfg.swap.enable ''
          call EnsureDirExists($HOME . '/${cfg.swap.dir}')
          set directory=~/${cfg.swap.dir}
        ''}
        ${writeIf cfg.undo.enable ''
          set undofile
          call EnsureDirExists($HOME . '/${cfg.undo.dir}')
          set undodir=~/${cfg.undo.dir}
        ''}
      '';
    };

}
