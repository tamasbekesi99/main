{config, pkgs, ...}:

{
programs = {
  bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
      #nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#hyprland-btw";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#hyprland-btw |& sudo nom";
      ncg = "sudo nix-collect-garbage -d";
      vim = "nvim";
      cat = "bat";
      ls =  "eza";
      ns = "~/nixos-dotfiles/modules/scripts/nixpkgs.sh";
        #ns = "nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history";
    };
    initExtra = ''
      export PS1='\[\e[35m\]\[\e[0m\] in \[\e[36m\]\[\e[0m\] \w \$ '
      nitch
    '';
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec uwsm start -S hyprland-uwsm.desktop
      fi
    '';
  };

  zoxide = {
    enable = true;
    enableBashIntegration = true;
  };
};
}
