{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    hypr = "hypr";
    nvim = "nvim";
    rofi = "rofi";
    kitty = "kitty";
    waybar = "waybar";
    yazi = "yazi";
    swaync = "swaync";
  };
in

{

imports =[
  ./modules/theme.nix
  ./modules/bash.nix
];

  home.username = "tommy";
  home.homeDirectory = "/home/tommy";
  home.stateVersion = "25.05";
  programs.git = {
    enable = true;
    settings = { 
      user.name = "tamasbekesi99";
      user.email = "bekesitommy@gmail.com";
      init.defaultBranch = "main";       
    };
  };

 home.packages = with pkgs; [
    neovim
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    gcc
    nitch
    rofi
    pcmanfm
    (pkgs.writeShellApplication {
      name = "ns";
      runtimeInputs = with pkgs; [
        fzf
        (nix-search-tv.overrideAttrs {
          env.GOEXPERIMENT = "jsonv2";
        })
      ];
      text = ''exec "${pkgs.nix-search-tv.src}/nixpkgs.sh" "$@"'';
    })
  ];

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = ["librewolf.desktop"];
        "x-scheme-handler/https" = ["librewolf.desktop"];
        "x-scheme-handler/about" = ["librewolf.desktop"];
        "x-scheme-handler/unknown" = ["librewolf.desktop"];
        "images/png" = ["imv.desktop"];
        "images/jpg" = ["imv.desktop"];
        "images/webp" = ["imv.desktop"];
        "images/svg+xml" = ["imv.desktop"];
        "images/jpeg" = ["imv.desktop"];
       };
     };
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
      configPackages = [ pkgs.hyprland ];
    };

    #create symlink to dot config files for portability
    configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;
  };

}
