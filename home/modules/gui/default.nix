# This module enables all personal X.org desktop environment related stuff for home-manager
{ nixpkgs-unstable }:
{ pkgs, lib, config, ... }:
{
  options.modules.gui.enable = lib.mkEnableOption "Enable all personal gui configurations";

  config = lib.mkIf config.modules.gui.enable {
    modules.gui = {
      alacritty.enable = true;
      desktop-environment.enable = true;
      firefox.enable = true;
    };
    home.packages = with nixpkgs-unstable.pkgs; [
      rnix-lsp
    ];
    programs.vscode.enable = true;
  };

}
