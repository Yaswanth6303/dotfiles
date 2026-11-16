{
  description = "Yaswanth's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # nix-darwin master is required when tracking nixpkgs-unstable.
    # Reproducibility is enforced by flake.lock; bump explicitly with `nix flake update`.
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nix-homebrew's `brew` launcher is written for one Homebrew version, so pin
    # it together with homebrew-brew below. This rev matches brew 6.0.15; to bump
    # brew, use a nix-homebrew rev whose own flake.lock pins the same brew ref.
    nix-homebrew.url = "github:zhaofengli/nix-homebrew/7be2ffcda4d9632edb7150b263ee081abba5e984";
    nix-homebrew.inputs.brew-src.follows = "homebrew-brew";
    homebrew-brew = {
      url = "github:Homebrew/brew/6.0.15";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    nix-homebrew,
    ...
  }: let
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};

    mkDarwin = hostname:
      nix-darwin.lib.darwinSystem {
        specialArgs = {inherit inputs self;};
        modules = [
          ./modules/configuration.nix
          {
            networking.hostName = hostname;
            system.configurationRevision = self.rev or self.dirtyRev or null;
          }
          nix-homebrew.darwinModules.nix-homebrew
          ({config, ...}: {
            nix-homebrew = {
              enable = true;
              enableRosetta = false;
              user = config.system.primaryUser;
              autoMigrate = true;
            };
          })
        ];
      };
  in {
    # Build with: darwin-rebuild switch --flake .#m4air
    darwinConfigurations.m4air = mkDarwin "m4air";

    # Expose the system's package set for `nix build .#darwinPackages.<pkg>`.
    darwinPackages = self.darwinConfigurations.m4air.pkgs;

    formatter.${system} = pkgs.alejandra;

    checks.${system}.darwin = self.darwinConfigurations.m4air.system;
  };
}
