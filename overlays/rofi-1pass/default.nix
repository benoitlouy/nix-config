self: super:

let
  script = self.replaceVars ./rofi-1pass.sh {
    pinentry = "${self.pinentry.gnome3}/bin/pinentry-gnome3";
    op = "${self._1password-cli}/bin/op";
    jq = "${self.jq}/bin/jq";
  };
in
{
  rofi-1pass = super.writeShellScriptBin "rofi-1pass" (builtins.readFile script);
}
