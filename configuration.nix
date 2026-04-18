# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, options, lib, nixpkgs-unstable, ... }:
{
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.auto-optimise-store = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.extraModprobeConfig = "options hid_apple fnmode=0";
  # boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  # boot.kernelModules = [ "v4l2loopback" ];

  boot.tmp.useTmpfs = false;

  system.stateVersion = "23.05";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IE.UTF-8";

  # console.font = "Lat2-Terminus16";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";
  # services.timesyncd.enable = false;
  hardware.graphics = {
    enable = true;
    # Enable 32-bit dri support for steam
    enable32Bit = true;
    extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
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
  networking.firewall = {
    allowedTCPPorts = [ 25565 5020 9695 3000 8020 8060 8000 5432 ];
    allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
  };
  networking.extraHosts = 
  ''
  127.0.0.1       localhost            fusionauth            minio        user-management            hasura-functions            hasura
  '';
  # Enable WireGuard
  # networking.wireguard.interfaces = {
  #   # "wg0" is the network interface name. You can name the interface arbitrarily.
  #   wg0 = {
  #     # Determines the IP address and subnet of the client's end of the tunnel interface.
  #     ips = [ "10.100.0.2/24" ];
  #     listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

  #     # Path to the private key file.
  #     #
  #     # Note: The private key can also be included inline via the privateKey option,
  #     # but this makes the private key world-readable; thus, using privateKeyFile is
  #     # recommended.
  #     privateKeyFile = "/home/robert/wireguard-keys/private";

  #     peers = [
  #       # For a client configuration, one peer entry for the server will suffice.

  #       {
  #         # Public key of the server (not a file path).
  #         publicKey = "vul6wXx0RaykQvPDgwGBmykntvCt+kk6TCiY6GWEZig=";

  #         # Forward all the traffic via VPN.
  #         allowedIPs = [ "0.0.0.0/0" ];
  #         # Or forward only particular subnets
  #         #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];

  #         # Set this to the server IP and port.
  #         endpoint = "202.61.237.213:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

  #         # Send keepalives every 25 seconds. Important to keep NAT tables alive.
  #         persistentKeepalive = 25;
  #       }
  #     ];
  #   };
  # };

  # networking.wg-quick.interfaces = {
  #   wg0 = {
  #     address = [ "10.0.0.2/24" "fdc9:281f:04d7:9ee9::2/64" ];
  #     dns = [ "10.0.0.1" "fdc9:281f:04d7:9ee9::1" ];
  #     privateKeyFile = "/home/robert/wireguard-keys/private";
      
  #     peers = [
  #       {
  #         publicKey = "vul6wXx0RaykQvPDgwGBmykntvCt+kk6TCiY6GWEZig=";
  #         # presharedKeyFile = "/root/wireguard-keys/preshared_from_peer0_key";
  #         allowedIPs = [ "0.0.0.0/0" "::/0" ];
  #         endpoint = "202.61.237.213:51820:51820";
  #         persistentKeepalive = 25;
  #       }
  #     ];
  #   };
  # };



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
  hardware.nvidia.open = true;
  hardware.nvidia-container-toolkit.enable = true;
  # virtualisation.virtualbox.host = {
  #   enable = true;
  #   enableHardening = false;
  #   enableExtensionPack = true;
  # };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  # Enable the X11 windowing system.
  services.autorandr.enable = true;
  services.displayManager.defaultSession = "none+i3";
  services.xserver = {
    enable = true;
    autoRepeatInterval = 15;
    autoRepeatDelay = 300;
    # Use session defined in home.nix
    displayManager = {
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

  # nix.settings = {
  #   substituters = [ "https://cosmic.cachix.org/" ];
  #   trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
  # };

  # services.desktopManager.cosmic.enable = true;
  # services.displayManager.cosmic-greeter.enable = true;

  # Thunderbolt section
  # services.udev.extraRules = ''ACTION=="add", SUBSYSTEM=="thunderbolt", ATTR{authorized}=="0", ATTR{authorized}="1"'';
  # services.hardware.bolt.enable = true;
  # hardware.nvidia.modesetting.enable = true;
  # hardware.nvidia.prime.sync.enable = true;
  # hardware.nvidia.prime.sync.allowExternalGpu = true;
  # hardware.nvidia.prime.offload.enable = true;
  # hardware.nvidia.prime.nvidiaBusId = "PCI:6:0:3";
  # hardware.nvidia.prime.intelBusId = "PCI:0:2:0";
  # services.xserver.videoDrivers = ["nvidia"];
  # services.xserver.videoDrivers = ["intel"];
  # boot.blacklistedKernelModules = [ "nouveau" "nvidiafb"];

  # gtk themes (home-manager more specifically) seem to have problems without it
  services.dbus.packages = [ pkgs.dconf ];
  programs.dconf.enable = true;

  # xdg.portal.enable = true;
  # services.flatpak.enable = true;

  # allow no password for sudo (dangerous...)
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.robert = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "audio"
      "dialout"
      "networkmanager"
      "systemd-journal"
      "video"
      "power"
      "wheel" # Enable ‘sudo’ for the user.
      "docker"
      "python"
    ];
    # openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDG/win3mLJzRYDTiMDBRaTQxOXugxEz9WOoaGlTnUm4eQrwNt+WFMoE9keiGyx0/107XqfQMaAE2PBvUEPL5R5CD9H04AVXTjD1Eo7/3rTi5nZPq9pwXhWNvzoqGYAZWT+NDUOn1aJTCQ4a1xPU7gmOSd6e2GPSy+TbqN+CWVf1vbNVTrGJpMqcu4cIA163mFwC8X+cbtYt3ZL7ZwTx9V9WWDrrOwKKUorRx4Ek6NC0/SC0pcvLNCOArKfsFPdL32/pL+HBW19T9w2nhSalkEgTHRFX+dPliEmwGGEGsJTDwABZCdAyArmLReksputEl14Q/2+I2UAWgzRbkoeVEHcOJ05+vM1lnHa/fnocrExMSbNjW6RhHe4jiTqYCl1i2Kq3v8F//AF+DZlJOVSf9m0/doPA2PdJssAN4IBsRj6tWkjoA94EODGTsSntW36YCDduWu4k8iVtEwTkaEJ/Y71cw2ds2tYhTYqmgaI3JblciWnndrxzklRNi1cxBIyUUn52W1mhv1GIWOIvnOFHrJU+i81+muQXkpuoIkB1hbLkTCpbx6uLuuu18eqWx8In0/L9dkh1LjJ1n5aXMr26F5xeOSewNUQglXYxcbevDL1lBW9sYL0eizNHVsI7xl/q7rxgQb1gKcfqZNpIBZvmHai20TgW1eP9T8H070nI6FJuQ== philm@philipp-m.com"];
  };
  # users.extraGroups.vboxusers.members = [ "robert" ];

  # All system wide packages

  programs.fish.enable = true;

  programs.gnupg.agent = {
    enable = true;
  };

  programs.steam.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; let unstable = nixpkgs-unstable.pkgs; in
  [
    nix
    # DEVELOPMENT
    ## compilers and dev environment
    # clang_10 # conflicts with gcc
    claude-code
    conda
    python3
    python3Packages.pip
    python3Packages.setuptools
    gcc
    gdb
    meson
    cmake
    git
    git-secret
    git-crypt
    php
    pnpm
    # nodejs_latest
    # nodejs-16_x
    nodejs
    rustup
    steam-run
    dbeaver-bin
    jdk
    tcpflow
    remmina
    postgresql

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
    dust
    bandwhich
    unzip
    zip
    unrar
    p7zip
    ranger
    hasura-cli
    aria2
    # hasura-graphql-engine
    # ventoy-bin
    # hdparm
    # woeusb
    # wget
    # lsof
    # git-lfs
    # wireguard-tools

    # AUDIO
    pavucontrol
    ffmpeg-full

    # COMMUNICATION
    signal-desktop
    telegram-desktop
    discord
    slack
    v4l-utils

    # WEB
    chromium
    firefox
    google-chrome
    # tor-browser-bundle-bin

    # XORG/DESKTOP ENVIRONMENT
    dmenu
    wmctrl
    xorg.xev
    xinit
    xmessage
    xkill
    xwininfo
    arandr
    feh
    pcmanfm
    flameshot
    gimp

    # MISC
    exfat
    gsettings-desktop-schemas
    appimage-run
    ntfs3g
    acpi
    appimage-run
    powertop
    usbutils
    libreoffice
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
    gparted
    qbittorrent
  ];

  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono google-fonts ];
}
