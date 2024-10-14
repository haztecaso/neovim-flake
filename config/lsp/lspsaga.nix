{
  plugins.lspsaga = {
    enable = true;
    beacon.enable = true;
    ui = {
      border = "rounded"; # One of none, single, double, rounded, solid, shadow
      codeAction = "💡"; # Can be any symbol you want 💡
    };
    hover = {
      openCmd = "!floorp"; # Choose your browser
      openLink = "gx";
    };
    diagnostic = {
      borderFollow = true;
      diagnosticOnlyCurrent = false;
      showCodeAction = true;
    };
    symbolInWinbar.enable = true;
    codeAction = {
      extendGitSigns = false;
      showServerName = true;
      onlyInCursor = true;
      numShortcut = true;
      keys = {
        exec = "<CR>";
        quit = [ "<Esc>" "q" ];
      };
    };
    lightbulb.enable = false;
    implement.enable = false;
    rename = {
      autoSave = false;
      keys = {
        exec = "<CR>";
        quit = [ "<C-k>" "<Esc>" ];
        select = "x";
      };
    };
    outline = {
      autoClose = true;
      autoPreview = false;
      closeAfterJump = true;
      layout = "normal"; # normal or float
      winPosition = "right"; # left or right
      keys = {
        jump = "e";
        quit = "q";
        toggleOrJump = "o";
      };
    };
    scrollPreview = {
      scrollDown = "<C-f>";
      scrollUp = "<C-b>";
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>cr";
      action = "<cmd>Lspsaga rename<CR>";
      options = {
        desc = "rename";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ca";
      action = "<cmd>Lspsaga code_action<CR>";
      options = {
        desc = "code action";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>cw";
      action = "<cmd>Lspsaga outline<CR>";
      options = {
        desc = "Outline";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "K";
      action = "<cmd>Lspsaga hover_doc<CR>";
      options = {
        desc = "Hover";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "gF";
      action = "<cmd>Lspsaga finder def+ref+imp<CR>";
      options = {
        desc = "Find definitions, references and implementations";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "gpt";
      action = "<cmd>Lspsaga peek_type_definition<CR>";
      options = {
        desc = "Peek type definition";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "gpd";
      action = "<cmd>Lspsaga peek_definition<CR>";
      options = {
        desc = "Peek definition";
        silent = true;
      };
    }
  ];
}
