{
  project.toggles.copilot = {
    key = "<leader>tc";
    desc = "Copilot";
    default = "true";
    apply = ''
      function(enabled)
        vim.g.copilot_enabled = enabled
      end
    '';
  };

  plugins.copilot-lua = {
    enable = true;
    settings = {
      panel.enabled = false;
      suggestion.enabled = false;
    };
  };
}
