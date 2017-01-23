# Fancontrol service configuration
{ config, pkgs, ... }:

{
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
