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
      bind=,Super_L,exec, pkill rofi || ${config.xdg.configHome}/rofi/launcher.sh
    '';
  };
}
