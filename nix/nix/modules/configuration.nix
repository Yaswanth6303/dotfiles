# nix/modules/configuration.nix
{pkgs, ...}: {
  imports = [
    ./packages.nix
    ./homebrew.nix
    ./macos-defaults.nix
    ./networking.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = "yaswanthgudivada";

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    # Only root is trusted (trusted = root-equivalent). Admins still use nix
    # normally; system changes go through `sudo darwin-rebuild`.
    trusted-users = ["root"];
    auto-optimise-store = true;
    warn-dirty = false;
  };

  nix.gc = {
    automatic = true;
    interval = {
      Hour = 3;
      Minute = 15;
      Weekday = 0;
    };
    options = "--delete-older-than 14d";
  };

  nix.optimise = {
    automatic = true;
    interval = {
      Hour = 4;
      Minute = 15;
      Weekday = 0;
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  # GUI apps: nix-darwin itself copies them into /Applications/Nix Apps
  # (Spotlight-visible), so no custom activation script is needed.

  programs.zsh.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  system.stateVersion = 6;
}
