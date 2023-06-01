{ config, pkgs, ... }:
{
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-m17n
      fcitx5-mozc
      fcitx5-gtk
      fcitx5-table-other
      fcitx5-rime
    ];
  };
}
