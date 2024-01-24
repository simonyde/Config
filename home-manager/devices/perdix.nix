{ pkgs, config, lib, ... }:

let emulator = config.syde.terminal.emulator; in
{
  config = {
    programs = {
      # Browsers
      brave.enable   = true;
      firefox.enable = true;

      # Terminal emulators
      ${emulator}.enable = true;

      # other GUI programs
      vscode.enable  = false;
      zathura.enable = true;
    };

    # personal program configurations
    syde.programs = { 
      thunar.enable = true;
    };

    services = {
      gammastep.enable = true;
      redshift.enable  = false;
    };

    fonts.fontconfig.enable = true;
    xdg.enable = true;
    gtk.enable = true;
    qt.enable  = true;

    # Personal modules
    syde = {
      email.enable = false;
      ssh.enable   = true;
    };

    xsession.enable = false;
    xsession.windowManager.i3.enable  = false;
    wayland.windowManager.sway.enable = false;
    wayland.windowManager.hyprland.enable = true;

    home.packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
          "FiraCode"
        ];
      })
      font-awesome
      unstable.obsidian
      libqalculate
      # synergy
      libreoffice

      discord
      betterdiscordctl

      r2modman

      rclone

      floorp
      keepassxc

      # handbrake
      bitwig-studio
      # obs-studio
    ];


    syde.unfreePredicates = [
      "discord"
      "obsidian"
      "bitwig-studio"
    ];

    home.pointerCursor = let cursorTheme = config.syde.theming.cursorTheme; in {
      name    = cursorTheme.name;
      package = cursorTheme.package;
      size    = 24;
      gtk.enable = config.gtk.enable;
    };
  };

  imports = [
    ../standard.nix
  ];
}
