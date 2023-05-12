{ config, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemdIntegration = true;
    xwayland = {
      enable = true;
      hidpi = true;
    };

    extraConfig = ''
      exec-once = ${pkgs.xdph-launcher}/bin/xdph-launcher
      exec-once = mako &
      exec-once = waybar &

      monitor=,highres,auto,1

      $mainMod = ALT

      bind=,Super_L,exec, pkill rofi || ${pkgs.rofi-launcher}/bin/rofi-launcher

      bind = $mainMod SHIFT, Q, exit,
      bind = $mainMod, F, fullscreen,

      # move focus
      bind = $mainMod, H, movefocus, l
      bind = $mainMod, J, movefocus, d
      bind = $mainMod, K, movefocus, u
      bind = $mainMod, L, movefocus, r

      # move windows in current workspace
      bind = $mainMod SHIFT, H, movewindow, l
      bind = $mainMod SHIFT, J, movewindow, d
      bind = $mainMod SHIFT, K, movewindow, u
      bind = $mainMod SHIFT, L, movewindow, r

      binde = $mainMod SHIFT, A, resizeactive, -15 0
      binde = $mainMod SHIFT, S, resizeactive, 0 15
      binde = $mainMod SHIFT, D, resizeactive, 0 -15
      binde = $mainMod SHIFT, F, resizeactive, 15 0

      # window rules
      windowrule=float,title:^(Picture-in-Picture)$
      windowrule=size 960 540,title:^(Picture-in-Picture)$
      windowrule=move 25%-,title:^(Picture-in-Picture)$

      general {
        gaps_in = 3
        gaps_out = 5
        border_size = 3
        col.active_border = rgb(ffc0cb)
        col.inactive_border = rgba(595959aa)

        layout = dwindle # master|dwindle
      }

      dwindle {
        no_gaps_when_only = false
        force_split = 0
        special_scale_factor = 0.8
        split_width_multiplier = 1.0
        use_active_for_splits = true
        pseudotile = yes
        preserve_split = yes
      }

      decoration {
        multisample_edges = true
        active_opacity = 1.0
        inactive_opacity = 1.0
        fullscreen_opacity = 1.0
        rounding = 0
        blur = yes
        blur_size = 3
        blur_passes = 1
        blur_new_optimizations = true
        blur_xray = true

        drop_shadow = false
        shadow_range = 4
        shadow_render_power = 3
        shadow_ignore_window = true
      # col.shadow =
      # col.shadow_inactive
      # shadow_offset
        dim_inactive = false
      # dim_strength = #0.0 ~ 1.0
        blur_ignore_opacity = false
        col.shadow = rgba(1a1a1aee)
      }

      animations {
        enabled=1
        bezier = overshot, 0.13, 0.99, 0.29, 1.1
        animation = windows, 1, 4, overshot, slide
        animation = windowsOut, 1, 5, default, popin 80%
        animation = border, 1, 5, default
        animation = fade, 1, 8, default
        animation = workspaces, 1, 6, overshot, slidevert
      }

      gestures {
        workspace_swipe = true
        workspace_swipe_fingers = 4
        workspace_swipe_distance = 250
        workspace_swipe_invert = true
        workspace_swipe_min_speed_to_force = 15
        workspace_swipe_cancel_ratio = 0.5
        workspace_swipe_create_new = false
      }
    '';
  };
}
