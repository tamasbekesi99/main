{
  config,
  pkgs,
  ...
}: {
  programs = {
    bash = {
      enable = true;
      shellAliases = {
        btw = "echo i use Nixos, btw";
        #nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#hyprland-btw";
        #fu = "cd ~/nixos-dotfiles/ && sudo nix flake update";
        #nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#hyprland-btw |& sudo nom";
        #ncg = "sudo nix-collect-garbage -d";
        nu = "nh os switch --update"; #flake configured in configuration.nix
        ncg = "nh clean all --ask";
        #vim = "nvim";
        cat = "bat";
        ls = "eza --icons";
        ns = "~/nixos-dotfiles/modules/scripts/nixpkgs.sh";
      };
      initExtra = ''
        export PS1='\[\e[35m\]\[\e[0m\] in \[\e[36m\]\[\e[0m\] \[\e[38;5;27m\]\w\[\e[0m\] \$ '
        ~/nixos-dotfiles/config/fastfetch/fastfetch.sh
      '';
      profileExtra = ''
        if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
          exec uwsm start -S hyprland-uwsm.desktop
        fi
      '';
    };
  };
}
