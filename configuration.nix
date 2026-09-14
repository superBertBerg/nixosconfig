# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, options, lib, ... }:
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

  # KVM/QEMU with libvirt (virsh)
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";       # never auto-resume guests on host boot — always start them manually
    onShutdown = "shutdown"; # cleanly power guests down together with the host
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;   # TPM emulation if needed
      # OVMF/UEFI firmware for guests is available by default on NixOS 26.05
      vhostUserPackages = [ pkgs.virtiofsd ];  # lets libvirt launch virtiofsd for shared folders (virtiofs)
    };
  };
  programs.virt-manager.enable = true;
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

  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

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
      "libvirtd"
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
  environment.systemPackages = with pkgs; [
    nix

    # VIRTUALISATION (libvirt/QEMU clients + helper to spin up an Ubuntu VM)
    virt-viewer                        # graphical console for guests (`virt-viewer <name>`)
    (let
      virsh = "${pkgs.libvirt}/bin/virsh";
      virtInstall = "${pkgs.virt-manager}/bin/virt-install";
    in pkgs.writeShellScriptBin "ubuntu-vm-create" ''
      set -euo pipefail

      # Usage: ubuntu-vm-create [name]     (default name: ubuntu)
      #   Override the ISO with:  ISO_URL=<url> ubuntu-vm-create
      NAME="''${1:-ubuntu}"
      ISO_URL="''${ISO_URL:-https://releases.ubuntu.com/24.04/ubuntu-24.04.3-live-server-amd64.iso}"
      VM_DIR="$HOME/vms"
      ISO="$VM_DIR/$(basename "$ISO_URL")"
      DISK="$VM_DIR/$NAME.qcow2"
      DISK_SIZE="''${DISK_SIZE:-40}"   # GiB (override: DISK_SIZE=100 ubuntu-vm-create)
      CONNECT="qemu:///system"

      # Give the guest half the host's cores and half its RAM.
      VCPUS=$(( $(nproc) / 2 ))
      MEM_MB=$(${pkgs.gawk}/bin/awk '/MemTotal/ {print int($2 / 1024 / 2)}' /proc/meminfo)

      echo ">> VM '$NAME': $VCPUS vCPUs, $MEM_MB MiB RAM, $DISK_SIZE GiB disk"

      if ${virsh} --connect "$CONNECT" dominfo "$NAME" >/dev/null 2>&1; then
        echo "!! A domain named '$NAME' already exists."
        echo "   Start it with:  virsh --connect $CONNECT start $NAME"
        exit 1
      fi

      mkdir -p "$VM_DIR"

      # Ensure the default NAT network exists, is running and autostarts.
      if ! ${virsh} --connect "$CONNECT" net-info default >/dev/null 2>&1; then
        echo ">> Defining libvirt 'default' NAT network"
        TMPXML="$(mktemp)"
        cat > "$TMPXML" <<'EOF'
      <network>
        <name>default</name>
        <forward mode='nat'/>
        <bridge name='virbr0' stp='on' delay='0'/>
        <ip address='192.168.122.1' netmask='255.255.255.0'>
          <dhcp>
            <range start='192.168.122.2' end='192.168.122.254'/>
          </dhcp>
        </ip>
      </network>
      EOF
        ${virsh} --connect "$CONNECT" net-define "$TMPXML"
        rm -f "$TMPXML"
      fi
      ${virsh} --connect "$CONNECT" net-start default 2>/dev/null || true
      ${virsh} --connect "$CONNECT" net-autostart default 2>/dev/null || true

      # Download the ISO once.
      if [ ! -f "$ISO" ]; then
        echo ">> Downloading $ISO_URL"
        ${pkgs.aria2}/bin/aria2c -x 8 -s 8 -d "$VM_DIR" -o "$(basename "$ISO_URL")" "$ISO_URL"
      fi

      echo ">> Creating the VM and booting the installer"
      ${virtInstall} \
        --connect "$CONNECT" \
        --name "$NAME" \
        --vcpus "$VCPUS" \
        --memory "$MEM_MB" \
        --cpu host-passthrough \
        --cdrom "$ISO" \
        --disk path="$DISK",size="$DISK_SIZE",format=qcow2,bus=virtio \
        --osinfo detect=on,name=ubuntu24.04 \
        --graphics spice \
        --video virtio \
        --network network=default,model=virtio \
        --boot uefi \
        --noautoconsole

      cat <<EOF

      VM '$NAME' created (persistent; it will NOT autostart with the host).

      Open the console and run the Ubuntu installer:
        virt-viewer --connect $CONNECT $NAME      # or just use virt-manager

      Everyday control:
        virsh --connect $CONNECT start    $NAME    # start it manually
        virsh --connect $CONNECT shutdown $NAME    # graceful power off
        virsh --connect $CONNECT destroy  $NAME    # force power off
        virsh --connect $CONNECT list --all        # list all VMs

      Delete it completely:
        virsh --connect $CONNECT undefine --nvram $NAME
        rm -f "$DISK"
      EOF
    '')

    # DEVELOPMENT
    ## compilers and dev environment
    claude-code
    conda
    python3
    python3Packages.pip
    python3Packages.setuptools
    gcc
    gdb
    meson
    cmake
    gh
    git
    git-secret
    git-crypt
    php
    pnpm
    # nodejs_latest
    # nodejs-16_x
    nodejs
    go
    rustup
    steam-run
    dbeaver-bin
    jdk
    tcpflow
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
    xev
    xinit
    xmessage
    xkill
    xwininfo
    pcmanfm
    gimp

    # MISC
    exfat
    gsettings-desktop-schemas
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
    smartmontools
    rdfind
    rage
    imagemagick
    gparted
    qbittorrent
  ];

  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono google-fonts ];
}
