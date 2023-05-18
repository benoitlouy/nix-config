{ config, pkgs, ... }:

let
  light = "${pkgs.light}/bin/light";
  cava-config = "cava/config-waybar";

  cava-waybar = pkgs.writeShellScriptBin "cava-waybar" ''
    cava -p ${config.xdg.configHome}/${cava-config} | sed -u 's/;//g;s/0/▁/g;s/1/▂/g;s/2/▃/g;s/3/▄/g;s/4/▅/g;s/5/▆/g;s/6/▇/g;s/7/█/g;'
  '';

in
{

  xdg.configFile."${cava-config}".source = ./cava-config-waybar;

  home.packages = [ pkgs.cava ];
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
          # "custom/cava"
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
          # "bluetooth"
          "custom/notification"
          "tray"
        ];
        "custom/cava" = {
          "exec" = "sleep 1s && ${cava-waybar}/bin/cava-waybar";
          "tooltip" = false;
        };
        "wlr/workspaces" = {
          # "format" = "{icon}";
          "format" = "{name}";
          "on-click" = "activate";
        };
        "pulseaudio" = {
          "scroll-step" = 1;
          "format" = "<span size='x-large' rise='-1500'>{icon}</span>  {volume}%";
          "format-muted" = "<span size='x-large' rise='-1500'>󰝟</span>  Muted";
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
          "format" = "<span size='x-large' rise='-1500'>{icon}</span>  {percent}%";
          "format-icons" = [ "󰌶" "󱩎" "󱩏" "󱩐" "󱩑" "󱩒" "󱩓" "󱩔" "󱩕" "󱩖" "󰛨" ];
        };
        "battery" = {
          "interval" = 10;
          "states" = {
            "warning" = 20;
            "critical" = 10;
          };
          "format" = "<span size='x-large' rise='-1500'>{icon}</span>  {capacity}% {power}W";
          "format-icons" = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          "format-full" = "<span size='x-large' rise='-1500'>{icon}</span> {capacity}%";
          "format-charging" = "<span size='x-large' rise='-1500'>󰂄</span> {capacity}%";
          "tooltip" = true;
        };
        "clock" = {
          "interval" = 1;
          "format" = "{:%I:%M %p  %A %b %d}";
          "tooltip" = true;
          "tooltip-format" = "<tt>{calendar}</tt>";
        };
        "memory" = {
          "interval" = 1;
          "format" = "<span size='x-large' rise='-1500'>󰍛</span>  {percentage}%";
          "states" = {
            "warning" = 85;
          };
        };
        "cpu" = {
          "interval" = 1;
          "format" = "<span size='x-large' rise='-1500'>󰊚</span>  {usage}%";
        };
        "network" = {
          "interval" = 1;
          "format-wifi" = "<span size='x-large' rise='-1500'></span>  {essid}";
          "format-ethernet" = "<span size='x-large' rise='-1500'></span>  {ifname} ({ipaddr})";
          "format-linked" = "<span size='x-large' rise='-1500'></span>  {essid} (No IP)";
          "format-disconnected" = "<span size='x-large' rise='-1500'>󰖪</span>  Disconnected";
          "tooltip" = false;
        };
        "tray" = {
          "icon-size" = 25;
          "spacing" = 5;
        };
        "custom/notification" = {
          "tooltip" = false;
          "format" = "<span size='x-large' rise='-1500'></span>";
          # "format" = "{icon}";
          # "format-icons" = {
          #   "notification" = "<span foreground='red'><sup></sup></span>";
          #   "none" = "";
          #   "dnd-notification" = "<span foreground='red'><sup></sup></span>";
          #   "dnd-none" = "";
          #   "inhibited-notification" = "<span foreground='red'><sup></sup></span>";
          #   "inhibited-none" = "";
          #   "dnd-inhibited-notification" = "<span foreground='red'><sup></sup></span>";
          #   "dnd-inhibited-none" = "";
          # };
          # "return-type" = "json";
          # "exec-if" = "which swaync-client";
          # "exec" = "swaync-client -swb";
          "on-click" = "swaync-client -t -sw";
          "on-click-right" = "swaync-client -d -sw";
          # "escape" = true;
        };
      }
    ];
    style = builtins.readFile ./style.css;
  };
}
