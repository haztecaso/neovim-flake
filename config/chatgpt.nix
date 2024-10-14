{
  plugins.chatgpt = {
    enable = true;
    settings = {
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
