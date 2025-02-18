{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    nur.url = "github:nix-community/NUR";

    flake-utils.url = "github:numtide/flake-utils";
    flake-compat.url = "github:edolstra/flake-compat";
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS modules
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };
    agenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    # home-manager modules
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };
    mini-nvim = {
      url = "github:echasnovski/mini.nvim";
      flake = false;
    };
    tip-vim = {
      url = "github:SimonYde/tip.vim";
      flake = false;
    };

    bookmarks-yazi = {
      url = "github:dedukun/bookmarks.yazi";
      flake = false;
    };

    firefox-csshacks = {
      url = "github:MrOtherGuy/firefox-csshacks";
      flake = false;
    };
    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };

    nix-colors.url = "github:misterio77/nix-colors";
    base16.url = "github:SenchoPens/base16.nix";
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.base16.follows = "base16";
    };

    # My flakes
    pix2tex = {
      url = "github:SimonYde/pix2tex.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kattis-cli = {
      url = "github:SimonYde/kattis-cli.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    grawlix = {
      url = "github:SimonYde/grawlix.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    randcrack = {
      url = "github:SimonYde/randcrack.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    audiobook-dl = {
      url = "github:SimonYde/audiobook-dl.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      pre-commit-hooks,
      flake-utils,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        icarus-wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [ ./nixos/devices/icarus-wsl.nix ];
        };
        icarus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [ ./nixos/devices/icarus.nix ];
        };
        perdix = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [ ./nixos/devices/perdix.nix ];
        };
      };

      homeConfigurations = rec {
        # NOTE: These are here in order to use `nix repl` to check options
        "syde@icarus-wsl" = icarus-wsl;
        "syde@icarus" = icarus;
        "syde@perdix" = perdix;
        icarus = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [
            ./home-manager/standalone.nix
            ./home-manager/devices/icarus.nix
          ];
        };
        icarus-wsl = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [
            ./home-manager/standalone.nix
            ./home-manager/devices/icarus-wsl.nix
          ];
        };
        perdix = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [
            ./home-manager/standalone.nix
            ./home-manager/devices/perdix.nix
          ];
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixfmt-rfc-style.enable = true;
              stylua.enable = true;
            };
          };
        };
        devShells.default = pkgs.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
          packages = with pkgs; [
            just
            stow
          ];
        };
      }
    );
}
