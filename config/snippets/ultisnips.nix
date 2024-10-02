{ pkgs, ... }: {
  extraPlugins = with pkgs.vimPlugins; [
    ultisnips
    vim-snippets
  ];
  globals = {
    "UltiSnipsExpandTrigger" = "<c-j>";
    "UltiSnipsJumpForwardTrigger" = "<c-j>";
    "UltiSnipsJumpBackwardTrigger" = "<s-tab>";
    "UltiSnipsSnippetDirectories" = [
      "UltiSnips"
      "~/src/neovim-flake/snippets/"
      "${../snippets}"
    ];
  };
}
