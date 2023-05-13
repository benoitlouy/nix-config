{ config, pkgs, ... }:
let
  ALPHA = "#00000000";
  BG = "#1E1E2E";
  FG = "#1A1B26";
  SELECT = "#C0CAF5";
  ACCENT = "#1A1B26";
in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };

  home.packages = [ pkgs.rofi-launcher ];

  xdg.configFile."rofi/colors.rasi".text = ''
    * {
      al: ${ALPHA};
      bg: ${BG};
      se: ${SELECT};
      fg: ${FG};
      ac: ${ACCENT};
    }
  '';
  xdg.configFile."rofi/launcher_theme.rasi".source = ./launcher_theme.rasi;
}
