{
  config,
  inputs,
  lib,
  ...
}:

let
  stylix = inputs.stylix;
  theming = config.syde.theming;
  fonts = theming.fonts;
  cursor = theming.cursor;
in
{
  config = {
    stylix = {
      enable = true;
      # TODO: remove when this becomes optional... https://github.com/danth/stylix/issues/442
      image = config.lib.stylix.pixel "base00";
      base16Scheme = config.colorScheme.palette;
      polarity = config.colorScheme.variant;
      targets = {
        hyprpaper.enable = lib.mkForce false;
        hyprland.enable = false;
        hyprlock.enable = false;
        sway.enable = false;
        swaylock.enable = false;
        wezterm.enable = false;
        vim.enable = false;
        helix.enable = true;
        neovim.enable = false;
        nushell.enable = false;
        waybar.enable = false;
        zellij.enable = false;
        zathura.enable = false;
        fzf.enable = false;
      };
      cursor = {
        package = cursor.package;
        name = cursor.name;
        size = 24;
      };
      fonts = {
        monospace = fonts.monospace;
        serif = fonts.serif;
        sansSerif = fonts.sansSerif;
        emoji = fonts.emoji;
        sizes = {
          terminal = 12;
          # popups = 12;
        };
      };

      opacity = {
        terminal = config.syde.terminal.opacity;
      };
    };
  };

  imports = [ stylix.homeManagerModules.stylix ];
}
