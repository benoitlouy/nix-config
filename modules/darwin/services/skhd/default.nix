{ config, pkgs, ... }:
{

  services.skhd = {
    enable = true;
    package = pkgs.skhd;
    skhdConfig = {
      "qwerty" = builtins.readFile ./skhdrc_qwerty;
      "colemak-dh" = builtins.readFile ./skhdrc_colemak
    }." ${config.keymap}";
  };
}
