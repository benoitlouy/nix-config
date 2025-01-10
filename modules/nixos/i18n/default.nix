{ config, pkgs, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-m17n
        fcitx5-mozc
        fcitx5-gtk
        fcitx5-table-other
        fcitx5-rime
      ];
    };
  };
}
