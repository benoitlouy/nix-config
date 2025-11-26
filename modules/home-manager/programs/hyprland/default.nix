{ pkgs, ... }:

let
  battery-notify = "${pkgs.battery-notify}/bin/battery-notify";

  toggle_floating = pkgs.writeShellScriptBin "hyprland_toggle_floating" ''
    echoerr() {
      echo $1 >&2
    }

    float() {
      ${pkgs.hyprland}/bin/hyprctl dispatch togglefloating
      ${pkgs.hyprland}/bin/hyprctl dispatch resizeactive exact 70% 70%
      ${pkgs.hyprland}/bin/hyprctl dispatch centerwindow 1
    }

    unfloat() {
      local target="''${1}"
      ${pkgs.hyprland}/bin/hyprctl dispatch togglefloating
      case "''${target}" in
        master)
          ${pkgs.hyprland}/bin/hyprctl dispatch layoutmsg swapwithmaster master
          ;;
      esac
    }

    target="$1"
    case "''${target}" in
      master)
        ;;
      child)
        ;;
      *)
        echoerr "invalid target argument ''${1}"
        exit 1
        ;;
    esac

    floating=`${pkgs.hyprland}/bin/hyprctl activewindow -j | jq .floating`

    case "''${floating}" in
      true)
        unfloat "''${target}"
        ;;
      false)
        float
        ;;
      *)
        echoerr "invalid floating state ''${floating}"
        exit 1
        ;;
    esac
  '';

  toggle_pip = pkgs.writeShellScriptBin "hyprland_toggle_pip" ''
    echoerr() {
      echo $1 >&2
    }

    pip() {
      ${pkgs.hyprland}/bin/hyprctl dispatch togglefloating
      ${pkgs.hyprland}/bin/hyprctl dispatch resizeactive exact 20% 20%
      ${pkgs.hyprland}/bin/hyprctl dispatch moveactive exact 79% 78%
    }

    unpip() {
      ${pkgs.hyprland}/bin/hyprctl dispatch togglefloating
    }

    floating=`${pkgs.hyprland}/bin/hyprctl activewindow -j | jq .floating`

    case "''${floating}" in
      true)
        unpip
        ;;
      false)
        pip
        ;;
      *)
        echoerr "invalid floating state ''${floating}"
        exit 1
        ;;
    esac
  '';
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
      exec-once = nm-applet --indicator &
      exec-once = 1password --silent &
      exec-once = fcitx5 &
      exec-once = ${battery-notify} &
      exec-once = hyprctl setcursor Adwaita 24
      exec-once = ${pkgs.udiskie}/bin/udiskie --smart-tray --file-manager nemo &

      exec-once = wl-paste --type text --watch cliphist store #Stores only text data
      exec-once = wl-paste --type image --watch cliphist store #Stores only image data

      monitor=eDP-1,highres,0x0,1
      monitor=,preferred,auto,1

      $altLeft = MOD5
      $mainMod = SUPER

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

      bind = $mainMod SHIFT, Q, exit,
      bind = $mainMod, F, fullscreen,
      bind = $mainMod, Q, killactive,

      bind = Ctrl+Super, Backslash, centerwindow, 1

      # Float window
      bind = Ctrl+Super, Space, exec, ${toggle_floating}/bin/hyprland_toggle_floating master
      bind = Shift+Ctrl+Super, Space, exec, ${toggle_floating}/bin/hyprland_toggle_floating child

      # Pip
      bind = Super+$altLeft, backslash, exec, ${toggle_pip}/bin/hyprland_toggle_pip

      bind = Super, P, pin

      bind = Super, V, exec, pkill fuzzel || caelestia clipboard
      bind = Super+$altLeft, V, exec, pkill fuzzel || caelestia clipboard -d
      bind = Super, Period, exec, pkill fuzzel || caelestia emoji -p

      bind = CTRL SHIFT, space, exec, 1password --quick-access

      binde = $altLeft, Tab, cyclenext, activewindow
      binde = Shift+$altLeft, Tab, cyclenext, prev, activewindow
      binde = Ctrl+$altLeft, Tab, changegroupactive, f
      binde = Ctrl+Shift+$altLeft, Tab, changegroupactive, b
      bind = Super, Comma, togglegroup
      bind = Super, U, moveoutofgroup
      bind = Super+Shift, Comma, lockactivegroup, toggle

      bind = Shift+Super, K, global, caelestia:showall

      # mouse bindings
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod $altLeft, mouse:272, resizewindow

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

      # Special workspace toggles
      bind = Ctrl+Shift, Escape, exec, caelestia toggle sysmon
      bind = Super, M, exec, caelestia toggle music
      bind = Super, D, exec, caelestia toggle communication
      bind = Super, R, exec, caelestia toggle todo

      # window rules

      # Picture in picture (resize and move done via script)
      # windowrule = match:title Picture(-| )in(-| )[Pp]icture, move 100%-w-2% 100%-w-3% # Initial move so window doesn't shoot across the screen from the center
      windowrule = match:title Picture(-| )in(-| )[Pp]icture, keep_aspect_ratio on
      windowrule = match:title Picture(-| )in(-| )[Pp]icture, float on
      windowrule = match:title Picture(-| )in(-| )[Pp]icture, size 800 450
      windowrule = match:title Picture(-| )in(-| )[Pp]icture, center on
      # windowrule = match:title Picture(-| )in(-| )[Pp]icture, move
      windowrule = match:title Picture(-| )in(-| )[Pp]icture, pin on
      windowrule = match:title Picture(-| )in(-| )[Pp]icture, focus_on_activate off

      # # windowrule = float,title:^(Picture-in-Picture)$
      # # windowrule = size 960 540,title:^(Picture-in-Picture)$
      # # windowrule = move 25%-,title:^(Picture-in-Picture)$

      # 1password
      windowrule = match:title ^(Quick Access — 1Password)$, float on
      windowrule = match:title ^(Quick Access — 1Password)$, no_max_size on


      # Steam
      # windowrule = rounding 10, title:, class:steam
      # windowrule = float, title:Friends List, class:steam
      # windowrule = immediate, class:steam_app_[0-9]+  # Allow tearing for steam games
      # windowrule = idleinhibit always, class:steam_app_[0-9]+  # Always idle inhibit when playing a steam game

      # windowrulev2 = stayfocused, title:^()$,class:^(steam)$
      # windowrulev2 = minsize 1 1, title:^()$,class:^(steam)$

      # Special workspaces
      # windowrule = workspace special:sysmon, match:class btop
      windowrule = match:class feishin|Spotify|Supersonic|Cider, workspace special:music
      windowrule = match:class discord|equibop|vesktop|whatsapp|bluebubbles, workspace special:communication
      # windowrule = workspace special:todo, class:Todoist

      # gestures
      gesture = 4, horizontal, workspace

      $onSurfaceVariant = c8c5d1
      $primary = c2c1ff
      $onPrimary = 2a2a60
      $outline = 918f9a
      $secondary = c6c4e0

      $activeWindowBorderColour = rgba($primarye6)
      $inactiveWindowBorderColour = rgba($onSurfaceVariant11)

      general {
        gaps_in = 3
        gaps_out = 5
        border_size = 3
        col.active_border = $activeWindowBorderColour
        # col.inactive_border = rgba(595959aa)
        col.inactive_border = $inactiveWindowBorderColour

        layout = master
        # layout = dwindle

        allow_tearing = false
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
        enabled = true
        bezier = overshot, 0.13, 0.99, 0.29, 1.1
        animation = windows, 1, 4, overshot, slide
        animation = windowsOut, 1, 5, default, popin 80%
        animation = border, 1, 5, default
        animation = fade, 1, 8, default
        animation = workspaces, 1, 6, overshot, slide
      }

      group {
          col.border_active = $activeWindowBorderColour
          col.border_inactive = $inactiveWindowBorderColour
          col.border_locked_active = $activeWindowBorderColour
          col.border_locked_inactive = $inactiveWindowBorderColour

          groupbar {
              font_family = JetBrainsMono Nerd Font
              font_size = 15
              gradients = true
              gradient_round_only_edges = false
              gradient_rounding = 5
              height = 25
              indicator_height = 0
              gaps_in = 3
              gaps_out = 3

              text_color = rgb($onPrimary)
              col.active = rgba($primaryd4)
              col.inactive = rgba($outlined4)
              col.locked_active = rgba($primaryd4)
              col.locked_inactive = rgba($secondaryd4)
          }
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
