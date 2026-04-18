{ ... }:
{ lib, config, ... }: {
  options.modules.cli.git.enable = lib.mkEnableOption "Enable personal git config";

  config = lib.mkIf config.modules.cli.git.enable {
    programs.git = {
      enable = true;
      lfs.enable = true;
      signing.format = null;
      settings = {
        user.name = "Robert Mildenberger";
        user.email = "superbertberg@gmail.com";
        pull.rebase = false;
        core.editor = "code";
        url."git@github.com:".insteadOf = "https://github.com/";
        # rebase.autostash = true;
        # rerere.enabled = true;
      };
      # settings.init.defaultBranch = "main";
      # aliases = {
      #   pushall = "!git remote | xargs -L1 git push --all";
      # };
    };

    programs.delta = {
      enable = true;
      enableGitIntegration = true;
    };
  };
}
