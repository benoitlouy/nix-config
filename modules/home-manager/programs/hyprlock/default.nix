{ ... }:
{
  programs.hyprlock = {
    enable = true;
    extraConfig = ''
      general {
        disable_loading_bar = false
        hide_cursor = true
      }

      background {
        monitor =
        path = screenshot
        # path = $HOME/Pictures/Wallpapers/magma-dark.png
        color = rgba(25, 20, 20, 1.0)

        blur_passes = 1 # 0 disables blurring
        blur_size = 7
        noise = 0.0117
        contrast = 0.8916
        brightness = 0.8172
        vibrancy = 0.1696
        vibrancy_darkness = 0.0
      }

      input-field {
        monitor = eDP-1
        size = 200, 50
        outline_thickness = 3
        outer_color = rgb(151515)
        inner_color = rgb(200, 200, 200)
        fade_on_empty = true
      }

      label {
        monitor =
        text = $TIME
        color = rgba(220, 220, 220, 1.0)
        position = 0, 200
        font_size = 50
        font_family = JetBrainsMono Nerd Font

        halign = center
        valign = center
      }

      label {
        monitor = eDP-1
        text = $USER
        color = rgba(220, 220, 220, 1.0)
        position = 0, 50                    # position is added to the halign and valign props. For absolute, use "none" in either.
        font_size = 15
        font_family = JetBrainsMono Nerd Font

        halign = center                     # left, center, right, none
        valign = center                     # top, center, bottom, none
      }
    '';
  };
}
