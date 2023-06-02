{ pkgs, ... }:

{
  programs = {
    brave.enable = true;
    firefox.enable = true;
    vscode.enable = true;
    zellij.enable = true;
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerdfonts
    unstable.obsidian
    nix
    synergy
    #gaming
    wine
    discord
    texlive.combined.scheme-full
    rclone
  ];

  services.redshift = {
    enable = true;
    temperature = {
      day = 6500;
      night = 1600;
    };
    provider  = "manual";
    latitude  = 56.8;
    longitude = 9.0;
  };
  imports = [
    ../modules/gtk.nix
  ];
}
