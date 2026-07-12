{ ... }:
{ lib, config, ... }: {
  options.modules.cli.ssh.enable = lib.mkEnableOption "Enable personal ssh config";

  config = lib.mkIf config.modules.cli.ssh.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings."*" = {
        ServerAliveInterval = 240;
      };
      # TODO whitelist this for only a selected number of hosts
      # extraConfig = ''
      #   ForwardX11 yes
      #   ForwardX11Trusted yes
      # '';
    };
  };
}
