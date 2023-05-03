{ pkgs,  ... }:

{
  programs.fish = {
    shellAliases = {
      cat = "bat";
      ls = "exa";
      sudo = "doas";
    };
    shellInit = ''
      any-nix-shell fish --info-right | source
    '';
  };
}
