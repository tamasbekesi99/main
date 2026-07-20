--############################
--## ENVIRONMENT VARIABLES ###
--############################

--uwsm users should avoid placing environment variables in the hyprland.conf file. Instead, use ~/.config/uwsm/env for theming, xcursor!
-- See https://wiki.hyprland.org/Configuring/Environment-variables/
--env = GTK_THEME,Tokyo-Night-Dark
--env = GTK_ICON_THEME,Adwaita
--env = XCURSOR_SIZE,36
--env = HYPRCURSOR_SIZE,36
--env = XDG_CURRENT_DESKTOP,Hyprland
--env = XDG_SESSION_TYPE,wayland

--################
--## AUTOSTART ###
--################

hl.on("hyprland.start", function()
	hl.exec_cmd("udiskie &")
	--hl.exec_cmd("swaync &")
	hl.exec_cmd("waybar &")
	hl.exec_cmd("awww-daemon &")
	hl.exec_cmd("mako &")
	--hl.exec_cmd("~/nixos-dotfiles/modules/scripts/change_wp_random.sh &")
	hl.exec_cmd("~/nixos-dotfiles/modules/scripts/change_wp_order.sh &")
	--hl.exec_cmd("ashell &")
	hl.exec_cmd("tailscale systray")
	hl.exec_cmd("app2unit keepassxc", { workspace = "special:secrets" })
end)
