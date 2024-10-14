# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

let
  homeDir = builtins.getEnv "HOME";
in
{
  imports = [
    # Include the results of the hardware scan.
    /etc/nixos/hardware-configuration.nix
    # <home-manager/nixos>
  ];

  # # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # hardware.video.hidpi.enable = true;

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Allow unfree
  nixpkgs.config.allowUnfree = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.david.isNormalUser = true;
  # users.users.david.extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  users.users.david = {

    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        settings = {
          # "org/gnome/desktop/background" = {
          #   picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
          # };
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };
      }
    ];
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  # programs.dconf.enable = true;

  #  home-manager.users.david = {
  #    home.packages = [ pkgs.home-manager ];
  #    # isNormalUser = true;
  #    # extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #    # dconf.settings = {
  #    # 	"org/gnome/desktop/interface" = {
  #    #     color-scheme = "prefer-dark";
  #    #   };
  #    # };
  #    # The state version is required and should stay at the version you
  #    # originally installed.
  #    home.stateVersion = "24.05";
  # #    packages = with pkgs; [
  # # discord
  # # dmenu
  # # google-chrome
  # # wezterm
  # # obsidian
  # #      # firefox
  # #      # tree
  # #    ];
  #  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # This is where the programs live
  environment.systemPackages = with pkgs; [
    discord
    dmenu
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    xclip
    git
    xautolock
    slstatus
    xsel
    pasystray
    protontricks
    wowup-cf
    xbindkeys
    tk
    xbindkeys-config
    maim
    peek
    xclip
    gparted
    killall
    element-desktop
  ];

  programs.slock.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
  system.stateVersion = "24.11"; # Did you read the comment?

  # programs.sway.enable = true;
  # services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.slick.enable = true;
  };
  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr --output DP-0 --mode 5120x1440
  '';

  services.xserver.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  services.xserver.windowManager.dwm.enable = true;
  services.xserver.windowManager.dwm.package = pkgs.dwm.overrideAttrs {
    src = /. + "${homeDir}/system/dotfiles-nix/suckless/dwm";
  };
  services.libinput.mouse = {
    middleEmulation = false;
    accelProfile = "flat";
    accelSpeed = "-0.50";
  };
  services.libinput.touchpad.middleEmulation = false;

  hardware.graphics.enable32Bit = true;

  #    fonts.packages = with pkgs; [
  #   (nerdfonts.override { fonts = [ "Meslo" ]; })
  # ];

  # fonts.enableDefaultPackages = true;
  fonts.enableGhostscriptFonts = true;

  # fonts = {
  #   fontconfig = {
  #     antialias = true;
  #   };
  # };
  # fonts.fontconfig.hinting.enable = true;
  # fonts.fontconfig.subpixel.rgba = "rgb";

  boot.supportedFilesystems = [ "ntfs" ];

  # Styling
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Meslo" ]; })
      noto-fonts
      # roboto
      # corefonts
      # vistafonts
      noto-fonts-cjk
      noto-fonts-emoji
      # liberation_ttf
      # fira-code
      # fira-code-symbols
      # mplus-outline-fonts.githubRelease
      # dina-font
      # proggyfonts
      # lato
      inter
      # overpass
      # liberation_ttf
      # open-sans
      # ubuntu_font_family
    ];

    fontconfig = {
      # Fixes pixelation
      antialias = true;

      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Inter" ];
      };

      # Fixes antialiasing blur
      # hinting = {
      #   enable = true;
      #   style = "full"; # no difference
      #   autohint = true; # no difference
      # };

      # subpixel = {
      #   # Makes it bolder
      #   rgba = "rgb";
      #   lcdfilter = "default"; # no difference
      # };
    };
  };

  nixpkgs.overlays = [
    (final: prev: {
      slstatus = prev.slstatus.overrideAttrs (old: {
        src = /. + "${homeDir}/system/dotfiles-nix/suckless/slstatus";
      });
    })
    (final: prev: {
      slock = prev.slock.overrideAttrs (old: {
        src = /. + "${homeDir}/system/dotfiles-nix/suckless/slock";
        buildInputs = old.buildInputs ++ [
          pkgs.xorg.libXinerama
          pkgs.imlib2
        ];
      });
    })
  ];
}
