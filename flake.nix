{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      homeManagerModules = {
        cli = import ./home/modules/cli { }; # enables all modules in the cli directory + small extra ones
        fish = import ./home/modules/cli/fish.nix { };
        git = import ./home/modules/cli/git.nix { };
        ssh = import ./home/modules/cli/ssh.nix { };
        starship = import ./home/modules/cli/starship.nix { };
        tmux = import ./home/modules/cli/tmux.nix { };
        gui = import ./home/modules/gui { }; # enables all modules in the gui directory + small extra ones
        firefox = import ./home/modules/gui/firefox.nix { };
        alacritty = import ./home/modules/gui/alacritty { };
        desktop-environment = import ./home/modules/gui/desktop-environment { };
      };

      mkHost = { path, extraConfig ? { }}: inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.useGlobalPkgs = true;
            home-manager.users.robert = {
              home.stateVersion = "23.05";
              imports = builtins.attrValues homeManagerModules;
              programs.home-manager.enable = true;
              modules.cli.enable = true;
              modules.gui.enable = true;
            };
          }
          extraConfig
          path
        ];
        specialArgs = { inherit inputs; };
      };
    in
    {
      devShell."${system}" = import ./shell.nix { inherit pkgs; };

      inherit homeManagerModules;
      nixosConfigurations = {
        schwarzeshackertool = mkHost {
          path = ./machines/schwarzeshackertool;
        };
        schwarzerhackerstein = mkHost {
          path = ./machines/schwarzerhackerstein;
        };
      };
    };
}
