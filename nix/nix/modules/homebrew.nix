# nix/modules/homebrew.nix
#
# Tap trust (~/.homebrew/trust.json) is handled by nix-darwin: every brew gets
# `trusted: true` in the Brewfile, and `brew bundle --cleanup` rewrites the file
# to exactly those fully-qualified formulae (`trustedformulae`). Write
# third-party brews/casks as `owner/tap/name`; never run `brew trust` by hand.
{...}: {
  homebrew = {
    enable = true;

    brews = [
      "gcc"
      "octave"
      "docker"
      "docker-buildx"
      "container"
      "pyenv"
      "herdr"
      "worktrunk"
      "zsh-autosuggestions"
      "zsh-syntax-highlighting"
      "pnpm"
      "telnet"
      "gromgit/brewtils/taproom"
      "jj"
      "mycli"
      "mole"
      "adibhanna/tsm/tsm"
      "jenkins-lts"
      "asmvik/formulae/yabai"
      "asmvik/formulae/skhd"
    ];

    taps = [
      "adibhanna/tsm"
    ];

    casks = [
      "gcloud-cli"
      "dockdoor"
      "mactex-no-gui"
      "popclip"
      "reminders-menubar"
      "only-switch"
      "browserosaurus"
      "flutter"
      "neohtop"
      "keyguard"
      "dotnet-sdk"
    ];

    onActivation = {
      # Intentional: anything not declared here is removed on switch, including
      # its app data. Check spelling before renaming/removing a cask.
      cleanup = "zap";
      # Upgrade brews on purpose (`brew update && brew upgrade`), never as a
      # side effect of `darwin-rebuild switch` -- nix rollback can't undo it.
      autoUpdate = false;
      upgrade = false;
    };
  };
}
