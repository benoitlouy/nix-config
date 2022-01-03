{ config, pkgs, ... }:

let
  hm = import <home-manager> {};
in {

  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
    experimental-features = nix-command flakes
  '';

  imports = [ <home-manager/nix-darwin> ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      hm.home-manager
    ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nixUnstable;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  users.users.blouy = {
    name = "blouy";
    home = "/Users/blouy";
  };
  # home-manager.users.blouy = { pkgs, ... }: {
  #   home.packages = [  ];
  # };
  home-manager.useUserPackages = true;

  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = true;
    config = {
      focus_follows_mouse          = "autoraise";
      mouse_follows_focus          = "on";
      window_placement             = "second_child";
      window_opacity               = "off";
      window_opacity_duration      = "0.0";
      window_border                = "off";
      window_border_placement      = "inset";
      window_border_width          = 2;
      window_border_radius         = 3;
      active_window_border_topmost = "off";
      window_topmost               = "off";
      window_shadow                = "on";
      active_window_border_color   = "0xff5c7e81";
      normal_window_border_color   = "0xff505050";
      insert_window_border_color   = "0xffd75f5f";
      active_window_opacity        = "1.0";
      normal_window_opacity        = "1.0";
      split_ratio                  = "0.50";
      auto_balance                 = "off";
      mouse_modifier               = "fn";
      mouse_action1                = "move";
      mouse_action2                = "resize";
      layout                       = "bsp";
      top_padding                  = 20;
      bottom_padding               = 20;
      left_padding                 = 20;
      right_padding                = 20;
      window_gap                   = 10;
    };
  };

  services.skhd = {
    enable = true;
    package = pkgs.skhd;
    skhdConfig = ''
      # open terminal
      cmd - return : /Applications/Kitty.app/Contents/MacOS/kitty --single-instance -d ~
      cmd + shift - e : open /Applications/Helium.app

      # focus window
      alt - h : yabai -m window --focus west
      alt - j : yabai -m window --focus south
      alt - k : yabai -m window --focus north
      alt - l : yabai -m window --focus east

      # swap window
      shift + alt - h : yabai -m window --swap west
      shift + alt - j : yabai -m window --swap south
      shift + alt - k : yabai -m window --swap north
      shift + alt - l : yabai -m window --swap east

      # move window
      shift + cmd - h : yabai -m window --warp west
      shift + cmd - j : yabai -m window --warp south
      shift + cmd - k : yabai -m window --warp north
      shift + cmd - l : yabai -m window --warp east

      # balance size of windows
      shift + alt - 0 : yabai -m space --balance

      # make floating window fill screen
      shift + alt - up     : yabai -m window --grid 1:1:0:0:1:1

      # make floating window fill left-half of screen
      shift + alt - left   : yabai -m window --grid 1:2:0:0:1:1

      # make floating window fill right-half of screen
      shift + alt - right  : yabai -m window --grid 1:2:1:0:1:1

      # create desktop, move window and follow focus - uses jq for parsing json (brew install jq)
      shift + cmd - n : yabai -m space --create && \
                        index="$(yabai -m query --spaces --display | jq 'map(select(."native-fullscreen" == 0))[-1].index')" && \
                        yabai -m window --space "''${index}" && \
                        yabai -m space --focus "''${index}"

      # create desktop and follow focus - uses jq for parsing json (brew install jq)
      cmd + alt - n : yabai -m space --create && \
                      index="$(yabai -m query --spaces --display | jq 'map(select(."native-fullscreen" == 0))[-1].index')" && \
                      yabai -m space --focus "''${index}"

      # destroy desktop
      cmd + alt - w : yabai -m space --destroy

      # fast focus desktop
      cmd + alt - x : yabai -m space --focus recent
      cmd + alt - z : yabai -m space --focus prev
      cmd + alt - c : yabai -m space --focus next
      cmd + alt - 1 : yabai -m space --focus 1
      cmd + alt - 2 : yabai -m space --focus 2
      cmd + alt - 3 : yabai -m space --focus 3
      cmd + alt - 4 : yabai -m space --focus 4
      cmd + alt - 5 : yabai -m space --focus 5
      cmd + alt - 6 : yabai -m space --focus 6
      cmd + alt - 7 : yabai -m space --focus 7
      cmd + alt - 8 : yabai -m space --focus 8
      cmd + alt - 9 : yabai -m space --focus 9
      cmd + alt - 0 : yabai -m space --focus 10

      # send window to desktop and follow focus
      shift + cmd - x : yabai -m window --space recent; yabai -m space --focus recent
      shift + cmd - z : yabai -m window --space prev; yabai -m space --focus prev
      shift + cmd - c : yabai -m window --space next; yabai -m space --focus next
      shift + cmd - 1 : yabai -m window --space  1; yabai -m space --focus 1
      shift + cmd - 2 : yabai -m window --space  2; yabai -m space --focus 2
      shift + cmd - 3 : yabai -m window --space  3; yabai -m space --focus 3
      shift + cmd - 4 : yabai -m window --space  4; yabai -m space --focus 4
      shift + cmd - 5 : yabai -m window --space  5; yabai -m space --focus 5
      shift + cmd - 6 : yabai -m window --space  6; yabai -m space --focus 6
      shift + cmd - 7 : yabai -m window --space  7; yabai -m space --focus 7
      shift + cmd - 8 : yabai -m window --space  8; yabai -m space --focus 8
      shift + cmd - 9 : yabai -m window --space  9; yabai -m space --focus 9
      shift + cmd - 0 : yabai -m window --space 10; yabai -m space --focus 10

      # focus monitor
      ctrl + alt - x  : yabai -m display --focus recent
      ctrl + alt - z  : yabai -m display --focus prev
      ctrl + alt - c  : yabai -m display --focus next
      ctrl + alt - 1  : yabai -m display --focus 1
      ctrl + alt - 2  : yabai -m display --focus 2
      ctrl + alt - 3  : yabai -m display --focus 3

      # send window to monitor and follow focus
      ctrl + cmd - x  : yabai -m window --display recent; yabai -m display --focus recent
      ctrl + cmd - z  : yabai -m window --display prev; yabai -m display --focus prev
      ctrl + cmd - c  : yabai -m window --display next; yabai -m display --focus next
      ctrl + cmd - 1  : yabai -m window --display 1; yabai -m display --focus 1
      ctrl + cmd - 2  : yabai -m window --display 2; yabai -m display --focus 2
      ctrl + cmd - 3  : yabai -m window --display 3; yabai -m display --focus 3

      # move window
      shift + ctrl - a : yabai -m window --move rel:-20:0
      shift + ctrl - s : yabai -m window --move rel:0:20
      shift + ctrl - w : yabai -m window --move rel:0:-20
      shift + ctrl - d : yabai -m window --move rel:20:0

      # increase window size
      shift + alt - a : yabai -m window --resize left:-40:0; yabai -m window --resize right:-40:0
      shift + alt - s : yabai -m window --resize bottom:0:40; yabai -m window --resize top:0:40
      shift + alt - w : yabai -m window --resize top:0:-40; yabai -m window --resize bottom:0:-40
      shift + alt - d : yabai -m window --resize right:40:0; yabai -m window --resize left:40:0

      # decrease window size
      #shift + cmd - a : yabai -m window --resize left:20:0
      #shift + cmd - s : yabai -m window --resize bottom:0:-20
      #shift + cmd - w : yabai -m window --resize top:0:20
      #shift + cmd - d : yabai -m window --resize right:-20:0

      # set insertion point in focused container
      ctrl + alt - h : yabai -m window --insert west
      ctrl + alt - j : yabai -m window --insert south
      ctrl + alt - k : yabai -m window --insert north
      ctrl + alt - l : yabai -m window --insert east

      # rotate tree
      alt - r : yabai -m space --rotate 90

      # mirror tree y-axis
      alt - y : yabai -m space --mirror y-axis

      # mirror tree x-axis
      alt - x : yabai -m space --mirror x-axis

      # toggle desktop offset
      alt - a : yabai -m space --toggle padding; yabai -m space --toggle gap

      # toggle window parent zoom
      alt - d : yabai -m window --toggle zoom-parent

      # toggle window fullscreen zoom
      alt - f : yabai -m window --toggle zoom-fullscreen

      # toggle window native fullscreen
      shift + alt - f : yabai -m window --toggle native-fullscreen

      # toggle window border
      shift + alt - b : yabai -m window --toggle border

      # toggle window split type
      shift + alt - e : yabai -m window --toggle split

      # float / unfloat window and center on screen
      alt - t : yabai -m window --toggle float;\
                yabai -m window --grid 4:4:1:1:2:2

      # toggle sticky
      alt - s : yabai -m window --toggle sticky

      # toggle sticky, float and resize to picture-in-picture size
      alt - p : yabai -m window --toggle sticky;\
                yabai -m window --toggle topmost;\
                yabai -m window --grid 5:5:4:0:1:1
      #          yabai -m window --toggle pip

      alt - u : yabai -m window --toggle topmost

      # change layout of desktop
      ctrl + alt - a : yabai -m space --layout bsp
      ctrl + alt - d : yabai -m space --layout float

      ctrl + alt - t : yabai -m window --toggle topmost
    '';
  };
}
