{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.displayManager.sddm = {
    enable = true;
    theme = "sddm-astronaut-theme";
    wayland = {
      enable = true;
    };
  };

  networking.hostName = "hyprland-btw"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  environment.variables.EDITOR = "nvim";

  time.timeZone = "Europe/Budapest";

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  services.fstrim.enable = true; # SSD Optimizer
  services.gvfs.enable = true; # For Mounting USB & More

  nixpkgs.config.allowUnfree = true;

#  hardware = {
#    xone.enable = true;
#    graphics = {
#     enable = true;
#     enable32Bit = true;
#    };
#  };

  hardware.steam-hardware.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = false; # Open ports in the firewall for Steam Local Network Game Transfers
  };

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

  services.libinput.enable = true;

  #Virt
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["tommy"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  #user
  users.users.tommy = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "libvirtd" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

/*programs.firefox = {
  enable = true;
  package = pkgs.librewolf;
  policies = {
    DisableTelemetry = true;
    DisableFirefoxStudies = true;
    Preferences = {
      "cookiebanners.service.mode.privateBrowsing" = 2; # Block cookie banners in private browsing
      "cookiebanners.service.mode" = 2; # Block cookie banners
      "privacy.donottrackheader.enabled" = true;
      "privacy.fingerprintingProtection" = true;
      "privacy.resistFingerprinting" = true;
      "privacy.trackingprotection.emailtracking.enabled" = true;
      "privacy.trackingprotection.enabled" = true;
      "privacy.trackingprotection.fingerprinting.enabled" = true;
      "privacy.trackingprotection.socialtracking.enabled" = true;
    };
    ExtensionSettings = {
      "jid1-ZAdIEUB7XOzOJw@jetpack" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/duckduckgo-for-firefox/latest.xpi";
        installation_mode = "force_installed";
      };
      "uBlock0@raymondhill.net" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        installation_mode = "force_installed";
      };
    };
  };
};

environment.etc."firefox/policies/policies.json".target = "librewolf/policies/policies.json";*/


  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    librewolf
    brightnessctl
    btop
    mpv #terminal video player
    imv #terminal image viwer
    usbutils
    playerctl
    pavucontrol
    yazi #teminal file manager
    kitty #terminal
    waybar
    hyprpaper #background image
    keepassxc
    udiskie
    geany #text editor
    thunderbird
    hyprlock
    swww #background image
    mpvpaper
    waypaper #background image
    grim #for screenshoots
    slurp #for screenshoots
    swappy #for screenshoots
    swaynotificationcenter
    signal-desktop
    nix-output-monitor
    dolphin-emu
    unzip
    sddm-astronaut #SDDM theme
    kdePackages.qtmultimedia #SDDM theme
    quickshell
    ani-cli
    ffmpeg
    yt-dlp
    neomutt
    newsboat
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
    nerd-fonts.iosevka
 ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.openssh.enable = true;

  system.stateVersion = "25.05"; # Do NOT change

}

