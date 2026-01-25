{
  description = "Hyprland on Nixos";

  inputs = {

    nixpkgs.url = "nixpkgs/nixos-unstable";

    swww.url = "github:LGFae/swww";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

     noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.hyprland-btw = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.tommy = {
              imports = [
                ./home.nix
              ];
            };
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}

