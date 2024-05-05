{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  random_background = pkgs.writeShellScriptBin "ran_bg" ''
    DIRECTORY=${config.xdg.configHome}/backgrounds/${config.colorScheme.slug}

    # Check if the provided directory exists
    if [ ! -d "$DIRECTORY" ]; then
        echo "Directory does not exist: $DIRECTORY"
        exit 1
    fi

    # Find all image files in the directory and pick one at random
    IMAGES=$(find "$DIRECTORY" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.gif' -o -iname '*.jpeg' \))
    IMAGE=$(echo "$IMAGES" | shuf -n1)
    ${pkgs.swww}/bin/swww img "$IMAGE"
  '';
  palette = config.colorScheme.palette;
  terminal = config.syde.terminal;
  browser = config.syde.browser;
  menu = "${pkgs.rofi-wayland}/bin/rofi -show drun";
  cfg = config.wayland.windowManager.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      swww # Background daemon
      random_background # random background script
      playerctl # media keys
      pamixer # volume keys
      networkmanagerapplet

      pavucontrol # audio control

      grimblast # screenshot tool
      wl-clipboard # clipboard manager
      hyprpicker # color picker
    ];

    # home.sessionVariables.NIXOS_OZONE_WL = "1";

    programs = {
      imv.enable = true;
      mpv.enable = true;
      rofi.enable = true;
      swaylock.enable = true;
      hyprlock.enable = false;
      waybar.enable = true;
    };

    services = {
      dunst.enable = true;
    };

    wayland.windowManager.hyprland = {
      settings = {
        general = with palette; {
          gaps_in = 3;
          gaps_out = 8;
          border_size = 2;
          "col.active_border" = "rgba(${base0D}ff) rgba(${base0E}ff) 45deg";
          "col.inactive_border" = "transparent";
          layout = "dwindle";
          resize_on_border = true;
          allow_tearing = true; # For gaming. Set windowrule `immediate` for games to enable.
        };

        misc.disable_hyprland_logo = true;

        input = {
          kb_layout = "us(colemak_dh),dk";
          kb_options = "caps:escape";
          repeat_delay = 200;
          follow_mouse = 2;
          accel_profile = "flat";
          touchpad = {
            scroll_factor = 0.7;
            natural_scroll = true;
          };
        };

        decoration = {
          rounding = 10;
          blur = {
            enabled = true;
            size = 6;
            passes = 2;
            new_optimizations = true;
            ignore_opacity = true;
            xray = false;
          };
          drop_shadow = false;
        };

        animations = {
          enabled = true;
          bezier = [
            "wind, 0.05, 0.9, 0.1, 1.05"
            "winIn, 0.1, 1.1, 0.1, 1.1"
            "winOut, 0.3, -0.3, 0, 1"
            "liner, 1, 1, 1, 1"
          ];
          animation = [
            "windows, 1, 3, wind, slide"
            "windowsIn, 1, 3, winIn, slide"
            "windowsOut, 1, 2, winOut, slide"
            "windowsMove, 1, 2, wind, slide"
            "border, 1, 1, liner"
            "borderangle, 1, 30, liner, loop"
            "fade, 1, 7, default"
            "workspaces, 0, 4, wind"
          ];
        };

        monitor = [
          "eDP-1, 1920x1080, 0x0, 1"
          "desc:Ancor Communications Inc VG248 FBLMQS053462, 1920x1080@119.982002, 0x-1080, 1"
          "desc:Dell Inc. DELL U2722D 5TNW7P3, 2560x1440@60, 0x-1440, 1"
          "desc:HP Inc. HP E273q 6CM9191YW0, 2560x1440@60, 0x-1440, 1,transform,0"
          "desc:HP Inc. HP E273q 6CM9191ZBN, 2560x1440@60, 0x-1440, 1,transform,0"
          "desc:HP Inc. HP E273q 6CM9191ZBQ, 2560x1440@60, 0x-1440, 1,transform,0" # I hate this
          ",preferred,auto,1,transform,0"
        ];

        "$browser" = browser;
        "$filemanager" = "${pkgs.xfce.thunar}/bin/thunar";
        "$menu" = menu;
        "$terminal" = terminal.emulator;

        exec-once = [
          "waybar"
          "nm-applet"
          "blueman-applet"
          "${pkgs.swww}/bin/swww-daemon"
          "[workspace 1] obsidian"
          "${random_background}/bin/ran_bg"
        ];
      };
      extraConfig =
        builtins.readFile ./devices.conf
        + builtins.readFile ./keybindings.conf
        + builtins.readFile ./windowrules.conf;
    };
  };

  imports = [ inputs.hyprland.homeManagerModules.default ];
}
