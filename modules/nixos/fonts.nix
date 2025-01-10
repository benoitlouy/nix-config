{ config, pkgs, ... }:
{
  fonts.packages = with pkgs; [
    monaspace
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.hack
    pkgs.nerd-fonts.noto
  ];
}
