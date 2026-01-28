{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    adwaita-icon-theme
    papirus-icon-theme
    gnome-themes-extra
  ];

  gtk = {
    enable = true;
    colorScheme ="dark";
    theme.name = "Adwaita";
    iconTheme.name = "Papirus-Dark";
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };
  };

  xdg.configFile."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name=Adwaita
    gtk-icon-theme-name=Papirus-Dark
    gtk-cursor-theme-name=Adwaita
    gtk-cursor-theme-size=24
  '';

  xdg.configFile."gtk-4.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name=Adwaita
    gtk-icon-theme-name=Papirus-Dark
    gtk-cursor-theme-name=Adwaita
    gtk-cursor-theme-size=24
  '';
  xdg.configFile."mimeapps.list".force = true;

  #Env var managed by UWSM
  xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
  
  home.sessionVariables = {
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "36";
    WLR_NO_HARDWARE_CURSORS = 1; #for gaming
    QT_QPA_PLATFORMTHEME = "gtk3";
    QT_QPA_PLATFORM = "wayland"; 
  };
}
