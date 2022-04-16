with builtins;
rec {
  mkNeovimPlugins = { pkgs, inputs, plugins }: let
    buildPlug = name: pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = name;
      version = "master";
      src = builtins.getAttr name inputs;
    };
  in builtins.listToAttrs (map (name: { inherit name; value = buildPlug name; }) plugins);

  mkNeovim = {pkgs, config, ...}: let
    neovimPlugins = pkgs.neovimPlugins;
    vimOptions = pkgs.lib.evalModules {
      modules = [ { imports = [ ./modules ]; } config ];
      specialArgs = { inherit pkgs; };
    };
    vim = vimOptions.config.vim;
  in pkgs.wrapNeovim pkgs.neovim-nightly {
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = vim.configRC;

      packages.myVimPackage = with pkgs.vimPlugins; {
        start = vim.startPlugins;
        opt   = vim.optPlugins;
      };
    };
  };
}
