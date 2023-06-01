self: super:

let
  sleep = super.makeDesktopItem {
    name = "sleep";
    exec = "systemctl suspend";
    desktopName = "Sleep";
    icon = "preferences-desktop-screensaver-symbolic";
  };

  reboot = super.makeDesktopItem {
    name = "reboot";
    exec = "systemctl reboot";
    desktopName = "Reboot";
    icon = "system-reboot-symbolic";
  };

  shutdown = super.makeDesktopItem {
    name = "shutdown";
    exec = "systemctl poweroff";
    desktopName = "Shutdown";
    icon = "system-shutdown-symbolic";
  };
in
{
  power-desktop-items = super.stdenv.mkDerivation {
    pname = "power-desktop-items";
    version = "1.0.0";

    unpackPhase = ":";

    nativeBuildInputs = [
      super.copyDesktopItems
    ];

    desktopItems = [
      sleep
      reboot
      shutdown
    ];

  };
}
