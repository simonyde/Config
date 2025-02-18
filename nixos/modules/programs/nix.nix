{ inputs, ... }:
{
  nixpkgs.flake = {
    setNixPath = true;
    setFlakeRegistry = true;
  };

  nix = {
    registry.stable.flake = inputs.stable;
    channel.enable = false;

    settings = {
      experimental-features = [
        "pipe-operators"
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
      auto-optimise-store = true;

      substituters = [
        "https://cuda-maintainers.cachix.org"
        "https://hyprland.cachix.org"
        "https://cosmic.cachix.org"
        "https://nix-community.cachix.org"
        "https://ghostty.cachix.org"
      ];

      trusted-public-keys = [
        "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    optimise = {
      automatic = true;
    };

    gc = {
      automatic = false;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
