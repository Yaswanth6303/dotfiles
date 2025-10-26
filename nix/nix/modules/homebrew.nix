# nix/modules/homebrew.nix
{...}: {
  homebrew = {
    enable = true;

    brews = [
      "mas"
      "zsh-autosuggestions"
      "zsh-syntax-highlighting"
      "git-delta"
      "pnpm"
      "gradle"
      "maven"
      "mongodb-community"
      "mongosh"
      "mongodb-database-tools"
      "powerlevel10k"
      "telnet"
      "gromgit/brewtils/taproom"
      "asciinema"
      "TheZoraiz/ascii-image-converter/ascii-image-converter"
    ];

    taps = [
      "mongodb/brew"
    ];

    masApps = {
      "Dropover" = 1355679052;
      "Bitwarden" = 1352778147;
    };

    casks = [
      "hammerspoon"
      "popclip"
      "reminders-menubar"
      "only-switch"
      "browserosaurus"
    ];

    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}
