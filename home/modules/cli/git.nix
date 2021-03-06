{ ... }:
{ lib, config, ... }: {
  options.modules.cli.git.enable = lib.mkEnableOption "Enable personal git config";

  config = lib.mkIf config.modules.cli.git.enable {
    programs.git = {
      enable = true;
      userName = "Robert Mildenberger";
      userEmail = "superbertberg@gmail.com";
      lfs.enable = true;
      delta.enable = true;
      extraConfig = {
        pull.rebase = false;
        core.editor = "code";
        # rebase.autostash = true;
        # rerere.enabled = true;
      };
      # extraConfig.init.defaultBranch = "main";
      # aliases = {
      #   pushall = "!git remote | xargs -L1 git push --all";
      # };
    };
  };
}
