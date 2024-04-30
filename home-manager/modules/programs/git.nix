{ pkgs, config, lib, ... }:
{
  programs.git = {
    userName = "Simon Yde";
    userEmail = "git@simonyde.com";
    extraConfig = {
      init = {
        defaultBranch = "master";
      };
      pull = {
        rebase = false;
      };
      push = {
        autoSetupRemote = true;
      };
      merge = {
        conflictStyle = "diff3";
      };
      rebase = {
        updateRefs = true;
      };
      diff = {
        colorMoved = "default";
      };
      rerere = {
        enabled = true;
      };
      column.ui = "auto";
      branch.sort = "-committerdate";
    };
    ignores = [
      "*.sync-conflict*"
      ".direnv"
      ".stignore"
      "*.log"
      ".stfolder"
      ".vscode"
      ".mypy_cache"
      ".ruff_cache"
      "**/_build"
      "**/target"
      "**/node_modules"
      "**/elm-stuff"
    ];
    delta = {
      enable = true;
      options = {
        navigate = true;
        features = lib.mkForce (builtins.concatStringsSep " " [
          "line-numbers"
          "side-by-side"
          "catppuccin-${config.syde.theming.flavour}"
        ]);
      };
    };
  };

  programs.gh = {
    settings = {
      git_protocol = "ssh";
    };
  };

  home.packages = with pkgs; [
    git-crypt
    glab
  ];
}
