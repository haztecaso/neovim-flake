{ pkgs, ... }:
let
  openAIKeyHelper = pkgs.writeShellScriptBin "nvim-openai-key" ''
    #!/usr/bin/env bash
    if [ -n "''${OPENAI_API_KEY:-}" ]; then
      printf "%s" "''${OPENAI_API_KEY}"
      exit 0
    fi

    key_file="''${XDG_CONFIG_HOME:-$HOME/.config}/openai/api-key"
    if [ -f "''${key_file}" ]; then
      IFS= read -r key < "''${key_file}"
      printf "%s" "''${key}"
      exit 0
    fi

    printf "set-your-openai-api-key"
  '';
in
{
  plugins.chatgpt = {
    enable = true;
    settings = {
      api_key_cmd = "${openAIKeyHelper}/bin/nvim-openai-key";
      openai_params.model = "gpt-4o-mini";
      openai_edit_params.model = "gpt-4o-mini";
    };
  };
  keymaps = [
    {
      mode = "v";
      key = "e";
      action = "<cmd>ChatGPTEditWithInstruction<cr>";
      options.desc = "Edit with instructions";
    }
    {
      mode = [ "v" "n" ];
      key = "<leader>C";
      action = "<cmd>ChatGPT<cr>";
      options.desc = "ChatGPT";
    }
    {
      mode = [ "v" "n" ];
      key = "<leader>cd";
      action = "<cmd>ChatGPTRun docstring<cr>";
      options.desc = "ChatGPT docstring";
    }
  ];
}
