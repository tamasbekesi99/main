This is just a test readme

make config changes in nixos-dotfiles/config also home.nix
When Downloaded, hardware.nix file should be replaced with the system one.

TODO
- make quickshell more functional
- and/or implement rofi functions for the following items
    - audio control
    - brightnessctl
    - wifi and bluetooth
    - power menu
    - system tray
- add abook isync msmtp notmuch urlscan support for neomutt

NOTE

Neomutt sourced passwords.ggp contains similiar scheme

# User
set from = "<youremailname>@gmail.com"
set realname = "Your Name"

# Gmail
set imap_user = "your_email_name@gmail.com"
set smtp_url = "smtps://<your_email_name>@gmail.com:<your_app_password>@smtp.gmail.com:465/"
set smtp_authenticators = 'gssapi:login'
set imap_pass = "your_app_password"
set smtp_pass = "your_app_password"
