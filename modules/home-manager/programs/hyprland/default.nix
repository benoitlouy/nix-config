{ config, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = false;
    xwayland = {
      enable = true;
      hidpi = true;
    };

    extraConfig = ''
      exec-once = mako &
      exec-once = waybar &
    '';
  };
}
