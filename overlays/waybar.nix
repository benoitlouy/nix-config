self: super:

{
  waybar = super.waybar.overrideAttrs (
    old: rec {
      version = "7b0d2e80434523eb22cf3bb5bdc41d590304a113";

      src = super.fetchFromGitHub {
        owner = "Alexays";
        repo = "Waybar";
        rev = version;
        hash = "sha256-0QIKuFhOgclW3sxnmgbDAg7tGBg5YSKziLza/eqsaJ8=";
        # hash = "sha256-sdNenmzI/yvN9w4Z83ojDJi+2QBx2hxhJQCFkc5kCZw=";
      };

      buildInputs = (old.buildInputs or [ ]) ++ [
        self.cava
        self.iniparser
        self.fftw
      ];
      mesonFlags = old.mesonFlags ++ [
        "-Dexperimental=true"
        "-Dcava=disabled"
      ];
      patches = (old.patches or [ ]) ++ [
        ./waybar-hyprland.patch
      ];
      # postPatch = (old.postPatch or "") + ''
      #   sed -i 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp'';
    }
  );
}
