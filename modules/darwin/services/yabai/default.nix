{ config, pkgs, ... }:
{
  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = false;
    extraConfig = ''
      sudo /run/current-system/sw/bin/yabai --load-sa
      yabai -m signal --add event=dock_did_restart action="sudo /run/current-system/sw/bin/yabai --load-sa"
    '';
    config = {
      focus_follows_mouse = "autoraise";
      mouse_follows_focus = "on";
      window_placement = "second_child";
      window_opacity = "off";
      window_opacity_duration = "0.0";
      window_border = "off";
      window_border_placement = "inset";
      window_border_width = 2;
      window_border_radius = 3;
      active_window_border_topmost = "off";
      window_topmost = "off";
      window_shadow = "on";
      active_window_border_color = "0xff5c7e81";
      normal_window_border_color = "0xff505050";
      insert_window_border_color = "0xffd75f5f";
      active_window_opacity = "1.0";
      normal_window_opacity = "1.0";
      split_ratio = "0.50";
      auto_balance = "off";
      mouse_modifier = "fn";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      layout = "bsp";
      top_padding = 20;
      bottom_padding = 20;
      left_padding = 20;
      right_padding = 20;
      window_gap = 10;
      # external_bar = "main:26:0";
    };
  };

}
