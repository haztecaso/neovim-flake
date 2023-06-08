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
      vimOptions = pkgs.lib.evalModules {
        modules = [{ imports = [ ./modules ]; } config];
        specialArgs = { inherit pkgs; };
      };
      cfg = vimOptions.config;
      lib = pkgs.lib;
    in
    {
      viAlias = true;
      vimAlias = true;
      extraMakeWrapperArgs = lib.optionalString (cfg.extraPackages != [ ])
        '' --prefix PATH : "${lib.makeBinPath cfg.extraPackages}" '';
      configure = {
        customRC = cfg.configRC;
        packages.myVimPackage = {
          start = cfg.startPlugins;
          opt = cfg.optPlugins;
        };
      };
    };

  mkNeovim = { pkgs, ... }@opts: pkgs.neovim.override (mkNeovimOverrideOptions opts);
  mkNeovimNightly = { pkgs, ... }@opts: pkgs.wrapNeovim pkgs.neovim-nightly (mkNeovimOverrideOptions opts);

}
