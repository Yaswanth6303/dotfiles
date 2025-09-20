# nix/modules/configuration.nix
{
  pkgs,
  config,
  ...
}: {
  # Enable unfree packages
  nixpkgs.config.allowUnfree = true;

  # Apply overlays
  nixpkgs.overlays = import ../overlays;

  # Set the primary user
  system.primaryUser = "yaswanthgudivada";

  # Import other modules
  imports = [
    ./packages.nix
    ./homebrew.nix
  ];

  # Font configuration
  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  # System activation script for applications
  system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = "/Applications";
    };
  in
    pkgs.lib.mkForce ''
      # Set up applications.
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

  # Enable flakes and nix-command
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Shell configuration
  programs.zsh.enable = true;

  # System version and state
  system.configurationRevision = null;
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
