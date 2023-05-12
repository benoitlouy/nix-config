self: super:

{
  xdph-launcher = super.stdenv.mkDerivation {
    pname = "xdph-launcher";
    version = "1.0.0";

    unpackPhase = ":";

    installPhase = ''
      mkdir -p $out/bin
      cat > $out/bin/xdph-launcher << EOF
      #!${self.bash}/bin/bash

      sleep 1
      ${self.killall}/bin/killall xdg-desktop-portal-hyprland
      ${self.killall}/bin/killall xdg-desktop-portal-wlr
      ${self.killall}/bin/killall xdg-desktop-portal
      ${self.xdg-desktop-portal-hyprland}/libexec/xdg-desktop-portal-hyprland &
      sleep 2
      ${self.xdg-desktop-portal}/libexec/xdg-desktop-portal &

      EOF
      chmod 755 $out/bin/xdph-launcher
    '';
  };
}
