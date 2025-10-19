{ pkgs, ... }:
{

  home.packages = [
    pkgs.material-icons
  ];

  programs.caelestia = {
    enable = true;
    systemd = {
      enable = true; # if you prefer starting from your compositor
      target = "graphical-session.target";
      environment = [];
    };
    settings = {
      general = {
        apps = {
          terminal = ["ghostty"];
          audio = ["pavucontrol"];
          playback = ["mpv"];
          explorer = ["nemo"];
        };
        # battery = {
        #   warnLevels = [
        #     {
        #         level = 20;
        #         title = "Low battery YO";
        #         message = "You might want to plug in a charger";
        #         icon = "battery-low";
        #         # icon = "battery_android_frame_2";
        #     }
        #     {
        #         level = 10;
        #         title = "Did you see the previous message?";
        #         message = "You should probably plug in a charger <b>now</b>";
        #         icon = "battery-low";
        #     }
        #     {
        #         level = 5;
        #         title = "Critical battery level";
        #         message = "PLUG THE CHARGER RIGHT NOW!!";
        #         icon = "battery-caution";
        #         critical = true;
        #     }
        #   ];
        #   criticalLevel = 3;
        # };
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
      notifs = {
        actionOnClick = true;
      };
      paths.wallpaperDir = "/home/blouy/Pictures/Wallpapers";
      services = {
        maxVolume = 2.0;
        defaultPlayer = "Cider";
        useTwelveHourClock = false;
        useFahrenheit = false;
      };
      utilities = {
        vpn = {
          enabled = false;
          provider = [
            {
                name = "T";
                interface = "T";
                displayName = "T";
                connectCmd = ["${pkgs.networkmanager}/bin/nmcli" "connection" "up" "T"];
                disconnectCmd = ["${pkgs.networkmanager}/bin/nmcli" "connection" "down" "T"];
            }
          ];
        };
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
