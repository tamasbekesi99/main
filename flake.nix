{
  description = "Hyprland on Nixos";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf.url = "github:notashelf/nvf";

    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    /*
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    */
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    silentSDDM,
    nvf,
    ...
  }: {
    nixosConfigurations.hyprland-btw = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        silentSDDM.nixosModules.default
        nvf.nixosModules.default
        {
          programs.silentSDDM = {
            enable = true;
            theme = "rei";
            # settings = { ... }; see example in module
          };
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
