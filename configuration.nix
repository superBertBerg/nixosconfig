# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, options, lib, nixpkgs-unstable, ... }:
{
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    autoOptimiseStore = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  # boot.kernelModules = [ "v4l2loopback" ];

  boot.tmpOnTmpfs = true;

  system.stateVersion = "20.11";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IE.UTF-8";

  console.font = "Lat2-Terminus16";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  hardware.opengl = {
    enable = true;
    # Enable 32-bit dri support for steam
    driSupport32Bit = true;
    extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    setLdLibraryPath = true;
  };

  # Enable audio
  # Not strictly required but pipewire will use rtkit if it is present
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    # Compatibility shims, adjust according to your needs
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  # debugging of local webservices from external devices like smartphones
  # networking.firewall.allowedTCPPorts = [ 80 443 8080 8081 8000 8001 3000 6600 7201 ];
  # networking.firewall.allowedUDPPorts = [ 80 443 8080 8081 8000 8001 3000 6600 7201 ];
  # networking.firewall.allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
  # networking.firewall.allowedUDPPortRanges = [{ from = 1714; to = 1764; }];
  # networking.firewall.enable = false;

  # networking.hosts = { "127.0.0.1" = [ "work" "www" "spa-test" ]; };
  #
  # # nginx is sandboxed and doesn't allow reading from /home
  # systemd.services.nginx.serviceConfig = {
  #   ProtectSystem = lib.mkForce false;
  #   ProtectHome = lib.mkForce false;
  # };
  # services.nginx = {
  #   user = "robert"; # because all content is served locally in home for testing
  #   enable = true;
  #   recommendedGzipSettings = true;
  #   virtualHosts = {
  #     "work" = {
  #       root = "/home/robert/dev/work/";
  #       locations."/".extraConfig = "autoindex on;";
  #     };
  #     "www" = {
  #       default = true;
  #       root = "/home/robert/dev/personal/www/";
  #       locations."/".extraConfig = "autoindex on;";
  #     };
  #     "spa-test" = {
  #       # simple test for SPAs, that need to use / with normal history routing
  #       root = "/home/robert/dev/personal/www/spa-test";
  #       locations."/".extraConfig = ''
  #         try_files $uri $uri/ /index.html;
  #         autoindex on;
  #       '';
  #     };
  #   };
  # };

  # List of systemwide services

  virtualisation.docker.enable = true;
  # virtualisation.virtualbox.host = {
  #   enable = true;
  #   enableHardening = false;
  #   enableExtensionPack = true;
  # };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
  };

  # Enable the X11 windowing system.

  # services.autorandr.enable = true;

  services.xserver = {
    enable = true;
    autoRepeatInterval = 15;
    autoRepeatDelay = 300;
    # Enable touchpad support.
    libinput.enable = true;
    # Use session defined in home.nix
    displayManager = {
      defaultSession = "none+i3";
      # this prevents accidentally turned on caps lock in the login manager (as it is remapped in the xmonad session to escape)
      sessionCommands = "${pkgs.xorg.xmodmap}/bin/xmodmap -e 'clear Lock'";
    };
    windowManager = {
      session = [
        {
          name = "i3";
          bgSupport = true;
          start = ''
            ${pkgs.runtimeShell} $HOME/.xsession &
            waitPID=$!
          '';
        }
      ];
    };
  };

  # gtk themes (home-manager more specifically) seem to have problems without it
  services.dbus.packages = [ pkgs.gnome3.dconf ];
  programs.dconf.enable = true;

  xdg.portal.enable = true;
  services.flatpak.enable = true;

  # allow no password for sudo (dangerous...)
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.robert = {
    isNormalUser = true;
    home = "/home/robert";
    shell = pkgs.fish;
    extraGroups = [
      "audio"
      "dialout"
      "networkmanager"
      "systemd-journal"
      "adbusers"
      "video"
      "power"
      "wheel" # Enable ‘sudo’ for the user.
      "docker"
    ];
  };
  # users.extraGroups.vboxusers.members = [ "robert" ];

  # All system wide packages

  programs.fish.enable = true;

  programs.adb.enable = true;

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
  };

  programs.steam.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; let unstable = nixpkgs-unstable.pkgs; in
  [
    # DEVELOPMENT
    ## compilers and dev environment
    # clang_10 # conflicts with gcc
    python39Full
    python39Packages.pip
    python39Packages.setuptools
    gcc10
    gdb
    meson
    cmake
    git
    git-secret
    git-crypt
    php
    yarn
    nodejs_latest
    rustup
    steam-run

    # TERMINAL/CLI
    file
    htop
    killall
    lsd
    lshw
    pciutils
    ripgrep
    fd
    tokei
    du-dust
    bandwhich
    unzip
    zip
    unrar
    p7zip

    # AUDIO
    pavucontrol
    ffmpeg-full

    # COMMUNICATION
    signal-desktop
    unstable.tdesktop
    discord
    v4l-utils

    # WEB
    chromium
    firefox

    # XORG/DESKTOP ENVIRONMENT
    dmenu
    wmctrl
    xorg.xev
    xorg.xinit
    xorg.xmessage
    xorg.xkill
    xorg.xwininfo

    # MISC
    exfat-utils
    gsettings-desktop-schemas
    appimage-run
    ntfs3g
    acpi
    appimage-run
    powertop
    usbutils
    patchelf
    memtester
    docker-compose
    filezilla
    scrot
    feh # to view images in terminal
    smartmontools
    rdfind
    rage
    imagemagick
    xclip
  ];

  fonts.fonts = with pkgs; [ nerdfonts google-fonts ];
}
