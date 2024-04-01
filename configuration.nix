# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

  # Home-Manager
  let
    home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
  in



{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

       (import "${home-manager}/nixos")

       
    ];



  home-manager.users.ldvg = {
      home.stateVersion = "23.11";

      dconf.settings = {
        "org/gnome/shell" = {
        "favorite-apps" = [
          "org.gnome.Nautilus.desktop"
          "code.desktop"
          "org.gnome.Console.desktop"
          "google-chrome.desktop"
        ];

        };
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
        "org/gnome/desktop/wm/preferences" = {
          num-workspaces = 1;
        };
      };

    };

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
#  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ]; 

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
   
  # Disable printing
 # services.printing.enable = false;
  
  # Configure keymap in X11
  services.xserver = {
    layout = "se";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "sv-latin1";

  # Enable CUPS to print documents.
  #services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;


  programs.dconf.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ldvg = {
    isNormalUser = true;
    description = "ldvg";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  firefox
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    jdk17
    minecraft
    steam
    google-chrome
    vscode
    git
    neofetch
    btop
    citrix_workspace
  ];

nixpkgs.overlays = [
  ( self: super:
  let
  extraCerts = [ /etc/ssl/certs ];
  in {
    citrix_workspace = super.citrix_workspace.override {
      inherit extraCerts;
    };

  }
  )

];


environment.gnome.excludePackages = (with pkgs; [
  gnome-photos
  gnome-tour
  gnome-connections
  gnome-text-editor
  snapshot
  loupe  
]) ++ (with pkgs.gnome; [
  baobab
  eog
  simple-scan
  yelp
  file-roller
  seahorse
  cheese # webcam tool
  gnome-music
  gnome-terminal
  gedit # text editor
  epiphany # web browser
  geary # email reader
  evince # document viewer
  gnome-characters
  totem # video player
  tali # poker game
  iagno # go game
  hitori # sudoku game
  atomix # puzzle game
  gnome-calculator
  gnome-calendar
  gnome-clocks
  gnome-contacts
  gnome-font-viewer
  gnome-logs
  gnome-maps
  gnome-system-monitor
  gnome-weather
  gnome-disk-utility
]);

 
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
