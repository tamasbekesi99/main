{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    gnome-themes-extra
  ];

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  gtk.gtk4.theme = null;

  gtk = {
    enable = true;

    theme = {
      package = pkgs.kdePackages.breeze-gtk;
      name = "Breeze-Dark";
    };

    iconTheme = {
      package = pkgs.kora-icon-theme;
      name = "kora"; #icon theme names are case sensitive
    };

    font = {
      name = "DejaVu Sans";
      size = 14;
    };
  };

  xdg.configFile."mimeapps.list".force = true;

  #Env var managed by UWSM
  xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

  home.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "36";
    WLR_NO_HARDWARE_CURSORS = 1; #for gaming
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    QT_QPA_PLATFORMTHEME = "gtk3";
    QT_QPA_PLATFORMTHEME_QT6 = "gtk3";
    QT_QPA_PLATFORM = "wayland";
  };
}
