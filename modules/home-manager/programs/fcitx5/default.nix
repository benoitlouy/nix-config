{ config, pkgs, ... }:
let
  fcitx5-theme-catppuccin = pkgs.stdenv.mkDerivation rec {
    pname = "fcitx5-theme-catppuccin";
    version = "ce244cfdf43a648d984719fdfd1d60aab09f5c97";

    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "fcitx5";
      rev = version;
      hash = "sha256-uFaCbyrEjv4oiKUzLVFzw+UY54/h7wh2cntqeyYwGps=";
    };

    installPhase = ''
      mkdir -p $out/share/fcitx5/themes
      cp -r ${src}/src/* $out/share/fcitx5/themes
    '';
  };
in
{
  xdg.dataFile."fcitx5/themes/catppuccin-macchiato" = {
    source = "${fcitx5-theme-catppuccin}/share/fcitx5/themes/catppuccin-macchiato";
    recursive = true;
  };
}
