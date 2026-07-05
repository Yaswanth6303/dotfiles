# nix/modules/configuration.nix
{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./packages.nix
    ./homebrew.nix
    ./macos-defaults.nix
    ./networking.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = import ../overlays;
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = "yaswanthgudivada";

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["root" "@admin" "yaswanthgudivada"];
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

  # Copy GUI apps from the Nix store into /Applications/Nix Apps so Spotlight finds them.
  # Required workaround: nix-darwin only symlinks, which Finder/Spotlight don't follow.
  system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = ["/Applications"];
    };
  in
    pkgs.lib.mkForce ''
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read -r src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    '';

  programs.zsh.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  system.stateVersion = 6;
}
