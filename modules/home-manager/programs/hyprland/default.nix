{ config, pkgs, inputs, ... }:

let
  battery-notify = "${pkgs.battery-notify}/bin/battery-notify";
in
{

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland = {
      enable = true;
    };

    # plugins = [
    #   inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    # ];

    extraConfig = ''
      env = QT_QPA_PLATFORMTHEME, gtk3
      # exec-once = swaync &
      # exec-once = mako &
      # exec-once = waybar &
      # exec-once = caelestia shell -d
      exec-once = nm-applet --indicator &
      exec-once = 1password --silent &
      # exec-once = avizo-service &
      # exec-once = swww init
      # exec-once = swww img ~/Pictures/Wallpapers/living_room.png
      exec-once = fcitx5 &
      exec-once = ${battery-notify} &
      exec-once = hyprctl setcursor Adwaita 24
      exec-once = ${pkgs.udiskie}/bin/udiskie --smart-tray --file-manager nemo &

      exec-once = wl-paste --type text --watch cliphist store #Stores only text data
      exec-once = wl-paste --type image --watch cliphist store #Stores only image data

      monitor=eDP-1,highres,0x0,1
      monitor=,preferred,auto,1

      # $mainMod = MOD5
      $mainMod = SUPER

      # exec = hyprctl dispatch submap global
      # submap = global
      bind = $mainMod, E, global, caelestia:launcher
      # bindin = Super, catchall, global, caelestia:launcherInterrupt
      bindin = Super, mouse:272, global, caelestia:launcherInterrupt
      bindin = Super, mouse:273, global, caelestia:launcherInterrupt
      bindin = Super, mouse:274, global, caelestia:launcherInterrupt
      bindin = Super, mouse:275, global, caelestia:launcherInterrupt
      bindin = Super, mouse:276, global, caelestia:launcherInterrupt
      bindin = Super, mouse:277, global, caelestia:launcherInterrupt
      bindin = Super, mouse_up, global, caelestia:launcherInterrupt
      bindin = Super, mouse_down, global, caelestia:launcherInterrupt
      # bind = $mainMod, E, exec, pkill anyrun || anyrun

      bind = $mainMod SHIFT, Q, exit,
      bind = $mainMod, F, fullscreen,
      bind = $mainMod, Q, killactive,
      # bind = $mainMod, P, togglefloating,
      # bind = $mainMod, P, pin,
      # bind = $mainMod, P, resizeactive, exact 25% 25%

      bind = Ctrl+Super, Backslash, centerwindow, 1

      bind = Ctrl+Super+Alt, Backslash, resizeactive, exact 55% 70%
      bind = Ctrl+Super+Alt, Backslash, centerwindow, 1

      bind = Super+Alt, Backslash, exec, caelestia resizer pip  # Move window to picture-in-picture mode
      bind = Super, P, pin
      bind = Super+Alt, Space, togglefloating,

      # bind = SUPER, V, exec, pkill anyrun || anyrun-cliphist-launcher

      bind = Super, V, exec, pkill fuzzel || caelestia clipboard
      bind = Super+Alt, V, exec, pkill fuzzel || caelestia clipboard -d
      bind = Super, Period, exec, pkill fuzzel || caelestia emoji -p

      bind = CTRL SHIFT, space, exec, 1password --quick-access
      bind = CTRL SUPER, space, exec, pkill anyrun || anyrun-op-launcher
      bind = $mainMod, tab, exec, pkill anyrun || anyrun-ws-launcher

      binde = Alt, Tab, cyclenext, activewindow
      binde = Shift+Alt, Tab, cyclenext, prev, activewindow

      bind = Super, K, global, caelestia:showall

      # mouse bindings
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod MOD5, mouse:272, resizewindow

      # move focus
      bind = $mainMod, H, movefocus, l
      bind = $mainMod, J, movefocus, d
      bind = $mainMod, K, movefocus, u
      bind = $mainMod, L, movefocus, r

      # swap windows in current workspace
      bind = $mainMod CTRL, H, swapwindow, l
      bind = $mainMod CTRL, J, swapwindow, d
      bind = $mainMod CTRL, K, swapwindow, u
      bind = $mainMod CTRL, L, swapwindow, r

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

      bindl = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindle = , XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 2 @DEFAULT_AUDIO_SINK@ 5%+
      bindle = , XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-

      bindl = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      bindle = SHIFT, XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SOURCE@ 5%+
      bindle = SHIFT, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-

      bindle = , XF86MonBrightnessUp, global, caelestia:brightnessUp
      bindle = , XF86MonBrightnessDown, global, caelestia:brightnessDown

      # binde =,XF86AudioRaiseVolume,exec, volumectl -b -u up
      # binde =,XF86AudioLowerVolume,exec, volumectl -b -u down
      # bind =,XF86AudioMute,exec, volumectl toggle-mute
      # binde = SHIFT, XF86AudioRaiseVolume,exec, volumectl -u -m up
      # binde = SHIFT, XF86AudioLowerVolume,exec, volumectl -u -m down
      # bind =,XF86AudioMicMute,exec, volumectl -m toggle-mute
      # binde =,XF86MonBrightnessUp,exec, lightctl up
      # binde =,XF86MonBrightnessDown, exec, lightctl down

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
      windowrulev2 = stayfocused, title:^()$,class:^(steam)$
      windowrulev2 = minsize 1 1, title:^()$,class:^(steam)$

      # gestures
      gesture = 4, horizontal, workspace

      general {
        gaps_in = 3
        gaps_out = 5
        border_size = 3
        col.active_border = rgb(c2c1ff)
        # col.active_border = rgb(ffc0cb)
        col.inactive_border = rgba(595959aa)

        #layout = master
        layout = dwindle # master|dwindle
      }

      # keyboard settings, overridden by fcitx5
      input {
        kb_model = pc104
        kb_layout = us
        kb_variant = mac
        # kb_options = lv3:lalt_switch # both alt keys can be use to access special chars
        kb_options = lv3:lalt_switch,lv3:ralt_alt # left alt key can be used to access special char, right side is regular alt
      }

      dwindle {
        # no_gaps_when_only = false # option does not exist anymore
        # force_split = 0
        # special_scale_factor = 0.8
        # split_width_multiplier = 1.0
        # use_active_for_splits = true
        #pseudotile = yes
        preserve_split = true
        smart_split = false
        smart_resizing = true
      }

      master {
        # new_is_master = false
        new_status = slave
        mfact = 0.6
      }

      decoration {
        active_opacity = 1.0
        inactive_opacity = 1.0
        fullscreen_opacity = 1.0
        rounding = 20

        blur {
          enabled = false
          size = 3
          passes = 1
          ignore_opacity = false
          new_optimizations = true
          xray = true
        }

        shadow {
          enabled = false
          range = 4
          render_power = 3
          ignore_window = true
          color = rgba(1a1a1aee)
        }
        dim_inactive = false
      # dim_strength = #0.0 ~ 1.0
      }

      animations {
        # enabled = true

        # # Animation curves
        # bezier = specialWorkSwitch, 0.05, 0.7, 0.1, 1
        # bezier = emphasizedAccel, 0.3, 0, 0.8, 0.15
        # bezier = emphasizedDecel, 0.05, 0.7, 0.1, 1
        # bezier = standard, 0.2, 0, 0, 1

        # # Animation configs
        # animation = layersIn, 1, 5, emphasizedDecel, slide
        # animation = layersOut, 1, 4, emphasizedAccel, slide
        # animation = fadeLayers, 1, 5, standard

        # animation = windowsIn, 1, 5, emphasizedDecel
        # animation = windowsOut, 1, 3, emphasizedAccel
        # animation = windowsMove, 1, 6, standard
        # animation = workspaces, 1, 5, standard

        # animation = specialWorkspace, 1, 4, specialWorkSwitch, slidefadevert 15%

        # animation = fade, 1, 6, standard
        # animation = fadeDim, 1, 6, standard
        # animation = border, 1, 6, standard
        enabled = true
        bezier = overshot, 0.13, 0.99, 0.29, 1.1
        animation = windows, 1, 4, overshot, slide
        animation = windowsOut, 1, 5, default, popin 80%
        animation = border, 1, 5, default
        animation = fade, 1, 8, default
        animation = workspaces, 1, 6, overshot, slide
      }

      misc {
        vfr = true
        disable_hyprland_logo = true
        always_follow_on_dnd = true
        layers_hog_keyboard_focus = true
        animate_manual_resizes = false
        enable_swallow = false
        swallow_regex = ^(Alacritty)$
        focus_on_activate = true
      }

      plugin {
        # split-monitor-workspaces {
        #     count = 5
        #     keep_focused = 0
        #     enable_notifications = 0
        #     enable_persistent_workspaces = 0
        # }
      }
    '';
  };
}
