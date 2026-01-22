{ pkgs, ... }:
{
  extraPackages = with pkgs; [ nixfmt ];

  project.toggles.format_on_save = {
    key = "<leader>tf";
    desc = "Format on Save";
    default = "true";
    apply = ''
      function(enabled)
        vim.g.format_on_save_enabled = enabled
      end
    '';
  };

  plugins.conform-nvim = {
    enable = true;
    settings = {
      notifyOnError = true;
      format_on_save.__raw = ''
        function(bufnr)
          if vim.g.format_on_save_enabled == false then
            return false
          end
          return { lsp_fallback = true, timeout_ms = 500 }
        end
      '';
      formatters_by_ft = {
        python = [
          "isort"
          "black"
        ];
        nix = [ "nixfmt" ];
        lua = [ "stylua" ];
        rust = [ "rustfmt" ];
        java = [ "google-java-format" ];
        javascript = [
          "prettierd"
          "prettier"
        ];
        typescript = [
          "prettierd"
          "prettier"
        ];
        javascriptreact = [
          "prettierd"
          "prettier"
        ];
        typescriptreact = [
          "prettierd"
          "prettier"
        ];
        html = [
          "prettierd"
          "prettier"
        ];
        css = [
          "prettierd"
          "prettier"
        ];
        svelte = [
          "prettierd"
          "prettier"
        ];
        markdown = [
          "prettierd"
          "prettier"
        ];
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>cf";
      action = "<cmd>lua require('conform').format()<cr>";
      options = {
        silent = true;
        desc = "Format Buffer";
      };
    }
  ];
}
