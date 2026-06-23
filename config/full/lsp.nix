{ pkgs, ... }:
{
  project.toggles.diagnostics = {
    key = "<leader>td";
    desc = "Diagnostic mode (full/compact/off)";
    modes = [ "full" "compact" "off" ];
    labels = {
      full = "full (lsp-lines)";
      compact = "compact (virtual_text)";
      off = "off";
    };
    default = "full";
    apply = ''
      function(mode)
        if mode == "compact" then
          vim.diagnostic.enable(true)
          vim.diagnostic.config({ virtual_lines = false, virtual_text = { prefix = "●", spacing = 2 } })
        elseif mode == "off" then
          vim.diagnostic.enable(false)
        else
          vim.diagnostic.enable(true)
          vim.diagnostic.config({ virtual_lines = true, virtual_text = false })
        end
      end
    '';
  };

  project.toggles.errors_only = {
    key = "<leader>te";
    desc = "Errors only";
    default = "false";
    apply = ''
      function(enabled)
        if enabled then
          local severity = { min = vim.diagnostic.severity.ERROR }
          vim.diagnostic.config({
            virtual_lines = { severity = severity },
            virtual_text = { severity = severity, prefix = "●" },
          })
        else
          local state = Project.load_state()
          Project.apply_toggle("diagnostics", state.diagnostics or "full")
        end
      end
    '';
  };

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
          filetypes = [
            "c"
            "cpp"
            "objc"
            "objcpp"
          ];
        };
        cssls.enable = true;
        dockerls.enable = true;
        html.enable = true;
        jsonls.enable = true;
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
        svelte = {
          enable = true;
          package = pkgs.svelte-language-server;
        };
        tinymist.enable = true;
        ts_ls.enable = true;
        yamlls.enable = true;
      };
    };
    lsp-format.enable = true;
    efmls-configs = {
      enable = true;
      languages = {
        all.linter = [ "vale" ];
        lua.linter = "luacheck";
        nix.linter = "statix";
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
