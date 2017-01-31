# a-desktop hardware.nix
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    kernelModules = [ "kvm-intel" "nct6775" "coretemp" ];
    kernelParams = [ "quiet" "loglevel=3" "vga=current" ];
    extraModulePackages = [ ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/68e4c3b7-5fa8-451e-953a-ca366d535685";
      fsType = "btrfs";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/436a1cff-f511-42b6-8ec7-265674c4b091";
      fsType = "btrfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/F68C-50C5";
      fsType = "vfat";
    };

  fileSystems."/mnt/hdd" =
    { device = "/dev/mapper/hdd";
      fsType = "ext4";
    };

  systemd.generator-packages = [
    pkgs.systemd-cryptsetup-generator
  ];

  environment.etc."crypttab".text =
    ''
    # crypttab: mappings for encrypted partitions
    #
    # Each mapped device will be created in /dev/mapper, so your /etc/fstab
    # should use the /dev/mapper/<name> paths for encrypted devices.
    #
    # The Arch specific syntax has been deprecated, see crypttab(5) for the
    # new supported syntax.
    #
    # NOTE: Do not list your root (/) partition here, it must be set up
    #       beforehand by the initramfs (/etc/mkinitcpio.conf).
    # <name>	<device>					<password>	<options>
    hdd	/dev/disk/by-uuid/967c757e-3a77-4391-8203-4794a904a205	/root/keyfile	luks
    '';


  swapDevices = [ { device = "/dev/disk/by-uuid/be8bb4b2-de0a-49ab-9801-63503181fb8a"; } 
  ];

  nix.maxJobs = lib.mkDefault 4;

  networking.hostName = "a-desktop";

  # fancontrol stuff
  environment.systemPackages = with pkgs; [
    lm_sensors
  ];

  systemd.services.fancontrol = {
    description = "Start fancontrol, if configured";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.lm_sensors}/sbin/fancontrol";
    };
  };

  environment.etc."fancontrol".text =
    ''
    INTERVAL=10
    FCTEMPS=/sys/devices/platform/nct6775.2560/hwmon/hwmon[[:print:]]*/pwm2=/sys/devices/platform/nct6775.2560/hwmon/hwmon[[:print:]]*/temp1_input /sys/devices/platform/nct6775.2560/hwmon/hwmon[[:print:]]*/pwm1=/sys/devices/platform/nct6775.2560/hwmon/hwmon[[:print:]]*/temp7_input
    FCFANS=/sys/devices/platform/nct6775.2560/hwmon/hwmon[[:print:]]*/pwm2=/sys/devices/platform/nct6775.2560/hwmon/hwmon[[:print:]]*/fan2_input /sys/devices/platform/nct6775.2560/hwmon/hwmon[[:print:]]*/pwm1=/sys/devices/platform/nct6775.2560/hwmon/hwmon[[:print:]]*/fan1_input
    MINTEMP=/sys/devices/platform/nct6775.2560/hwmon/hwmon[[:print:]]*/pwm2=35 /sys/devices/platform/nct6775.2560/hwmon/hwmon[[:print:]]*/pwm1=30
    MAXTEMP=/sys/devices/platform/nct6775.2560/hwmon/hwmon[[:print:]]*/pwm2=70 /sys/devices/platform/nct6775.2560/hwmon/hwmon[[:print:]]*/pwm1=60
    MINSTART=/sys/devices/platform/nct6775.2560/hwmon/hwmon[[:print:]]*/pwm2=4 /sys/devices/platform/nct6775.2560/hwmon/hwmon[[:print:]]*/pwm1=75
    MINSTOP=/sys/devices/platform/nct6775.2560/hwmon/hwmon[[:print:]]*/pwm2=0 /sys/devices/platform/nct6775.2560/hwmon/hwmon[[:print:]]*/pwm1=60
    '';
}
