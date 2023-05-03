{ config, pkgs, ... }:

{    
  nixpkgs = {
    overlays = [ (self: super: { unstable = import <unstable> {
      config = pkgs.config;
    }; }) ];
    config.packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
    };
    config.allowUnfree = true;
  };
  services.syncthing.enable = true;

  imports = [
    # Programming
    ./terminal.nix
    ./programming.nix
    ./modules/brave.nix
    ./modules/firefox.nix
  ];
}
