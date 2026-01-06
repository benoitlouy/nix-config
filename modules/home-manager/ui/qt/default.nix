{ pkgs, ... }:
{
  qt = {
    enable = true;
    style.name = "adwaita-qt6";
    # style.name = "adwaita-dark";
    platformTheme = {
      name = "gtk3"; # This set the QT_QPA_PLATFORMTHEME
      package = [pkgs.adwaita-qt pkgs.adwaita-qt6];
    };
  };
}
