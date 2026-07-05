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
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nix-homebrew.inputs.brew-src.follows = "homebrew-brew";
    homebrew-brew = {
      url = "github:Homebrew/brew/5.1.10";
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
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = false;
              user = "yaswanthgudivada";
              autoMigrate = true;
            };
          }
        ];
      };
  in {
    # Build with: darwin-rebuild switch --flake .#m4air
    darwinConfigurations.m4air = mkDarwin "m4air";

    # Expose the package set (with overlays) for `nix build .#darwinPackages.<pkg>`.
    darwinPackages = self.darwinConfigurations.m4air.pkgs;

    formatter.${system} = pkgs.alejandra;

    checks.${system}.darwin = self.darwinConfigurations.m4air.system;
  };
}
