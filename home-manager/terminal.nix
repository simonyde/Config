{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    mkEnableOption
    ;
  cfg = config.syde.terminal;
in
{
  config = mkIf cfg.enable {
    programs = {
      # Shells
      fish.enable = true;
      bash.enable = true;
      nushell.enable = true;
      zsh.enable = false;

      # CLI tools
      atuin.enable = true;
      bat.enable = true;
      btop.enable = true;
      direnv.enable = true;
      eza.enable = true;
      fzf.enable = true;
      gh.enable = true;
      git.enable = true;
      lazygit.enable = true;
      lf.enable = false;
      nix-index.enable = true;
      ripgrep.enable = true;
      skim.enable = true;
      starship.enable = true;
      thefuck.enable = true;
      yazi.enable = true;
      zellij.enable = true;
      zoxide.enable = true;
    };

    home.sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];

    home.packages = with pkgs; [
      # CLI Tools
      dogdns # rust version of `dig`
      du-dust # Histogram of file sizes
      fd # Friendlier `find`
      jq # JSON magic
      gnumake
      just # alternative to `gnumake`
      sd # Friendlier `sed`
      trashy # for when `rm -rf` is too scary
      xh # Colorful curl
      yt-dlp

      tokei # Counting lines of code
      tldr # Quick hits on programs

      entr
      pandoc

      nix-output-monitor

      grawlix
      pix2tex
      nur.repos.jo1gi.audiobook-dl-git
    ];

    home.shellAliases = {
      c = "clear";
      rt = "trash put";
    };
  };

  options.syde.terminal = {
    enable = mkEnableOption "terminal configuration";
    font = mkOption {
      type = types.str;
      default = "JetBrains Mono Nerd Font Mono";
    };
    fontSize = mkOption {
      type = types.float;
      default = 11.5;
    };
    emulator = mkOption {
      type = types.enum [
        "alacritty"
        "kitty"
        "wezterm"
      ];
      default = "alacritty";
    };
    opacity = mkOption {
      type = types.float;
      default = 0.85;
    };
    cursor = mkOption {
      type = types.enum [
        "block"
        "beam"
        "underline"
      ];
      default = "beam";
    };
  };
}
