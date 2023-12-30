self: super:

let
  script = builtins.readFile ./battery-notify.sh;
in
{
  battery-notify = super.resholve.writeScriptBin "battery-notify" {
    inputs = [ super.libnotify super.coreutils-full ];
    interpreter = "${super.bash}/bin/bash";
  } script;
}
