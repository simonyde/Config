{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkDefault
    types
    mkOption
    ;
  shell = config.syde.shell;
  user = config.syde.user;
  cfg = config.syde.pc;
in
{
  config = mkIf cfg.enable {
    system.stateVersion = "24.11";
    time.timeZone = "Europe/Copenhagen";

    i18n.defaultLocale = "en_GB.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "da_DK.UTF-8";
      LC_IDENTIFICATION = "da_DK.UTF-8";
      LC_MEASUREMENT = "da_DK.UTF-8";
      LC_MONETARY = "da_DK.UTF-8";
      LC_NAME = "da_DK.UTF-8";
      LC_NUMERIC = "da_DK.UTF-8";
      LC_PAPER = "da_DK.UTF-8";
      LC_TELEPHONE = "da_DK.UTF-8";
      LC_TIME = "da_DK.UTF-8";
    };

    services.xserver = {
      xkb.layout = cfg.keyboard.layout;
      xkb.options = cfg.keyboard.options;
      excludePackages = [ pkgs.xterm ];
    };

    console = {
      useXkbConfig = true;
      font = "Lat2-Terminus16";
    };

    networking = {
      firewall = {
        enable = true;
        allowedTCPPorts = [
          80 # HTTP
          443 # HTTPS
        ];
      };
      useDHCP = mkDefault true;
      networkmanager = {
        enable = true;
        wifi = {
          powersave = false;
          macAddress = "random";
        };
      };
    };
    systemd.services.NetworkManager-wait-online = {
      serviceConfig = {
        ExecStart = [
          ""
          "${pkgs.networkmanager}/bin/nm-online -q"
        ];
      };
    };

    users.users.${user} = {
      isNormalUser = true;
      description = "Simon Yde";
      shell = pkgs.${shell};
      extraGroups = [
        "video"
        "networkmanager"
        "wheel"
      ];
      hashedPasswordFile = config.age.secrets.pc-password.path;
    };

    programs.fish.enable = true; # NOTE: for fish completions for system programs

    environment.systemPackages = with pkgs; [ git ];

    services.udisks2.enable = true;

    boot.initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usb_storage"
      "sd_mod"
    ];
    boot.supportedFilesystems = [ "ntfs" ];
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.editor = false;
    boot.loader.efi.canTouchEfiVariables = true;

    hardware = {
      enableAllFirmware = true;
      enableRedistributableFirmware = true;
      enableAllHardware = true;
    };

    syde.sound.enable = true;
  };

  options.syde.pc = {
    enable = mkEnableOption "PC configuration";
    keyboard.layout = mkOption {
      type = types.str;
      default = "us(colemak_dh),dk";
    };
    keyboard.options = mkOption {
      type = types.str;
      default = "caps:escape,grp:rctrl_toggle";
    };
  };
}
