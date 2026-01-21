{
  plugins.lsp-lines.enable = true;

  diagnostic.settings = {
    virtual_text = false;
    virtual_lines = true;
    signs = true;
    underline = true;
    update_in_insert = false;
    severity_sort = true;
    float = {
      border = "rounded";
      source = true;
    };
  };

  extraConfigLua = builtins.readFile ./project.lua;
}
