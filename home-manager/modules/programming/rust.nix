{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.syde.programming.rust;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      cargo
      rustc
      lldb
      rust-analyzer
      rustfmt
      clippy
      gcc
    ];

    programs.neovim.plugins = with pkgs.vimPlugins; [
      rustaceanvim # Extra rust support
      crates-nvim
    ];

    home.sessionVariables = {
      CARGO_HOME = "${config.xdg.cacheHome}/cargo";
    };
  };

  options.syde.programming.rust = {
    enable = lib.mkEnableOption "Rust programming language support";
  };
}
