{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixvim, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      imports = [ inputs.flake-parts.flakeModules.easyOverlay ];

      perSystem = { config, pkgs, system, ... }:
        let
          nixvimLib = nixvim.lib.${system};
          nvimPackage = imports:
            nixvim.legacyPackages.${system}.makeNixvimWithModule {
              inherit pkgs;
              module = {
                imports = builtins.map (input: ./config/${input}) imports;
              };
            };
        in {
          packages = {
            default = nvimPackage [ "settings.nix" "core" ];
            core = nvimPackage [ "settings.nix" "core" ];
            full = nvimPackage [ "settings.nix" "core" "full" ];
            latex = nvimPackage [ "settings.nix" "core" "full" "latex.nix" ];
          };

          overlayAttrs = { nvim = { inherit (config.packages) core full; }; };

          checks = {
            default =
              nixvimLib.check.mkTestDerivationFromNixvimModule nvimPackage [
                "settings.nix"
                "core"
                "full"
              ];
            core =
              nixvimLib.check.mkTestDerivationFromNixvimModule nvimPackage [
                "settings.nix"
                "core"
              ];
            full =
              nixvimLib.check.mkTestDerivationFromNixvimModule nvimPackage [
                "settings.nix"
                "core"
                "full"
              ];
            latex =
              nixvimLib.check.mkTestDerivationFromNixvimModule nvimPackage [
                "settings.nix"
                "core"
                "full"
                "latex.nix"
              ];
          };

          formatter = pkgs.nixfmt-rfc-style;
        };
    };
}
