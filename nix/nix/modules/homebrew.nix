# nix/modules/homebrew.nix
{...}: {
  homebrew = {
    enable = true;

    brews = [
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
      "mactex-no-gui"
      "hammerspoon"
      "popclip"
      "reminders-menubar"
      "only-switch"
      "browserosaurus"
      "flutter"
      "bitwarden"
    ];

    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}
