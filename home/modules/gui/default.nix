# This module enables all personal X.org desktop environment related stuff for home-manager
{ }:
{ pkgs, lib, config, ... }:
{
  options.modules.gui.enable = lib.mkEnableOption "Enable all personal gui configurations";

  config = lib.mkIf config.modules.gui.enable {
    modules.gui = {
      alacritty.enable = true;
      cosmic.enable = true;
      desktop-environment.enable = true;
      firefox.enable = true;
    };
    programs.vscode.enable = true;
    home.packages = [ pkgs.zed-editor pkgs.nixd pkgs.bun pkgs.typescript-language-server pkgs.rust-analyzer pkgs.gopls pkgs.sqls ];

    # Keep Handy running so the dictation shortcut can toggle recording immediately.
    xdg.configFile."autostart/handy.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Handy
      Exec=${pkgs.handy}/bin/handy --start-hidden
      Icon=handy
      Terminal=false
    '';
  };

}
