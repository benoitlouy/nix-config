{ vboxUsers }: { config, pkgs, ... }:
{
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = vboxUsers;

  environment.systemPackages = [
    pkgs.virtualbox
  ];
}
