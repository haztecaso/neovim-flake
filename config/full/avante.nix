{ ... }: {
  plugins.avante = {
    enable = true;
    settings = {
      provider = "claude";
      claude = { model = "claude-3-5-sonnet-20240620"; };
      behaviour = { auto_suggestions = false; };
    };
  };
}
