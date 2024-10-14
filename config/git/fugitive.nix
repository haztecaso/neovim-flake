{ pkgs, ... }: {
  plugins.fugitive.enable = true;
  keymaps = [
    {
      key = "<leader>gg";
      action = ":call FugitiveToggle()<CR>";
      options.desc = "Toggle fugitive";
      options.silent = true;
    }
    {
      key = "<leader>gd";
      action = ":Gdiff<CR>";
      options.desc = "git diff";
      options.silent = true;
    }
  ];
  extraConfigVim = ''
    function FugitiveToggle() abort
      try
        exe filter(getwininfo(), "get(v:val['variables'], 'fugitive_status', v:false) != v:false")[0].winnr .. "wincmd c"
      catch /E684/
        vertical Git
        vertical resize 80
      endtry
    endfunction
  '';
}
