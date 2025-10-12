{ pkgs, inputs, ... }:
{
  # home.packages = [
  #   inputs.quickshell.packages.${pkgs.system}.default
  #   inputs.caelestia-shell.packages.${pkgs.system}.default
  # ];

  programs.caelestia = {
    enable = true;
    systemd = {
      enable = true; # if you prefer starting from your compositor
      target = "graphical-session.target";
      environment = [];
    };
    settings = {
      general = {
        battery = {
          warnLevels = [
            {
                level = 20;
                title = "Low battery YO";
                message = "You might want to plug in a charger";
                icon = "battery-low";
                # icon = "battery_android_frame_2";
            }
            {
                level = 10;
                title = "Did you see the previous message?";
                message = "You should probably plug in a charger <b>now</b>";
                icon = "battery-low";
            }
            {
                level = 5;
                title = "Critical battery level";
                message = "PLUG THE CHARGER RIGHT NOW!!";
                icon = "battery-caution";
                critical = true;
            }
          ];
          criticalLevel = 3;
        };
      };
      bar.status = {
        showBattery = true;
        showAudio = true;
      };
      sidebar = {
        enabled = true;
      };
      osd = {
        enableMicrophone = true;
      };
      launcher = {
        enableDangerousActions = true;
      };
      paths.wallpaperDir = "/home/blouy/Pictures/Wallpapers";
      services = {
        useTwelveHourClock = false;
        useFahrenheit = false;
      };
    };
    cli = {
      enable = true; # Also add caelestia-cli to path
      settings = {
        theme.enableGtk = false;
      };
    };
  };
}
