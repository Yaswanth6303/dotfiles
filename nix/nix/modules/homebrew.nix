# nix/modules/homebrew.nix
{...}: {
  homebrew = {
    enable = true;

    brews = [
      "container"
      "pyenv"
      "herdr"
      "poppler"
      "typst"
      "kubectx"
      "worktrunk"
      "zsh-autosuggestions"
      "zsh-syntax-highlighting"
      "git-delta"
      "pnpm"
      "mongodb-community"
      "mongosh"
      "mongodb-database-tools"
      "powerlevel10k"
      "telnet"
      "gromgit/brewtils/taproom"
      "asciinema"
      "TheZoraiz/ascii-image-converter/ascii-image-converter"
      "jj"
      "lazyjj"
      "mycli"
      "mole"
      "luarocks"
      "adibhanna/tsm/tsm"
      "mysql"
    ];

    taps = [
      "mongodb/brew"
      "adibhanna/tsm"
    ];

    casks = [
      "gcloud-cli"
      "dockdoor"
      "mactex-no-gui"
      "hammerspoon"
      "popclip"
      "reminders-menubar"
      "only-switch"
      "browserosaurus"
      "flutter"
      "bitwarden"
    ];

    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };
}
