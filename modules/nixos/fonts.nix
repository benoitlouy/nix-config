{ config, pkgs, ... }:
{
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [
      "JetBrainsMono"
      "Hack"
      "Noto"
    ]; })
  ];
}
