self: super:

{
  swayidle-launcher = super.writeShellScriptBin "swayidle-launcher" ''
    ${self.swayidle}/bin/swayidle -w \
      timeout 120 '${self.swaylock-launcher}/bin/swaylock-launcher' \
      timeout 300 'systemctl suspend' \
      before-sleep '${self.swaylock-launcher}/bin/swaylock-launcher'
  '';
}
