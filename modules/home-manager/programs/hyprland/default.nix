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
      exec-once = swayidle-launcher &
      exec-once = swaync &
      # exec-once = mako &
      exec-once = waybar &
      exec-once = nm-applet --indicator &
      exec-once = 1password --silent &
      exec-once = avizo-service &
      exec-once = swww init
      exec-once = fcitx5 &

      exec-once = wl-paste --type text --watch cliphist store #Stores only text data
      exec-once = wl-paste --type image --watch cliphist store #Stores only image data

      monitor=,highres,auto,1

      # $mainMod = MOD5
      $mainMod = SUPER

      # bindl = ,switch:Lid Switch, exec, swaylock-launcher

      bind = $mainMod, E, exec, pkill anyrun || anyrun

      bind = $mainMod SHIFT, Q, exit,
      bind = $mainMod, F, fullscreen,
      bind = $mainMod, Q, killactive,
      bind = $mainMod, S, pin,

      # bind = SUPER, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy
      bind = SUPER, V, exec, pkill anyrun || anyrun-cliphist-launcher
      bind = CTRL SHIFT, space, exec, 1password --quick-access
      bind = CTRL SUPER, space, exec, pkill anyrun || anyrun-op-launcher
      bind = $mainMod, tab, exec, pkill anyrun || anyrun-ws-launcher

      # mouse bindings
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

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

      # resize window
      binde = $mainMod SHIFT, A, resizeactive, -15 0
      binde = $mainMod SHIFT, S, resizeactive, 0 15
      binde = $mainMod SHIFT, D, resizeactive, 0 -15
      binde = $mainMod SHIFT, F, resizeactive, 15 0

      # media keys
      binde =,XF86AudioRaiseVolume,exec, volumectl -u up
      binde =,XF86AudioLowerVolume,exec, volumectl -u down
      bind =,XF86AudioMute,exec, volumectl toggle-mute
      binde = SHIFT, XF86AudioRaiseVolume,exec, volumectl -u -m up
      binde = SHIFT, XF86AudioLowerVolume,exec, volumectl -u -m down
      bind =,XF86AudioMicMute,exec, volumectl -m toggle-mute
      binde =,XF86MonBrightnessUp,exec, lightctl up
      binde =,XF86MonBrightnessDown, exec, lightctl down
      bind=,XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause
      bind=,XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next
      bind=,XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous
      bind=,XF86AudioStop, exec, ${pkgs.playerctl}/bin/playerctl stop

      bind = CTRL, left, workspace, -1
      bind = CTRL, right, workspace, +1

      bind = $mainMod CTRL, 1, movetoworkspace, 1
      bind = $mainMod CTRL, 2, movetoworkspace, 2
      bind = $mainMod CTRL, 3, movetoworkspace, 3
      bind = $mainMod CTRL, 4, movetoworkspace, 4
      bind = $mainMod CTRL, 5, movetoworkspace, 5
      bind = $mainMod CTRL, 6, movetoworkspace, 6
      bind = $mainMod CTRL, 7, movetoworkspace, 7
      bind = $mainMod CTRL, 8, movetoworkspace, 8
      bind = $mainMod CTRL, 9, movetoworkspace, 9
      bind = $mainMod CTRL, 0, movetoworkspace, 10
      bind = SHIFT CTRL, left, movetoworkspace, -1
      bind = SHIFT CTRL, right, movetoworkspace, +1
      # same as above, but doesnt switch to the workspace
      bind = $mainMod SHIFT, 1, movetoworkspacesilent, 1
      bind = $mainMod SHIFT, 2, movetoworkspacesilent, 2
      bind = $mainMod SHIFT, 3, movetoworkspacesilent, 3
      bind = $mainMod SHIFT, 4, movetoworkspacesilent, 4
      bind = $mainMod SHIFT, 5, movetoworkspacesilent, 5
      bind = $mainMod SHIFT, 6, movetoworkspacesilent, 6
      bind = $mainMod SHIFT, 7, movetoworkspacesilent, 7
      bind = $mainMod SHIFT, 8, movetoworkspacesilent, 8
      bind = $mainMod SHIFT, 9, movetoworkspacesilent, 9
      bind = $mainMod SHIFT, 0, movetoworkspacesilent, 10

      # window rules
      windowrule = float,title:^(Picture-in-Picture)$
      windowrule = size 960 540,title:^(Picture-in-Picture)$
      windowrule = move 25%-,title:^(Picture-in-Picture)$
      windowrulev2 = float,title:^(Quick Access — 1Password)$
      windowrulev2 = nomaxsize,title:^(Quick Access — 1Password)$

      general {
        gaps_in = 3
        gaps_out = 5
        border_size = 3
        col.active_border = rgb(ffc0cb)
        col.inactive_border = rgba(595959aa)

        layout = dwindle # master|dwindle
      }

      # keyboard settings, overridden by fcitx5
      input {
        kb_layout = us
        kb_variant = mac
        # kb_options = lv3:lalt_switch # both alt keys can be use to access special chars
        kb_options = lv3:lalt_switch,lv3:ralt_alt # left alt key can be used to access special char, right side is regular alt
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
        animation = workspaces, 1, 6, overshot, slide
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

      misc {
        disable_hyprland_logo = true
        always_follow_on_dnd = true
        layers_hog_keyboard_focus = true
        animate_manual_resizes = false
        enable_swallow = false
        swallow_regex = ^(Alacritty)$
        focus_on_activate = true
      }
    '';
  };
}
