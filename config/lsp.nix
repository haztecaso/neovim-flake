{ pkgs, ... }: {
  plugins = {
    lsp = {
    enable = true;
        # keymaps = {
        # silent = true;
        # lspBuf = {
        # gd = {
        #   action = "definition";
        #   desc = "Goto Definition";
        # };
        # gr = {
        #   action = "references";
        #   desc = "Goto References";
        # };
        # gD = {
        #   action = "declaration";
        #   desc = "Goto Declaration";
        # };
        # gI = {
        #   action = "implementation";
        #   desc = "Goto Implementation";
        # };
        # gT = {
        #   action = "type_definition";
        #   desc = "Type Definition";
        # };
        # K = {
        #   action = "hover";
        #   desc = "Hover";
        # };
        # "<leader>cw" = {
        #   action = "workspace_symbol";
        #   desc = "Workspace Symbol";
        # };
        # "<leader>cr" = {
        #   action = "rename";
        #   desc = "Rename";
        # };
      # "<leader>ca" = {
        # action = "code_action";
        # desc = "Code Action";
      # };
      # "<C-k>" = {
        # action = "signature_help";
        # desc = "Signature Help";
      # };
      # };
      # diagnostic = {
        # "<leader>cd" = {
        #   action = "open_float";
        #   desc = "Line Diagnostics";
        # };
        # "[d" = {
        #   action = "goto_next";
        #   desc = "Next Diagnostic";
        # };
        # "]d" = {
        #   action = "goto_prev";
        #   desc = "Previous Diagnostic";
        # };
        # };
      # };
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
      lua-ls = {
        enable = true;
        settings = {
          completion.callSnippet = "Both";
          diagnostics.globals = [ "vim" ];
          hint.enable = true;
          telemetry.enable = false;
          workspace.library = ["vim.api.nvim_get_runtime_file('', true)"];
        };
      };
      nil-ls.enable = true;
      phpactor.enable = true;
      pyright.enable = true;
      prolog-ls.enable = true;
      texlab.enable = true;
      ts-ls.enable = true;
      yamlls.enable = true;
    };
  };
  lsp-format.enable = true;
  efmls-configs =  {
    enable = true;
    setup = {
      all.linter = [ "vale" "codespell" ];
      lua.formatter = "lua_format";
      lua.linter = "luacheck";
      nix.formatter = "nixfmt";
      nix.linter = "statix";
      python.formatter = ["black" "isort"];
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
