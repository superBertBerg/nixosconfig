{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rycee-nur-expressions = { url = "gitlab:rycee/nur-expressions"; flake = false; };
    home-manager = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, rycee-nur-expressions, home-manager, agenix, ... }:
    let
      system = "x86_64-linux";
      pkgImport = pkgs: overlays:
        import pkgs {
          inherit system;
          inherit overlays;
          config.allowUnfree = true;
        };
      nixpkgs-stable = pkgImport inputs.nixpkgs [ ];
      nixpkgs-unstable = pkgImport inputs.nixpkgs-unstable [ ];

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
        theme = import ./home/modules/theme.nix { inherit rycee-nur-expressions; };
      };

      mkHost = { path, extraConfig ? { }, overlays ? [ ] }: inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        pkgs = pkgImport inputs.nixpkgs overlays;
        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.useGlobalPkgs = true;
            home-manager.users.philm = {
              imports = builtins.attrValues homeManagerModules;
              programs.home-manager.enable = true;
              modules.cli.enable = true;
              modules.gui.enable = true;
            };
          }
          extraConfig
          path
        ];
        specialArgs = { inherit inputs nixpkgs-unstable; };
      };
    in
    {
      devShell."${system}" =
        import ./shell.nix { pkgs = nixpkgs-stable; agenix = inputs.agenix.defaultPackage.x86_64-linux; };

      inherit homeManagerModules;
      nixosConfigurations = {
        schwarzeshackertool = mkHost {
          path = ./machines/schwarzeshackertool;
          overlays = [ ] ++ (import ./machines/schwarzeshackertool/overlays.nix { inherit nixpkgs-unstable; });
        };
      };
    };
}
