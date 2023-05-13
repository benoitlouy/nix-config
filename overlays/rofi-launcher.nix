self: super:

{
  rofi-launcher = super.stdenv.mkDerivation {
    pname = "rofi-launcher";
    version = "1.0.0";

    unpackPhase = ":";

    installPhase = ''
      mkdir -p $out/bin
      cat > $out/bin/rofi-launcher << EOF
      #!${self.bash}/bin/bash

      ${self.rofi-wayland}/bin/rofi -show drun -modi drun -theme ~/.config/rofi/launcher_theme
      EOF
      chmod 755 $out/bin/rofi-launcher
    '';
  };
}
