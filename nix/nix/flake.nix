{
  description = "Yaswanth's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {
        
      nixpkgs.config.allowUnfree = true;
      
      # Set the primary user for homebrew and other user-specific options
      system.primaryUser = "yaswanthgudivada";
      
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.neovim
          pkgs.mkalias
          pkgs.tmux
          pkgs.eza
          pkgs.yazi
          pkgs.ripgrep
          pkgs.zoxide
          pkgs.fzf
          pkgs.fd
          pkgs.bat
          pkgs.tldr
          pkgs.pay-respects
          pkgs.carapace
          pkgs.rbenv
          pkgs.keycastr
          pkgs.monitorcontrol
          pkgs.stow
          pkgs.wezterm
          pkgs.lazygit
          pkgs.awscli
        ];

      homebrew = {
        enable = true;
        brews = [
            "mas"
            "zsh-autosuggestions"
            "zsh-syntax-highlighting"
            "git-delta"
        ];
        masApps = {
            "Dropover" = 1355679052;
        };
        casks = [
            "hammerspoon"
            "popclip"
            "reminders-menubar"
            "only-switch"
        ];
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };

      fonts.packages = [
          pkgs.nerd-fonts.jetbrains-mono
      ];

      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in pkgs.lib.mkForce ''
          echo "Setting up /Applications..." >&2
          
          # Remove old Nix Apps folder if it exists
          rm -rf /Applications/Nix\ Apps
          
          # Remove any existing symlinks to Nix store applications
          find /Applications -type l -lname "/nix/store/*" -delete
          
          # Create direct symlinks in /Applications for all GUI apps
          find ${env}/Applications -maxdepth 1 -type l -name "*.app" | while read -r src; do
            app_name=$(basename "$src")
            target="/Applications/$app_name"
            if [ ! -e "$target" ]; then
              echo "Linking $app_name to /Applications" >&2
              ln -sf "$src" "$target"
            else
              echo "$app_name already exists in /Applications, skipping" >&2
            fi
          done
          
          # Refresh Launchpad database
          echo "Refreshing Launchpad database..." >&2
          /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
        '';

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = [ "nix-command" "flakes" ];

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."m4air" = nix-darwin.lib.darwinSystem {
      modules = [ 
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
              nix-homebrew = {
                  enable = true;
                  enableRosetta = true;
                  user = "yaswanthgudivada";

                  # If homebrew already installed in machine
                  autoMigrate = true;
              };
          }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."m4air".pkgs;
  };
}
