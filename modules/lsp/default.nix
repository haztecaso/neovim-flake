{ config, lib, pkgs, ... }:
let
  cfg = config.lsp;
  languages = {
    bash = {
      extraPackages = [ pkgs.nodePackages.bash-language-server ];
      luaConfigRC = ''
        lspconfig.bashls.setup{
          capabilities = capabilities,
          cmd = {"bash-language-server", "start"}
        }
      '';
    };
    clang = {
      extraPackages = [ pkgs.clang-tools ];
      luaConfigRC = ''
        lspconfig.clangd.setup{
          capabilities = capabilities,
          cmd = {'clangd', '--background-index'};
          filetypes = { "c", "cpp", "objc", "objcpp" };
        }
      '';
    };
    css = {
      extraPackages = [ pkgs.nodePackages.vscode-css-languageserver-bin ];
      luaConfigRC = ''
        lspconfig.cssls.setup{
          capabilities = capabilities,
          cmd = {'css-languageserver', '--stdio' };
          filetypes = { "css", "scss", "less" }; 
        }
      '';
    };
    docker = {
      extraPackages = [ pkgs.nodePackages.dockerfile-language-server-nodejs ];
      luaConfigRC = ''
        lspconfig.dockerls.setup{
          capabilities = capabilities,
          cmd = {'docker-language-server', '--stdio' }
        }
      '';
    };
    html = {
      extraPackages = [ pkgs.nodePackages.vscode-html-languageserver-bin ];
      luaConfigRC = ''
        lspconfig.html.setup{
          capabilities = capabilities,
          cmd = {'html-languageserver', '--stdio' };
          filetypes = { "html", "css", "javascript" }; 
        }
      '';
    };
    json = {
      extraPackages = [ pkgs.nodePackages.vscode-json-languageserver-bin ];
      luaConfigRC = ''
        lspconfig.jsonls.setup{
          capabilities = capabilities,
          cmd = {'json-languageserver', '--stdio' };
          filetypes = { "json", "html", "css", "javascript" }; 
        }
      '';
    };
    lean = {
      startPlugins = [ pkgs.vimPlugins.lean-nvim ];
      extraPackages = [ pkgs.lean-language-server ];
      luaConfigRC = ''
        require('lean').setup {
            abbreviations = { builtin = true },
            lsp3 = { cmd = { 'lean-language-server', '--stdio', '-M', '4096' } },
            ft = { default = "lean3" },
            abbreviations = { leader=','},
            mappings = true,
        }
      '';
    };
    lua = {
      extraPackages = [ pkgs.lua-language-server pkgs.luaformatter ];
      luaConfigRC = ''
        require'lspconfig'.lua_ls.setup {
          settings = {
            Lua = {
              runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
              },
              diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'},
              },
              workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
              },
              -- Do not send telemetry data containing a randomized but unique identifier
              telemetry = {
                enable = false,
              },
            },
          },
        }
      '';
      lsp.efm = {
        enable = true;
        languageConfigs = ''
          lua = {
            formatCommand = 'lua-format -i --double-quote-to-single-quote',
            formatStdin = true
          },
        '';
      };
    };
    nix = {
      extraPackages = [ pkgs.nil pkgs.nixpkgs-fmt ];
      luaConfigRC = ''
        lspconfig.nil_ls.setup{
          capabilities = capabilities,
          autostart = true,
          cmd = {"${pkgs.nil}/bin/nil"},
          settings = {
            ['nil'] = {
              formatting = {
                command = { "nixpkgs-fmt" };
              },
            },
          },
        }
      '';
    };
    python = {
      extraPackages = [ pkgs.nodePackages.pyright pkgs.black pkgs.isort ];
      luaConfigRC = ''
        lspconfig.pyright.setup{
          capabilities = capabilities,
          cmd = {"pyright-langserver", "--stdio"}
        }
      '';
      lsp.efm = {
        enable = true;
        languageConfigs = ''
          python = {
            { formatCommand = "black -", formatStdin = true, },
            { formatCommand = "isort --stdout --profile black -", formatStdin = true, }
          },
        '';
      };
    };
    tex = {
      extraPackages = [ pkgs.texlab ];
      luaConfigRC = ''
        lspconfig.texlab.setup{
          capabilities = capabilities,
          cmd = {'texlab'}
        }
      '';
    };
    typescript = {
      extraPackages = [ pkgs.nodePackages.typescript-language-server ];
      luaConfigRC = ''
        lspconfig.tsserver.setup{
          capabilities = capabilities,
          cmd = {'typescript-language-server', '--stdio' }
        }
      '';
    };
    vimscript = {
      extraPackages = [ pkgs.nodePackages.vim-language-server ];
      luaConfigRC = ''
        lspconfig.vimls.setup{
          capabilities = capabilities,
          cmd = {'vim-language-server', '--stdio' }
        }
      '';
    };
    yaml = {
      extraPackages = [ pkgs.nodePackages.yaml-language-server ];
      luaConfigRC = ''
        lspconfig.vimls.setup{
          capabilities = capabilities,
          cmd = {'yaml-language-server', '--stdio' }
        }
      '';
    };
  };
in
{
  options.lsp = with lib; {
    enable = mkEnableOption "Wether to enable LSP support.";
    efm = {
      enable = mkEnableOption "Wether to enable efm-langserver.";
      languageConfigs = mkOption {
        description = "Language configs. Configs must end with a comma.";
        type = types.lines;
        default = "";
      };
    };
    languages = builtins.mapAttrs (language: _: mkEnableOption "Wether to enable ${language} LSP.") languages;
  };
  config = lib.mkMerge ([
    (lib.mkIf cfg.enable {
      completion.enable = true;
      startPlugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        goto-preview
        cmp-nvim-lsp
      ];

      plugins.nvim-which-key = true;

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

      luaConfigRC = builtins.readFile ./config.lua;

    })
    (lib.mkIf cfg.efm.enable {
      extraPackages = [ pkgs.efm-langserver ];
      luaConfigRC = ''
        lspconfig.efm.setup{
          capabilities = capabilities,
            cmd = { "efm-langserver", },
            init_options = { documentFormatting = true },
            settings = {
              rootMarkers = { ".git/" },
              lintDebounce = 100,
              languages = {
                ${cfg.efm.languageConfigs}
              },
            },
        }
      '';
    })
  ] ++ (lib.mapAttrsToList
    (language: conf: (lib.mkIf cfg.languages.${language}
      conf))
    languages));
}
