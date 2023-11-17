{ config, pkgs, ... }:
{
  fonts.packages = with pkgs; [
    monaspace
    (nerdfonts.override { fonts = [
      "JetBrainsMono"
      "Hack"
      "Noto"
    ]; })
  ];
}
