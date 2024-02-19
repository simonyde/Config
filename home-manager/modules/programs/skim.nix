{ config, ... }:

{
  programs.skim = {
    enableFishIntegration = true;
    enableZshIntegration = true;
    changeDirWidgetCommand = "fd --type d";
    fileWidgetCommand = "fd --type f";
    defaultOptions = with config.colorScheme.palette; [
      "--color=${
        builtins.concatStringsSep "," [
          "fg:#${base05}"
          "matched:#${base02}"
          "matched_bg:#${base0F}"
          "current:#${base05}"
          "current_bg:#${base03}"
          "current_match:#${base00}"
          "current_match_bg:#${base06}"
          "spinner:#${base0B}"
          "info:#${base0E}"
          "prompt:#${base0D}"
          "cursor:#${base08}"
          "selected:#${base07}"
          "header:#${base0C}"
          "border:#${base04}"
      ]}"
    ];
  };
}
