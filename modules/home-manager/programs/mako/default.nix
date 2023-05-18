{ config, pkgs, ... }:
{
  services.mako = {
    enable = true;
    font = "JetBrainsMono Nerd Font 10";
    backgroundColor = "#002B36";
    textColor = "#839496";
    borderColor = "#073642";
    extraConfig = ''
      [urgency=high]
      text-color=#CB4B16
    '';
  };
}
