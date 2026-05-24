{
  config,
  pkgs,
  ...
}: let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config"; #The path to your portable config files
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path; #Create symlink to your .config

  #Make sure to 'mkdir' these folders in your portable config folder!!!
  configs = {
    hypr = "hypr";
    nvim = "nvim";
    fuzzel = "fuzzel";
    fastfetch = "fastfetch";
    kitty = "kitty";
    yazi = "yazi";
    neomutt = "neomutt";
    waybar = "waybar";
    dunst = "dunst";
  };
in {
  imports = [
    ./modules/theme.nix
    ./modules/bash.nix
    ./modules/zoxide.nix
  ];

  home = {
    username = "tommy";
    homeDirectory = "/home/tommy";
    stateVersion = "25.11";
  };

  programs.git = {
    enable = true;
    signing = {
      key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub"; # Path to your public key
      signByDefault = true; # Sign all commits by default
    };
    settings = {
      user.name = "tamasbekesi99";
      user.email = "bekesitommy@gmail.com";
      init.defaultBranch = "main";
      gpg.format = "ssh";
    };
  };

  home.packages = with pkgs; [
    neovim #editor
    fd # find
    ripgrep
    fzf #fuzzy
    tealdeer #tldr
    eza #better ls
    zoxide #better cd
    bat #better cat
    nil
    nixpkgs-fmt
    nodejs
    jq #for the quickshell json script in shell.qml
    gcc
    nitch #neofetch like tool
    #rofi
    fuzzel #app launcher
    app2unit #for faster app launch, compared to uwsm
    pcmanfm #GUI filemanager
    nix-search-tv #with th bash script it is easy to serach for nix packages in the terminal
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
      extraPortals = [pkgs.xdg-desktop-portal-hyprland];
      configPackages = [pkgs.hyprland];
    };

    #create symlink to dot config files for portability
    configFile =
      builtins.mapAttrs
      (name: subpath: {
        source = create_symlink "${dotfiles}/${subpath}";
        recursive = true;
      })
      configs;
  };
}
