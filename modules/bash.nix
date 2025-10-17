{config, pkgs, ...}:

{
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
}
