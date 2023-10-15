{ config, lib, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ../../configuration.nix ];

  nix.settings.max-jobs = lib.mkDefault 8;

  boot.supportedFilesystems = [ "zfs" ];
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
  services.xserver = {
    videoDrivers = ["nvidia"];
    screenSection = ''
      Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
      Option         "AllowIndirectGLXProtocol" "off"
      Option         "TripleBuffer" "on"
    '';
  };
  # Against Tearing
  services.picom =
    {
      enable = true;
      # unredir-if-possible = false;
      backend = "glx"; # try "glx" if xrender doesn't help
      vSync = true;
    };

  services.thermald.enable = true;
}
