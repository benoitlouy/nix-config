self: super:

{
  waybar = super.waybar.overrideAttrs (
    old: {
      mesonFlags = old.mesonFlags ++ [ "-Dexperimental=true" ];
      postPatch = (old.postPatch or "") + ''
        sed -i 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp'';
    }
  );
}
