{ ... }: {
  plugins.avante = {
    enable = true;
    settings = {
      provider = "claude";
      claude = { model = "claude-3-7-latest"; };
      behaviour = { auto_suggestions = false; };
    };
  };
}
