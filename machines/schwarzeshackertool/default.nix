{ config, lib, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ../../configuration.nix ];

  nix.maxJobs = lib.mkDefault 8;

  boot.supportedFilesystems = [ "zfs" ];
  hardware.enableRedistributableFirmware = true;

  networking = {
    hostId = "9bdce388";
    hostName = "schwarzeshackertool";
    interfaces.enp0s31f6.useDHCP = true;
    interfaces.wlp58s0.useDHCP = true;
    networkmanager.enable = true;
  };

  # ZFS related
  services.zfs.autoScrub.enable = true;
  # Against Tearing
  services.picom =
    {
      enable = true;
      vSync = true;
      experimentalBackends = true;
    };
  # services.sanoid =
  #   let
  #     # templates not working correctly because of kinda broken sanoid config
  #     # (default values, which aren't overwritten by templates)
  #     default-dataset = {
  #       daily = 7;
  #       hourly = 48;
  #       monthly = 5;
  #       yearly = 0;
  #     };
  #     default-settings = {
  #       frequent_period = 2;
  #       frequently = 60;
  #     };
  #   in
  #   {
  #     enable = true;
  #     interval = "minutely";
  #     settings = {
  #       "rpool/safe/root" = default-settings;
  #       "rpool/safe/home" = default-settings;
  #     };
  #     datasets = {
  #       "rpool/safe/root" = default-dataset;
  #       "rpool/safe/home" = default-dataset;
  #     };
  #   };

  services.thermald.enable = true;

  home-manager.users.robert.services.cbatticon = {
    enable = true;
    commandCriticalLevel = ''notify-send "battery critical!"'';
  };
}
