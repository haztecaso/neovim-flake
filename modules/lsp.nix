{ config, lib, pkgs, ... }:
let
  cfg = config.lsp;
  filterNonNull = builtins.filter (x: x != null);
in
{
  options.lsp = with lib; {
    enable = mkEnableOption "Wether to enable LSP support";
    lightbulb = mkEnableOption "Enable Light Bulb";

    languages = {
      bash = mkEnableOption "Enable Bash Language support";
      clang = mkEnableOption "Enable C/C++ with clang";
      css = mkEnableOption "Enable css support";
      docker = mkEnableOption "Enable docker support";
      html = mkEnableOption "Enable html support";
      json = mkEnableOption "Enable JSON";
      lean = mkEnableOption "Enable lean support. NOT WORKING."; #TODO: Fix
      nix = mkEnableOption "Enable NIX Language support";
      python = mkEnableOption "Enable lsp python support";
      tex = mkEnableOption "Enable tex support";
      typescript = mkEnableOption "Enable Typescript/Javascript support";
      vimscript = mkEnableOption "Enable lsp vimscript support";
      yaml = mkEnableOption "Enable yaml support";
    };
  };

  config = lib.mkIf cfg.enable {
    startPlugins = with pkgs.vimPlugins; filterNonNull [
      nvim-lspconfig
      nvim-treesitter
      nvim-treesitter-context
      goto-preview
      (if cfg.lightbulb then nvim-lightbulb else null)
      (if cfg.languages.lean then lean-nvim else null)
      (if config.completion.enable then cmp-nvim-lsp else null)
    ];

    plugins.nix = if cfg.languages.nix then lib.mkForce true else lib.mkDefault true;

    configRC = ''
      " Use <Tab> and <S-Tab> to navigate through popup menu
      inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
      inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

      set foldmethod=expr
      set foldlevel=10
      set foldexpr=nvim_treesitter#foldexpr()
    '';

    nnoremap = {
      "K" = "<cmd>lua vim.lsp.buf.hover()<CR>";
      "gD" = "<cmd>lua vim.lsp.buf.declaration()<CR>";
      "gd" = "<cmd>lua vim.lsp.buf.definition()<CR>";
      "gi" = "<cmd>lua vim.lsp.buf.implementation()<CR>";
      "<leader>ca" = "<cmd>lua vim.lsp.buf.code_action()<cr>";
      "<leader>rn" = "<cmd>lua vim.lsp.buf.rename()<cr>";
      "<leader>f" = "<cmd>lua vim.lsp.buf.format()<CR>";
      "<leader>k" = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
      "<leader>j" = "<cmd>lua vim.diagnostic.goto_next()<CR>";
    };

    luaConfigRC = ''
      -- autoformat on save
      vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

      local wk = require("which-key")
      wk.register({
        K = {"Code hover"},
        g = {
          D = {"Go to declaration"},
          d = {"Go to definition"},
          i = {"Go to implementation"},
        }
      }, {});
      wk.register({
        ca = {"Code action"},
        rn = {"Code rename"},
        f  = {"Code format"},
        k  = {"Code go to previous error"},
        j  = {"Code go to next error"},
      },{ prefix = "<leader>" })


      local lspconfig = require'lspconfig'

      -- goto-preview config
      require('goto-preview').setup {
        width = 120,
        height = 15,
        preview_window_title = { enable = true, position = "left" },
        default_mappings = true
      }


      ${if cfg.lightbulb then ''
        require'nvim-lightbulb'.update_lightbulb {
          sign = {
            enabled = true,
            priority = 10,
          },
          float = {
            enabled = false,
            text = "💡",
            win_opts = {},
          },
          virtual_text = {
            enable = false,
            text = "💡",
          },
          status_text = {
            enabled = false,
            text = "💡",
            text_unavailable = ""           
          }
        }
      '' else ""}
      
      ${if config.completion.enable then ''
        local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
      '' else ""}

      lspconfig.efm.setup {
          ${if config.completion.enable then "capabilities = capabilities," else ""}
          cmd = { "${pkgs.efm-langserver}/bin/efm-langserver" },
          init_options = { documentFormatting = true },
          settings = {
              rootMarkers = { ".git/" },
              lintDebounce = 100,
              languages = {
                ${if cfg.languages.python then ''
                python = {
                    { formatCommand = "${pkgs.black}/bin/black -", formatStdin = true, },
                    { formatCommand = "${pkgs.isort}/bin/isort --stdout --profile black -", formatStdin = true, }
                },
                '' else ""}
              },
          },
      }

      ${if cfg.languages.bash then ''
        lspconfig.bashls.setup{
          ${if config.completion.enable then "capabilities = capabilities," else ""}
          cmd = {"${pkgs.nodePackages.bash-language-server}/bin/bash-language-server", "start"}
        }
      '' else ""}

      ${if cfg.languages.clang then ''
        lspconfig.clangd.setup{
          ${if config.completion.enable then "capabilities = capabilities," else ""}
          cmd = {'${pkgs.clang-tools}/bin/clangd', '--background-index'};
          filetypes = { "c", "cpp", "objc", "objcpp" };
        }
      '' else ""}

      ${if cfg.languages.css then ''
        lspconfig.cssls.setup{
          ${if config.completion.enable then "capabilities = capabilities," else ""}
          cmd = {'${pkgs.nodePackages.vscode-css-languageserver-bin}/bin/css-languageserver', '--stdio' };
          filetypes = { "css", "scss", "less" }; 
        }
      '' else ""}

      ${if cfg.languages.docker then ''
        lspconfig.dockerls.setup{
          ${if config.completion.enable then "capabilities = capabilities," else ""}
          cmd = {'${pkgs.nodePackages.dockerfile-language-server-nodejs}/bin/docker-language-server', '--stdio' }
        }
      '' else ""}

      ${if cfg.languages.html then ''
        lspconfig.html.setup{
          ${if config.completion.enable then "capabilities = capabilities," else ""}
          cmd = {'${pkgs.nodePackages.vscode-html-languageserver-bin}/bin/html-languageserver', '--stdio' };
          filetypes = { "html", "css", "javascript" }; 
        }
      '' else ""}

      ${if cfg.languages.json then ''
        lspconfig.jsonls.setup{
          ${if config.completion.enable then "capabilities = capabilities," else ""}
          cmd = {'${pkgs.nodePackages.vscode-json-languageserver-bin}/bin/json-languageserver', '--stdio' };
          filetypes = { "json", "html", "css", "javascript" }; 
        }
      '' else ""}

      ${if cfg.languages.lean then ''
       require('lean').setup {
           abbreviations = { builtin = true },
           lsp3 = { cmd = { '${pkgs.lean-language-server}/bin/lean-language-server', '--stdio', '-M', '4096' } },
           ft = { default = "lean3" },
           abbreviations = { leader=','},
           mappings = true,
       }
      '' else ""}

      ${if cfg.languages.nix then ''
        lspconfig.nil_ls.setup{
          ${if config.completion.enable then "capabilities = capabilities," else ""}
          autostart = true,
          cmd = {"${pkgs.nil}/bin/nil"},
          settings = {
            ['nil'] = {
              formatting = {
                command = { "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" };
              },
            },
          },
        }
      '' else ""}

      ${if cfg.languages.python then ''
        lspconfig.pyright.setup{
          ${if config.completion.enable then "capabilities = capabilities," else ""}
          cmd = {"${pkgs.nodePackages.pyright}/bin/pyright-langserver", "--stdio"}
        }
      '' else ""}

      ${if cfg.languages.tex then ''
        lspconfig.texlab.setup{
          ${if config.completion.enable then "capabilities = capabilities," else ""}
          cmd = {'${pkgs.texlab}/bin/texlab'}
        }
      '' else ""}

      ${if cfg.languages.typescript then ''
        lspconfig.tsserver.setup{
          ${if config.completion.enable then "capabilities = capabilities," else ""}
          cmd = {'${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server', '--stdio' }
        }
      '' else ""}

      ${if cfg.languages.vimscript then ''
        lspconfig.vimls.setup{
          ${if config.completion.enable then "capabilities = capabilities," else ""}
          cmd = {'${pkgs.nodePackages.vim-language-server}/bin/vim-language-server', '--stdio' }
        }
      '' else ""}

      ${if cfg.languages.yaml then ''
        lspconfig.vimls.setup{
          ${if config.completion.enable then "capabilities = capabilities," else ""}
          cmd = {'${pkgs.nodePackages.yaml-language-server}/bin/yaml-language-server', '--stdio' }
        }
      '' else ""}
    '';
  };
}
