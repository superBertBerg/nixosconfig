{ config, lib, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ../../configuration.nix ];

  nix.settings.max-jobs = lib.mkDefault 8;

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  hardware.enableRedistributableFirmware = true;

  networking = {
    hostId = "02b3f88d";
    hostName = "schwarzerhackerstein";
    interfaces.enp39s0.useDHCP = true;
    interfaces.wlp41s0.useDHCP = true;
  
    networkmanager.enable = true;
    # may result in problems in networks that require a login page
    networkmanager.dns = "none";
    nameservers = [ "1.1.1.1"];
  
  };
  # Installs the NVIDIA driver; still required under Wayland (COSMIC) for XWayland.
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia.open = true;
  hardware.nvidia-container-toolkit.enable = true;

  services.thermald.enable = true;
}
