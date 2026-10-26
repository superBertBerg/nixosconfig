# COSMIC (Wayland) session config. COSMIC keeps its own shortcut/keyboard state
# under ~/.config/cosmic and ignores services.xserver.*, so anything that should
# work in both the i3 and the COSMIC session has to be declared twice.
{ ... }:
{ pkgs, lib, config, ... }: {
  options.modules.gui.cosmic.enable = lib.mkEnableOption "Enable personal COSMIC desktop config";

  config = lib.mkIf config.modules.gui.cosmic.enable {
    # Custom shortcuts, in COSMIC's RON format. These merge on top of the defaults
    # shipped by cosmic-comp, so only the extra bindings belong here.
    #
    # COSMIC's shortcut modifiers are limited to Super/Ctrl/Alt/Shift — Caps Lock
    # cannot be used as a modifier here. keyd solves that a layer below: it rewrites
    # CapsLock+s into Ctrl+Alt+Super+s, which is what this binds. That triple is
    # unused by cosmic-comp's shipped defaults.
    xdg.configFile."cosmic/com.system76.CosmicSettings.Shortcuts/v1/custom".text = ''
      {
          (modifiers: [Super, Ctrl, Alt], key: "s"): Spawn("${pkgs.dictate}/bin/dictate"),
      }
    '';
  };
}
