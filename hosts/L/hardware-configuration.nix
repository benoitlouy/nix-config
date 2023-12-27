# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/91966d67-e44e-476f-a397-7524d0958cf9";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-12212051-5a7c-4909-95f3-9300cbc03440".device = "/dev/disk/by-uuid/12212051-5a7c-4909-95f3-9300cbc03440";

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/CADB-792F";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/2d5023a7-9620-4390-a510-bc09d01377b7"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp100s0f4u1u3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # high-resolution display
  # hardware.video.hidpi.enable = lib.mkDefault true;

  hardware.bluetooth.enable = true;

  hardware.amdgpu.amdvlk = true;

  hardware.amdgpu.opencl = true;
}
