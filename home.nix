{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    hypr = "hypr";
    nvim = "nvim";
    wofi = "wofi";
    rofi = "rofi";
    foot = "foot";
    kitty = "kitty";
    waybar = "waybar";
    yazi = "yazi";
    swaync = "swaync";
  };
in

{

imports =[
  ./modules/theme.nix
];

  home.username = "tommy";
  home.homeDirectory = "/home/tommy";
  home.stateVersion = "25.05";
  programs.git = {
    enable = true;
    userName = "tamasbekesi99";
    userEmail = "bekesitommy@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";       
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#hyprland-btw";
      ncg = "sudo nix-collect-garbage -d";
      vim = "nvim";
    };
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec uwsm start -S hyprland-uwsm.desktop
      fi
    '';
  };

 home.packages = with pkgs; [
    neovim
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    gcc
    wofi
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

  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

}
