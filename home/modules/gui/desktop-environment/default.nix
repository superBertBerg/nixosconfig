{ ... }:
{ pkgs, lib, config, ... }: {
  options.modules.gui.desktop-environment.enable = lib.mkEnableOption ''
    Enable personal desktop-environment config (xmonad, taffybar etc.)
  '';

  config = lib.mkIf config.modules.gui.desktop-environment.enable {
    home.keyboard.layout = "us";

    xsession = {
      enable = true;


      windowManager.i3 = {
        enable = true;


        config =
          let mod = "Mod4";
          in
          {
            modifier = mod;
            gaps = {
              smartGaps = true;
              inner = 10;
            };
            keybindings = lib.mkOptionDefault {
              "${mod}+space" = "exec rofi -show run";
              # "${mod}+c" = "exec env MOZ_USE_XINPUT2=1 firefox";
              "${mod}+c" = "exec chromium";
              "${mod}+Return" = "exec alacritty";
              "${mod}+Shift+x" = "exec sh -c '${pkgs.i3lock}/bin/i3lock -c 000000'";
            };
            
            bars = [
              {
                position = "bottom";
                statusCommand = "i3status-rs ~/.config/i3status-rust/config-bottom.toml";
              }
            ];
          };
      };
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        # "application/pdf" = "org.pwmt.zathura.desktop";
        "image/png" = "feh.desktop";
        "image/jpeg" = "feh.desktop";
        # "video/x-matroska" = "mpv.desktop";
        # "video/mp4" = "mpv.desktop";
        # "video/webm" = "mpv.desktop";
        "text/html" = "chromium-browser.desktop";
        "x-scheme-handler/http" = "chromium-browser.desktop";
        "x-scheme-handler/https" = "chromium-browser.desktop";
        "x-scheme-handler/about" = "chromium-browser.desktop";
        "x-scheme-handler/unknown" = "chromium-browser.desktop";
      };
    };

    # some app overwrites mimeapps all the time...
    xdg.configFile."mimeapps.list".force = true;

    # KDE/GTK specific

    gtk.enable = true;
    gtk.gtk4.theme = null;

    qt = {
      enable = true;
      platformTheme.name = "gtk";
    };

    programs.rofi = {
      enable = true;
    };

    # services.picom = {
    #   enable = true;
    #   # add fancy dual kawase blur to picom
    #   package = pkgs.picom.overrideAttrs (
    #     old: {
    #       src = builtins.fetchGit {
    #         shallow = true;
    #         url = "https://github.com/Philipp-M/picom/";
    #         ref = "customizable-rounded-corners";
    #         rev = "2b1d9faf0bf5dfad04a5acf02b34a432368de805";
    #       };
    #     }
    #   );
    #   experimentalBackends = true;
    #   settings = {
    #     # general
    #     backend = "glx";
    #     vsync = true;
    #     refresh-rate = 0;
    #     unredir-if-possible = false;
    #     # blur
    #     blur-background = true;
    #     blur-background-exclude = [ ];
    #     blur-method = "dual_kawase";
    #     blur-strength = 10;
    #     wintypes = {
    #       desktop = {
    #         opacity = builtins.fromJSON config.theme.extraParams.alpha;
    #         corner-radius = 0;
    #         corner-radius-top-left = 5;
    #         corner-radius-top-right = 5;
    #         round-borders = 1;
    #       };
    #       normal = { round-borders = 1; };
    #     };
    #     # rounded corners and alpha-transparency
    #     detect-rounded-corners = true;
    #     round-borders = 1;
    #     corner-radius = 0;
    #     corner-radius-bottom-left = 5;
    #     corner-radius-bottom-right = 5;
    #     rounded-corners-exclude = [
    #       "window_type = 'menu'"
    #       "window_type = 'dock'"
    #       "window_type = 'dropdown_menu'"
    #       "window_type = 'popup_menu'"
    #       "class_g = 'Polybar'"
    #       "class_g = 'Rofi'"
    #       "class_g = 'Dunst'"
    #     ];
    #     frame-opacity = builtins.fromJSON config.theme.extraParams.alpha;
    #   };
    # };

    # services.random-background = {
    #   enable = true;
    #   imageDirectory = "%h/wallpaper/";
    # };

    services.redshift = {
      enable = true;
      settings = {
        manual = {
          lat = "47.267";
          lon = "11.383";
        };
      };
      temperature.day = 6500;
      temperature.night = 3200;
    };

    services.udiskie.enable = true;

    services.status-notifier-watcher.enable = true;

    services.pasystray.enable = true;

    services.network-manager-applet.enable = true;

    # services.flameshot.enable = true;

    services.dunst.enable = true;

    # services.unclutter.enable = true;

    # services.kdeconnect.enable = true;

    # audio services

    services.easyeffects.enable = true;
  };
}
