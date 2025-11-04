# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

 # services.getty.autologinUser = "tommy";
  services.displayManager.sddm = {
    enable = true;
    wayland = {
      enable = true;
    };
  };

  networking.hostName = "hyprland-btw"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  environment.variables.EDITOR = "nvim";

  # Set your time zone.
  time.timeZone = "Europe/Budapest";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.fstrim.enable = true; # SSD Optimizer
  services.gvfs.enable = true; # For Mounting USB & More

  nixpkgs.config.allowUnfree = true;

  hardware = {
    xone.enable = true;
    graphics = {
     enable = true;
     enable32Bit = true;
    };
  };

hardware.steam-hardware.enable = true;

programs.steam = {
  enable = true;
  remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
  localNetworkGameTransfers.openFirewall = false; # Open ports in the firewall for Steam Local Network Game Transfers
};

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
   services.pipewire = {
     enable = true;
     pulse.enable = true;
     alsa.enable = true;
     alsa.support32Bit = true;
     jack.enable = true;
     extraConfig.pipewire."92-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 256;
          "default.clock.min-quantum" = 256;
          "default.clock.max-quantum" = 256;
        };
      };
     extraConfig.pipewire-pulse."92-low-latency" = {
       context.modules = [
          {
            name = "libpipewire-module-protocol-pulse";
            args = {
              pulse.min.req = "256/48000";
              pulse.default.req = "256/48000";
              pulse.max.req = "256/48000";
              pulse.min.quantum = "256/48000";
              pulse.max.quantum = "256/48000";
            };
          }
        ];
      };
   };

  # Enable touchpad support (enabled default in most desktopManager).
   services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tommy = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    librewolf
    foot
    brightnessctl
    btop
    mpv #terminal video player
    imv #terminal image viwer
    usbutils
    playerctl
    pavucontrol
    yazi
    kitty
    waybar
    wofi
    hyprpaper
    keepassxc
    udiskie
    geany
    thunderbird
    hyprlock
    swww
    mpvpaper
    waypaper
    grim #for screenshoots
    slurp #for screenshoots
    swappy #for screenshoots
    fastfetch
    swaynotificationcenter
    signal-desktop
    nix-output-monitor
    dolphin-emu
    unzip
    heroic
    ];
 
 hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Privacy = "device";
        JustWorksRepairing = "always";
        Class = "0x000100";
        FastConnectable = true;
      };
  };
  };

 services.blueman.enable = true; # Bluetooth Support
 qt.enable =true; #Needed for Catppuccin themes

 fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
 ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

