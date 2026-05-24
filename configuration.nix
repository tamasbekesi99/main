{
  config,
  lib,
  pkgs,
  ...
}:
/*
  let
  sddm-astronaut = pkgs.sddm-astronaut.override {
  embeddedTheme = "japanese_aesthetic"; #for overriding astronaut theme
    #themeConfig = pathtoconfig;
  };
in
*/
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/nvf.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.displayManager.sddm = {
    enable = true;
    #theme = "sddm-astronaut-theme";
    #extraPackages = [ pkgs.sddm-astronaut ];
    wayland = {
      enable = true;
    };
  };
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # 16 GiB
    }
  ];
  # Enable Flatpak support
  # services.flatpak.enable = true;

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
  #BTRFS options

  fileSystems = {
    "/".options = ["compress=zstd"];
    "/home".options = ["compress=zstd"];
    "/nix".options = ["compress=zstd" "noatime"];
  };

  networking.hostName = "hyprland-btw"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Enable the service and the firewall
  services.tailscale = {
    enable = true;
    extraSetFlags = ["--netfilter-mode=nodivert"]; # #For not to bypass firewall rules
    extraDaemonFlags = ["--no-logs-no-support"]; # Disable logging and telemetry
  };
  networking.nftables.enable = true;
  networking = {
    firewall = {
      enable = true;
      # Always allow traffic from your Tailscale network
      trustedInterfaces = ["tailscale0"];
      # Allow DHCP for libvirtd
      interfaces.virbr0.allowedUDPPorts = [53 67];
      # Allow the Tailscale UDP port through the firewall
      allowedUDPPorts = [config.services.tailscale.port];
    };
    # Enable NAT for traffic from the virbr0 interface
    nat.enable = true;
    nat.internalInterfaces = ["virbr0"];
  };

  # Force tailscaled to use nftables (Critical for clean nftables-only systems)
  # This avoids the "iptables-compat" translation layer issues.
  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];

  # Optimization: Prevent systemd from waiting for network online
  # (Optional but recommended for faster boot with VPNs)
  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;

  environment.variables.EDITOR = "nvim";

  time.timeZone = "Europe/Budapest";

  #Hyprland with USWM
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  #Enable dank material shell
  #programs.dms-shell.enable = true;

  #For laptop power managment
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  services.fstrim.enable = true; # SSD Optimizer
  services.gvfs.enable = true; # For Mounting USB & More

  nixpkgs.config.allowUnfree = true;

  #Steam
  hardware.steam-hardware.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = false; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession.enable = true;
    #extraCompatPackages = [pkgs.proton-ge-bin];
  };

  #programs.gamemode.enable = true;

  programs.gamescope = {
    enable = true;
    #  capSysNice = true;
    args = [
      "--rt"
      "--expose-wayland"
    ];
  };

  # Better latency for audio
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
  virtualisation.libvirtd.qemu = {
    swtpm.enable = true;
  };
  virtualisation.spiceUSBRedirection.enable = true;

  #user
  users.users.tommy = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "libvirtd"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  environment.systemPackages = with pkgs; [
    wget
    librewolf #web browser
    lynx #TUI web browser
    brightnessctl #for laptop  brightness
    btop
    mpv #terminal video player
    imv #terminal image viwer
    usbutils
    playerctl
    pavucontrol #GUI for the audio
    yazi #teminal file manager
    kitty #terminal
    keepassxc
    udiskie #for mounting USB
    geany #text editor
    thunderbird
    hyprlock # lockscreen
    hyprpolkitagent #polkit agent
    hyprpicker #color picker
    awww #wallpaper
    #swaynotificationcenter
    dunst #for notification
    fastfetch
    #ashell
    waybar
    grim #for screenshoots
    slurp #for screenshoots
    swappy #for screenshoots
    #nix-output-monitor # for better update visuals
    unzip
    #sddm-astronaut #SDDM theme
    kdePackages.qtmultimedia #SDDM theme
    ffmpeg #codecs
    yt-dlp #ani-cli optional
    neomutt #terminal email program
    newsboat #terminal RSS feed reader
    seahorse #gnupg GUI
    #noctalia-shell
    #android-tools
  ];

  services.dunst.enable = true;
  services.dunst.enableWayland = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/tommy/nixos-dotfiles"; # sets NH_OS_FLAKE variable for you
  };

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
  qt.enable = true; #Needed for theming

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  #services.gnome.gnome-keyring.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };

  programs.ssh.startAgent = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  system.stateVersion = "25.05"; # Do NOT change
}
