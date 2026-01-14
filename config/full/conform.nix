{ pkgs, ... }: {
  extraPackages = with pkgs; [ nixfmt ];
  plugins.conform-nvim = {
    enable = true;
    settings = {
      notifyOnError = true;
      format_on_save = {
        lsp_fallback = true;
        timeout_ms = 500;
      };
      formatters_by_ft = {
        python = [ "isort" "black" ];
        nix = [ "nixfmt" ];
        lua = [ "stylua" ];
        rust = [ "rustfmt" ];
        java = [ "google-java-format" ];
        javascript = [ "prettierd" "prettier" ];
        typescript = [ "prettierd" "prettier" ];
        javascriptreact = [ "prettierd" "prettier" ];
        typescriptreact = [ "prettierd" "prettier" ];
        html = [ "prettierd" "prettier" ];
        css = [ "prettierd" "prettier" ];
        svelte = [ "prettierd" "prettier" ];
        markdown = [ "prettierd" "prettier" ];
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>uf";
      action = ":FormatToggle<CR>";
      options = {
        desc = "Toggle Format";
        silent = true;
      };
    }
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
