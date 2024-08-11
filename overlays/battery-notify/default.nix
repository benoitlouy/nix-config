self: super:

let
  script = builtins.readFile ./battery-notify.sh;
in
{
  battery-notify = super.resholve.writeScriptBin "battery-notify" {
    inputs = [ super.libnotify super.coreutils-full ];
    interpreter = "${super.bash}/bin/bash";
    execer = [
      "cannot:${super.coreutils-full}/bin/sleep"
      "cannot:${super.coreutils-full}/bin/cat"
    ];
  } script;
}
