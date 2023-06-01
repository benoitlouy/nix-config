{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.kanshi
  ];

  xdg.configFile."kanshi/config".text = ''
    profile mobile {
      output eDP-1 enable mode 2880x1800 position 0,0
    }

    profile {
      output "HP Inc. HP Z27k G3 CN41273D05" enable mode 3840x2160 position 0,0
      output eDP-1 enable mode 2880x1800 position 0,2160
    }
  '';
}
