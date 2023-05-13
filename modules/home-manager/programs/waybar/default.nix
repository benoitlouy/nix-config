{ config, pkgs, ... }:

let
  light = "${pkgs.light}/bin/light";
in
{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;
    };
    settings = [
      {
        position = "top";
        layer = "top";
        modules-left = [
          "wlr/workspaces"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "pulseaudio"
          "backlight"
          "memory"
          "cpu"
          "network"
          "battery"
          "bluetooth"
          "tray"
        ];
        "wlr/workspaces" = {
          "format" = "{icon}";
          "on-click" = "activate";
        };
        "pulseaudio" = {
          "scroll-step" = 1;
          "format" = "{icon} {volume}%";
          "format-muted" = "󰝟 Muted";
          "format-icons" = {
            "default" = [ "" "" "" ];
          };
          "states" = {
            "warning" = 85;
          };
          "on-click" = "pamixer -t";
          "tooltip" = false;
        };
        "backlight" = {
          # "device" = "intel_backlight";
          "on-scroll-up" = "${light} -A 5";
          "on-scroll-down" = "${light} -U 5";
          "format" = "{icon} {percent}%";
          "format-icons" = [ "" "" "" "" ];
        };
        "battery" = {
          "interval" = 10;
          "states" = {
            "warning" = 20;
            "critical" = 10;
          };
          "format" = "{icon} {capacity}%";
          "format-icons" = [ "" "" "" "" "" "" "" "" "" ];
          "format-full" = "{icon} {capacity}%";
          "format-charging" = " {capacity}%";
          "tooltip" = false;
        };
        "clock" = {
          "interval" = 1;
          "format" = "{:%I:%M %p  %A %b %d}";
          "tooltip" = true;
          "tooltip-format"= "<tt>{calendar}</tt>";
          # "tooltip-format" = "上午：高数\n下午：Ps\n晚上：Golang\n<tt>{calendar}</tt>";
        };
        "memory" = {
          "interval" = 1;
          "format" = "󰍛 {percentage}%";
          "states" = {
            "warning" = 85;
          };
        };
        "cpu" = {
          "interval" = 1;
          "format" = "󰊚 {usage}%";
        };
        "network" = {
          "interval" = 1;
          "format-wifi" = "  {essid}";
          # "format-wifi" = "說 {essid}";
          "format-ethernet" = "  {ifname} ({ipaddr})";
          "format-linked" = "  {essid} (No IP)";
          "format-disconnected" = "󰖪  Disconnected";
          "tooltip" = false;
        };
        "tray" = {
          "icon-size" = 15;
          "spacing" = 5;
        };
      }
    ];
    style = ''
             * {
               font-family: "JetBrainsMono Nerd Font";
               font-size: 12pt;
               font-weight: bold;
               border-radius: 0px;
               transition-property: background-color;
               transition-duration: 0.5s;
             }
             @keyframes blink_red {
               to {
                 background-color: rgb(242, 143, 173);
                 color: rgb(26, 24, 38);
               }
             }
             .warning, .critical, .urgent {
               animation-name: blink_red;
               animation-duration: 1s;
               animation-timing-function: linear;
               animation-iteration-count: infinite;
               animation-direction: alternate;
             }
             window#waybar {
               background-color: transparent;
             }
             window > box {
               margin-left: 5px;
               margin-right: 5px;
               margin-top: 5px;
               background-color: rgb(30, 30, 46);
             }
       #workspaces {
               padding-left: 0px;
               padding-right: 4px;
             }
       #workspaces button {
               padding-top: 5px;
               padding-bottom: 5px;
               padding-left: 6px;
               padding-right: 6px;
             }
       #workspaces button.active {
               background-color: rgb(181, 232, 224);
               color: rgb(26, 24, 38);
             }
       #workspaces button.urgent {
               color: rgb(26, 24, 38);
             }
       #workspaces button:hover {
               background-color: rgb(248, 189, 150);
               color: rgb(26, 24, 38);
             }
             tooltip {
               background: rgb(48, 45, 65);
             }
             tooltip label {
               color: rgb(217, 224, 238);
             }
       #custom-launcher {
               font-size: 20px;
               padding-left: 8px;
               padding-right: 6px;
               color: #7ebae4;
             }
       #mode, #clock, #memory, #temperature,#cpu,#mpd, #custom-wall, #temperature, #backlight, #pulseaudio, #network, #battery, #custom-powermenu, #custom-cava-internal {
               padding-left: 10px;
               padding-right: 10px;
             }
             /* #mode { */
             /* 	margin-left: 10px; */
             /* 	background-color: rgb(248, 189, 150); */
             /*     color: rgb(26, 24, 38); */
             /* } */
       #memory {
               color: rgb(181, 232, 224);
             }
       #cpu {
               color: rgb(245, 194, 231);
             }
      #bluetooth {
               color: rgb(95, 133, 227);

      }
       #clock {
               color: rgb(217, 224, 238);
             }
      /* #idle_inhibitor {
               color: rgb(221, 182, 242);
             }*/
       #custom-wall {
               color: rgb(221, 182, 242);
          }
       #temperature {
               color: rgb(150, 205, 251);
             }
       #backlight {
               color: rgb(248, 189, 150);
             }
       #pulseaudio {
               color: rgb(245, 224, 220);
             }
       #network {
               color: #ABE9B3;
             }

       #network.disconnected {
               color: rgb(255, 255, 255);
             }
       #battery.charging, #battery.full, #battery.discharging {
               color: rgb(250, 227, 176);
             }
       #battery.critical:not(.charging) {
               color: rgb(242, 143, 173);
             }
       #custom-powermenu {
               color: rgb(242, 143, 173);
             }
       #tray {
               padding-right: 8px;
               padding-left: 10px;
             }
       #mpd.paused {
               color: #414868;
               font-style: italic;
             }
       #mpd.stopped {
               background: transparent;
             }
       #mpd {
               color: #c0caf5;
             }
       #custom-cava-internal{
               font-family: "Hack Nerd Font" ;
             }
    '';
  };
}
