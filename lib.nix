with builtins;
rec {
  mkPlugins = { pkgs, inputs, plugins }:
    let
      buildPlug = name: pkgs.vimUtils.buildVimPluginFrom2Nix {
        pname = name;
        version = "master";
        src = builtins.getAttr name inputs;
      };
    in
    builtins.listToAttrs (map (name: { inherit name; value = buildPlug name; }) plugins);

  mkNeovimOverrideOptions = { pkgs, config ? { }, ... }:
    let
      neovimPlugins = pkgs.neovimPlugins;
      vimOptions = pkgs.lib.evalModules {
        modules = [{ imports = [ ./modules ]; } config];
        specialArgs = { inherit pkgs; };
      };
      cfg = vimOptions.config;
    in {
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

  mkNeovim = {pkgs, ... }@opts: pkgs.neovim.override (mkNeovimOverrideOptions opts);
  mkNeovimNightly = {pkgs, ... }@opts: pkgs.wrapNeovim pkgs.neovim-nightly (mkNeovimOverrideOptions opts);

}
