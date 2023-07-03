{ config, pkgs, ... }:

{
  gtk = {
    enable = true;

    # theme = {
    #   name = "Colloid-Pink-Dark-Compact";
    #   package = pkgs.colloid-gtk-theme.override {
    #     themeVariants = [ "pink" ];
    #     colorVariants = [ "dark" ];
    #     sizeVariants = [ "compact" ];
    #     tweaks = [ "black" "rimless" ];
    #   };
    # };
    theme = {
      name = "Catppuccin-Macchiato-Compact-Pink-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "pink" ];
        size = "compact";
        tweaks = [ "rimless" ];
        variant = "macchiato";
      };
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
      # name = "Colloid-light";
      # package = pkgs.colloid-icon-theme;
    };

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };

    gtk3.extraConfig = {
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
    };

    gtk2.extraConfig = ''
      gtk-xft-antialias=1
      gtk-xft-hinting=1
      gtk-xft-hintstyle="hintslight"
      gtk-xft-rgba="rgb"
    '';
  };
}
