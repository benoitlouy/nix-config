# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  nix = {
    # package = pkgs.nixVersions.git;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-z13-gen1
    ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-bd9ab54d-dcc0-495f-84ba-4ba677076718".device = "/dev/disk/by-uuid/bd9ab54d-dcc0-495f-84ba-4ba677076718";
  boot.initrd.luks.devices."luks-bd9ab54d-dcc0-495f-84ba-4ba677076718".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  networking.networkmanager.plugins = [
    pkgs.networkmanager-openvpn
  ];
  # networking.networkmanager.wifi.backend = "iwd";
  #
  # networking.wireless.iwd = {
  #   enable = true;
  #
  #   settings = {
  #     Network = {
  #       EnableIPv6 = true;
  #     };
  #     Settings = {
  #       AutoConnect = true;
  #     };
  #   };
  # };

  networking.firewall.allowedTCPPorts = [
    # Sonos
    1400
    8080
    9090
  ];

  # support SSDP https://serverfault.com/a/911286/9166
  networking.firewall.extraPackages = [ pkgs.ipset ];
  networking.firewall.extraCommands = ''
    if ! ipset --quiet list upnp; then
      ipset create upnp hash:ip,port timeout 3
    fi
    iptables -A OUTPUT -d 239.255.255.250/32 -p udp -m udp --dport 1900 -j SET --add-set upnp src,src --exist
    iptables -A nixos-fw -p udp -m set --match-set upnp dst,dst -j nixos-fw-accept
  '';


  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.displayManager.lightdm.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    browsed.enable = false;
  };
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.openFirewall = true;

  # Enable sound with pipewire.
  # sound.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  hardware.alsa.enablePersistence = true;

  # # ALSA provides a udev rule for restoring volume settings.
  # services.udev.packages = [ pkgs.alsa-utils ];
  #
  # systemd.services.alsa-store =
  #   { description = "Store Sound Card State";
  #     wantedBy = [ "multi-user.target" ];
  #     unitConfig.RequiresMountsFor = "/var/lib/alsa";
  #     unitConfig.ConditionVirtualization = "!systemd-nspawn";
  #     serviceConfig = {
  #       Type = "oneshot";
  #       RemainAfterExit = true;
  #       ExecStart = "${pkgs.coreutils}/bin/mkdir -p /var/lib/alsa";
  #       ExecStop = "${pkgs.alsa-utils}/sbin/alsactl store --ignore";
  #     };
  #   };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.blouy = {
    isNormalUser = true;
    description = "Benoit Louy";
    extraGroups = [ "networkmanager" "wheel" "video" "scanner" "lp" "docker" "dialout" "jackaudio" ];
    packages = with pkgs; [
      firefox
      # chromium
      # floorp
      #  thunderbird
    ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    _1password-cli
    _1password-gui
    qt6.qtwayland
    libsForQt5.qt5.qtwayland
    killall
    xdph-launcher
    pamixer
    networkmanagerapplet
    file
    # alsa-utils
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  programs.zsh.enable = true;

  programs._1password = {
    enable = true;
  };

  # Enable the 1Passsword GUI with myself as an authorized user for polkit
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "blouy" ];
  };

  # for screen recording to work without admin password
  programs.gpu-screen-recorder.enable = true;

  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        zen
      ''; # or just "zen" if you use unwrapped package
      mode = "0755";
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      # xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = "*";
      };
    };
  };

  services.tlp = {
    enable = false;
    settings = {
      CPU_ENERGY_PERF_POLICY_ON_AC= "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT= "power";

      PLATFORM_PROFILE_ON_AC = "balanced";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      START_CHARGE_THRESH_BAT0 = 95;
      STOP_CHARGE_THRESH_BAT0 = 100;

      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      RESTORE_THRESHOLDS_ON_BAT = 1;
    };
  };

  services.thermald = {
    enable = true;
  };

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  powerManagement = {
    enable = true;
  };

  services.blueman.enable = true;

  services.fwupd.enable = true;

  services.dbus.packages = [ pkgs.gcr ];

  services.fprintd.enable = false;

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="054c", ATTR{idProduct}=="0287", MODE:="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="054c", ATTR{idProduct}=="0286", MODE:="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="054c", ATTR{idProduct}=="0188", MODE:="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="5341", ATTR{idProduct}=="5256", MODE:="0666"
  '';

}
