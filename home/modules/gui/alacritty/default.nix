{ ... }:
{ pkgs, lib, config, ... }: {
  options.modules.gui.alacritty.enable = lib.mkEnableOption "Enable personal alacritty config";

  config = lib.mkIf config.modules.gui.alacritty.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        live_config_reload = true;
        scrolling = {
          history = 100000; # max amount
          multiplier = 5;
        };
        # custom_cursor_colors = false;
        font.size = 14;
        # font.normal.family = fontname;
        # font.ligatures = true;
      };
    };
  };
}
