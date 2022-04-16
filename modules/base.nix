{ config, lib, pkgs, ... }:
let
  cfg = config.base;
in
{
  options.base = with lib; {

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

    mapWindowMovements = mkOption {
      type = types.bool;
      description = "Map <C-j>, <C-k>, <C-h> and <C-l> to window movements.";
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

  };
  config = {

    startPlugins = with pkgs.vimPlugins; with pkgs.neovimPlugins; [
      vim-airline
    ];

    configRC =
      let
        writeIf = cond: msg: if cond then msg else "";
        toString = builtins.toString;
      in
      ''
        syntax on
        let mapleader = "${cfg.leader}"
        let maplocalleader = "${cfg.localleader}"

        set updatetime=${toString cfg.updatetime}

        ${writeIf cfg.cursorline "set cursorline"}

        ${writeIf (cfg.lineNumberMode == "relative") "set relativenumber"}
        ${writeIf (cfg.lineNumberMode == "number") "set number"}
        ${writeIf (cfg.lineNumberMode == "relNumber") "set number relativenumber"}

        ${writeIf cfg.splitNatural "set splitbelow splitright"}

        ${writeIf cfg.indent.auto "set autoindent"}
        ${writeIf cfg.indent.smart "set smartindent"}

        set tabstop=${toString cfg.tab.width}
        set shiftwidth=${toString cfg.tab.width}
        set softtabstop=${toString cfg.tab.width}
        ${writeIf cfg.tab.smart "set smarttab"}
        ${writeIf cfg.tab.expand "set expandtab"}

        ${writeIf cfg.mapWindowMovements ''
          map <C-j> <C-W>j
          map <C-k> <C-W>k
          map <C-h> <C-W>h
          map <C-l> <C-W>l
        ''}

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

    globals = {
      "airline#extensions#tabline#enabled" = "1";
      "airline_symbols_ascii" = "1";
    };

    vim.nmap = {
      "<leader><Space>" = ":nohlsearch<cr>";
      "<leader>o" = "<C-W>\|<C-W>_";
      "<leader>i" = "<C-W>=";
      "<leader>s" = ":setlocal spell!";
      "<leader>p" = ":setlocal paste!";
      "<C-n>" = "gt";
      "<C-b>" = "gT";
    };

  };
}
