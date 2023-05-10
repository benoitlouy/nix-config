{ config, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
      hidpi = true;
    };

    extraConfig = ''
      exec-once = mako &
      exec-once = waybar &
      bind=,Super_L,exec, pkill rofi || ${pkgs.rofi-wayland}/bin/rofi
    '';
  };
}
