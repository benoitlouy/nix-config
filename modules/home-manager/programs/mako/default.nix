{ config, pkgs, ... }:
{
  services.mako = {
    enable = false;
    font = "JetBrainsMono Nerd Font 10 Bold";
    backgroundColor = "#1e1e2e";
    textColor = "#f5c2e7";
    borderColor = "#073642";
    borderSize = 0;
    padding = "20";
    width = 400;
    defaultTimeout = 5000;
    extraConfig = ''
      [urgency=high]
      text-color=#CB4B16
    '';
  };
}
