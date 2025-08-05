{ inputs, nixpkgsConfig, homeManagerModules, ... }:

let
  inherit (inputs.nixpkgs.lib) nixosSystem;

  common = {
    nixpkgs = nixpkgsConfig;
    systemd.user.extraConfig = ''
      DefaultEnvironment="PATH=/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
    '';
  };

  home-manager = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs =  {
        inherit inputs;
      };
    }
  ];

  users = import ../users { inherit inputs homeManagerModules; };

  blouy = users.blouy {
    extraModules = [
      inputs.hyprland.homeManagerModules.default
      ../modules/home-manager/programs/hyprland
      ../modules/home-manager/programs/swaync
      # ../modules/home-manager/programs/mako
      ../modules/home-manager/programs/waybar
      ../modules/home-manager/programs/rofi
      ../modules/home-manager/programs/streamlink
      ../modules/home-manager/programs/cider
      ../modules/home-manager/programs/webcord
      ../modules/home-manager/programs/nemo
      ../modules/home-manager/programs/cliphist
      ../modules/home-manager/programs/audio
      ../modules/home-manager/services/gpg-agent
      ../modules/home-manager/programs/swww
      ../modules/home-manager/programs/anyrun
      ../modules/home-manager/services/gammastep
      # ../modules/home-manager/programs/deltachat
      ../users/blouy/sops.nix
      ../modules/home-manager/programs/tuba
      ../modules/home-manager/programs/signal
      ../modules/home-manager/services/playerctld
      ../modules/home-manager/programs/fcitx5
      ../modules/home-manager/programs/grimblast
      ../modules/home-manager/programs/imv
      ../modules/home-manager/services/kanshi
      ../modules/home-manager/services/syncthing
      ../modules/home-manager/programs/gtk
      ../modules/home-manager/programs/tv
      ../modules/home-manager/programs/darktable
      ../modules/home-manager/programs/anytype
      # ../modules/home-manager/programs/playonlinux
      ../modules/home-manager/programs/tytools
      ../modules/home-manager/programs/hyprlock
      ../modules/home-manager/services/hypridle
      ../modules/home-manager/programs/obs
      ../modules/home-manager/programs/davinci
      ../modules/home-manager/programs/calibre
      ../modules/home-manager/programs/bluebubbles
      ../modules/home-manager/programs/plexamp
      {
        targets.genericLinux = {
          enable = true;
        };
      }
    ];
  };

in
{
  L = nixosSystem rec {
    system = "x86_64-linux";
    specialArgs = { inherit inputs system; };
    modules = [
      ./L/configuration.nix
      ../modules/keymap.nix
      # inputs.lix-module.nixosModules.default
      inputs.nix-snapd.nixosModules.default
      {
        services.snap.enable = true;
      }
      common
      inputs.sops-nix.nixosModules.sops
      {
        sops.defaultSopsFile = ../secrets/L/secrets.yaml;
        sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        # This is using an age key that is expected to already be in the filesystem
        sops.age.keyFile = "/var/lib/sops-nix/key.txt";
        # This will generate a new key if the key specified above does not exist
        sops.age.generateKey = true;
        # sops.secrets.hello = { };
      }
      ../modules/nixos/hyprland
      ../modules/nixos/fonts.nix
      ../modules/nixos/light.nix
      ../modules/nixos/polkit
      ../modules/nixos/avizo
      ../modules/nixos/swaync
      ../modules/nixos/geoclue2
      ../modules/nixos/keyring
      ../modules/nixos/i18n
      ../modules/nixos/iphone
      ../modules/nixos/openvpn
      ../modules/nixos/qmk
      ../modules/nixos/upgrade-diff
      ../modules/nixos/docker
      ../modules/nixos/flatpak
      ../modules/nixos/steam
      ../modules/nixos/jack
      ../modules/nixos/localsend
      # (import ../modules/nixos/virtualbox { vboxUsers = [ "blouy" ]; })
      {
        services.openssh.enable = true;
        home-manager.sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
      }
    ] ++ home-manager ++ [ blouy ];
  };
}
