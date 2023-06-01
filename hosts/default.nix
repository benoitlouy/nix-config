{ inputs, nixpkgsConfig, homeManagerModules, ... }:

let
  inherit (inputs.nixpkgs.lib) nixosSystem attrValues;

  common = {
    nixpkgs = nixpkgsConfig;
  };

  home-manager = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
    }
  ];

  users = import ../users { inherit inputs homeManagerModules; };

  blouy = users.blouy {
    extraModules = [
      inputs.hyprland.homeManagerModules.default
      ../modules/home-manager/programs/hyprland
      ../modules/home-manager/programs/swaync
      ../modules/home-manager/programs/mako
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
      ../modules/home-manager/programs/deltachat
      ../users/blouy/sops.nix
      ../modules/home-manager/programs/tootle
      ../modules/home-manager/programs/signal
      ../modules/home-manager/services/playerctld
      ../modules/home-manager/programs/fcitx5
      ../modules/home-manager/programs/grimblast
      ../modules/home-manager/programs/imv
      ../modules/home-manager/services/kanshi
      ../modules/home-manager/services/syncthing
    ];
  };

in
{
  L = nixosSystem rec {
    system = "x86_64-linux";
    specialArgs = { inherit inputs system; };
    modules = [
      ./L/configuration.nix
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
      ../modules/nixos/swaylock
      ../modules/nixos/swayidle
      ../modules/nixos/fonts.nix
      ../modules/nixos/light.nix
      ../modules/nixos/polkit
      ../modules/nixos/avizo
      ../modules/nixos/swaync
      ../modules/nixos/geoclue2
      ../modules/nixos/keyring
      ../modules/nixos/i18n
      ../modules/nixos/iphone
      (import ../modules/nixos/virtualbox { vboxUsers = [ "blouy" ]; })
      {
        services.openssh.enable = true;
        home-manager.sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
      }
    ] ++ home-manager ++ [ blouy ];
  };
}
