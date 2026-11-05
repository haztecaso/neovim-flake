{ pkgs, ... }:
{
  # Follows the desktop theme from /etc/nixos (custom.theme): base16
  # palette from ~/.local/state/theme/current/palette.lua, falling back to
  # gruvbox with the portal's dark/light preference.
  extraPlugins = [ pkgs.vimPlugins.mini-nvim ];
  extraPackages = [ pkgs.glib.bin ];
  extraConfigLua = builtins.readFile ./theme.lua;
}
