This is just a test readme

make config changes in nixos-dotfiles/config also home.nix
When Downloaded, hardware.nix file should be replaced with the system one.

TODO
- `time hyprctl activewindow | grep title: | sed 's/^[^:]*: //'` -->time it with ripgrep VS time `hyprctl activewindow -j | jq -r '.title // empty' in shell.qml`
- make quickshell modular and functional
    - audio control
    - brightnessctl
    - wifi and bluutooth
    - power menu
