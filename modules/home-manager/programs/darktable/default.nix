{ pkgs, ... }: {
  home.packages = [
    pkgs.darktable
    pkgs.rawtherapee
    pkgs.rapid-photo-downloader
    pkgs.gimp
    pkgs.ansel
  ];
}
