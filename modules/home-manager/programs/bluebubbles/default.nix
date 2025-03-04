{ pkgs, config, ... }:

{
  # home.packages = [ pkgs.bluebubbles ];
  xdg.systemDirs.data = [
    "/var/lib/flatpak/exports/share"
    "${config.xdg.dataHome}/flatpak/exports/share"
  ];
}
