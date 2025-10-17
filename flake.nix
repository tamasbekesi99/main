{
  description = "Hyprland on Nixos";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    swww.url = "github:LGFae/swww";
    #catppuccin.url = "github:catppuccin/nix";
    #stylix.url = "github:nix-community/stylix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, /*stylix, catppuccin, */home-manager, ... }: {
    nixosConfigurations.hyprland-btw = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        #catppuccin.nixosModules.catppuccin
        #stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.tommy = {
              imports = [
                ./home.nix
                #catppuccin.homeModules.catppuccin
                #stylix.homeModules.stylix
              ];
            };
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
