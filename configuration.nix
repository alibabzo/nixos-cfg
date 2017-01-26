# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
      ./desktop.nix
      ./fancontrol.nix
    ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };

    kernelModules = [
      "nct6775"
      "coretemp"
    ];
    kernelParams = [
      "quiet"
      "loglevel=3"
      "vga=current"
    ];
  };

  hardware.pulseaudio.enable = true;

  networking.hostName = "a-desktop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "uk";
    defaultLocale = "en_GB.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    git
    i3blocks
    python3
    python35Packages.neovim
    python35Packages.pip
    tree
    neovim
    wget
    zsh
    ((callPackage ./pkgs/nix-home) { })
  ];

  systemd.generator-packages = [
    pkgs.systemd-cryptsetup-generator
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      hplip
    ];
  };

  services.udisks2.enable = true;

  # Enable redshift
  services.redshift = {
    enable = true;
    latitude = "51.5";
    longitude = "-2.6";
    temperature.day = 5700;
    temperature.night = 3500;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.alistair = {
    name = "alistair";
    group = "users";
    extraGroups = [
      "wheel" "audio" "networkmanager"
    ];
    isNormalUser = true;
    uid = 1000;
  };

  security.sudo.wheelNeedsPassword = false;

  system.autoUpgrade.enable = true;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.09";

  programs.zsh.enable = true;
  users.defaultUserShell = "/run/current-system/sw/bin/zsh";
  programs.zsh.promptInit = "";
  nixpkgs.config.allowUnfree = true;
}
