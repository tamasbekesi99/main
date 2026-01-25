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
    quickshell = "quickshell";
    yazi = "yazi";
    swaync = "swaync";
    neomutt = "neomutt";
    noctalia = "noctalia";
  };
in

{

imports =[
  ./modules/theme.nix
  ./modules/bash.nix
];

  home.username = "tommy";
  home.homeDirectory = "/home/tommy";
  home.stateVersion = "25.11";
  
  programs.git = {
    enable = true;
    settings = { 
      user.name = "tamasbekesi99";
      user.email = "bekesitommy@gmail.com";
      init.defaultBranch = "main";       
    };
  };

  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
    ];
    commandLineArgs = [
      "--disable-features=WebRtcAllowInputVolumeAdjustment"
    ];
  };

 home.packages = with pkgs; [
    neovim
    fd
    ripgrep
    fzf
    tealdeer
    eza
    zoxide
    bat
    nil
    nixpkgs-fmt
    nodejs
    jq #for the quickshell json script in shell.qml
    gcc
    nitch
    rofi
    pcmanfm
    nix-search-tv
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

