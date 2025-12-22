{config, pkgs, ...}:

{
programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
      #nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#hyprland-btw";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#hyprland-btw |& sudo nom";
      ncg = "sudo nix-collect-garbage -d";
      vim = "nvim";
      cat = "bat";
    };
    initExtra = ''
      export PS1='\[\e[38;5;76m\]\u\[\e[0m\] in \[\e[38;5;32m\]\w\[\e[0m\] \\$ '
      nitch
    '';
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec uwsm start -S hyprland-uwsm.desktop
      fi
    '';
  };
}
