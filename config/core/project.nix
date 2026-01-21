{ lib, config, ... }:
let
  toggleType = lib.types.submodule {
    options = {
      key = lib.mkOption {
        type = lib.types.str;
        description = "Keybinding for this toggle";
      };
      desc = lib.mkOption {
        type = lib.types.str;
        description = "Description for which-key";
      };
      modes = lib.mkOption {
        type = lib.types.nullOr (lib.types.listOf lib.types.str);
        default = null;
        description = "List of modes to cycle through (null for boolean toggle)";
      };
      labels = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = "Human-readable labels for each mode";
      };
      default = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Default mode/value";
      };
      apply = lib.mkOption {
        type = lib.types.str;
        description = "Lua function(mode) to apply the setting";
      };
    };
  };

  # Generate Lua registration code for all toggles
  generateToggleLua =
    name: toggle:
    let
      modesLua =
        if toggle.modes == null then "nil" else lib.nixvim.toLuaObject toggle.modes;
      labelsLua = if toggle.labels == { } then "nil" else lib.nixvim.toLuaObject toggle.labels;
      defaultLua = if toggle.default == "" then "nil" else ''"${toggle.default}"'';
    in
    ''
      Project.register_toggle("${name}", {
          key = "${toggle.key}",
          desc = "${toggle.desc}",
          modes = ${modesLua},
          labels = ${labelsLua},
          default = ${defaultLua},
          apply = ${toggle.apply}
      })
    '';

  allTogglesLua = lib.concatStringsSep "\n" (
    lib.mapAttrsToList generateToggleLua config.project.toggles
  );
in
{
  options.project.toggles = lib.mkOption {
    type = lib.types.attrsOf toggleType;
    default = { };
    description = "Toggle definitions for project-local settings";
  };

  config = {
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

    # Load project.lua first (with registration API)
    extraConfigLuaPre = builtins.readFile ./project.lua;

    # Register all toggles after project.lua is loaded, then initialize
    extraConfigLua = lib.mkIf (config.project.toggles != { }) ''
      ${allTogglesLua}

      -- Initialize after all toggles are registered
      Project.init()
    '';
  };
}
