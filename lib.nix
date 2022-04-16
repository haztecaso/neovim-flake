with builtins;
rec {
  mkNeovimPlugins = { pkgs, inputs, plugins }:
    let
      buildPlug = name: pkgs.vimUtils.buildVimPluginFrom2Nix {
        pname = name;
        version = "master";
        src = builtins.getAttr name inputs;
      };
    in
    builtins.listToAttrs (map (name: { inherit name; value = buildPlug name; }) plugins);

  mkNeovim = { pkgs, config ? { }, ... }:
    let
      neovimPlugins = pkgs.neovimPlugins;
      vimOptions = pkgs.lib.evalModules {
        modules = [{ imports = [ ./modules ]; } config];
        specialArgs = { inherit pkgs; };
      };
      cfg = vimOptions.config;
    in
    pkgs.wrapNeovim pkgs.neovim-nightly {
      viAlias = true;
      vimAlias = true;
      configure = {
        customRC = cfg.configRC;

        packages.myVimPackage = with pkgs.vimPlugins; {
          start = cfg.startPlugins;
          opt = cfg.optPlugins;
        };
      };
    };
}
