{ config, pkgs, ... }:
{
  # Install fonts
  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      hack-font
      source-code-pro
    ];
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    libinput.enable = true;

    inputClassSections = [
      ''
        Identifier "Mouse Acceleration"
	Driver "libinput"
        MatchIsPointer "yes"
        Option "AccelProfile" "flat"
      '' ];

    displayManager.lightdm.enable = true;
    displayManager.lightdm.autoLogin = {
      enable = true;
      user = "alistair";
    };

    desktopManager.default = "xfce";
    desktopManager.xfce = {
      enable = true;
      thunarPlugins = with pkgs.xfce;
      [ thunar_volman thunar-archive-plugin tumbler ];
    };

    windowManager.default = "xmonad";
    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;
  };

  environment.variables.BROWSER = "chromium";

  environment.systemPackages = with pkgs; [
    haskellPackages.xmobar
    haskellPackages.xmonad
  ];
}
