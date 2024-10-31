{ pkgs, ... }: {
  plugins = {
    lsp = {
      enable = true;
      keymaps = {
        silent = true;
        lspBuf = {
          gd = {
            action = "definition";
            desc = "Goto Definition";
          };
          gr = {
            action = "references";
            desc = "Goto References";
          };
          gD = {
            action = "declaration";
            desc = "Goto Declaration";
          };
          gI = {
            action = "implementation";
            desc = "Goto Implementation";
          };
          gT = {
            action = "type_definition";
            desc = "Type Definition";
          };
        };
        diagnostic = {
          "<leader>cd" = {
            action = "open_float";
            desc = "Line Diagnostics";
          };
          "[d" = {
            action = "goto_next";
            desc = "Next Diagnostic";
          };
          "]d" = {
            action = "goto_prev";
            desc = "Previous Diagnostic";
          };
        };
      };
      servers = {
        efm.enable = true;
        bashls.enable = true;
        clangd = {
          enable = true;
          filetypes = [ "c" "cpp" "objc" "objcpp" ];
        };
        cssls.enable = true;
        dockerls.enable = true;
        html.enable = true;
        jsonls.enable = true;
        # leanls.enable = true; #TODO: configure with lean plugin?
        lua_ls = {
          enable = true;
          settings = {
            completion.callSnippet = "Both";
            diagnostics.globals = [ "vim" ];
            hint.enable = true;
            telemetry.enable = false;
            workspace.library = [ "vim.api.nvim_get_runtime_file('', true)" ];
          };
        };
        nil_ls.enable = true;
        nixd.enable = true;
        phpactor.enable = true;
        pyright.enable = true;
        prolog_ls = {
          enable = true;
          package = null; # TODO: find nix prolog lsp package
        };
        texlab.enable = true;
        ts_ls.enable = true;
        yamlls.enable = true;
      };
    };
    lsp-format.enable = true;
    efmls-configs = {
      enable = true;
      setup = {
        all.linter = [ "vale" "codespell" ];
        lua.formatter = "lua_format";
        lua.linter = "luacheck";
        nix.formatter = "nixfmt";
        nix.linter = "statix";
        python.formatter = [ "black" "isort" ];
      };
    };
  };
  extraPlugins = [ pkgs.vimPlugins.goto-preview ];
  extraConfigLua = ''
    require('goto-preview').setup {
        width = 120,
        height = 15,
        preview_window_title = { enable = true, position = "left" },
        default_mappings = true
    }
  '';
}
