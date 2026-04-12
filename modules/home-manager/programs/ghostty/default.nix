{ config, pkgs, ... }:
{
  home.packages = [
    (if pkgs.stdenv.targetPlatform.isMacOS then pkgs.ghostty-bin else pkgs.ghostty)
  ];
  xdg.configFile = {
    "ghostty/config".text = ''
      # theme = Oxocarbon
      theme = Operator Mono Dark
      background-opacity = 0.8
      background-blur = true
      window-decoration = none
      font-size = ${toString config.term-font-size}
      font-family = ""
      font-family = "MonaspiceNe Nerd Font Mono"
      font-style = "Medium"
      font-thicken = true
    '';
  };

}
