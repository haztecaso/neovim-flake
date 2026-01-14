{
  plugins.avante = {
    enable = true;
    settings = {
      provider = "claude";
      providers.claude = {
        model = "claude-3-7-latest";
      };
      behaviour = { auto_suggestions = false; };
    };
  };
}
