# nix/modules/homebrew.nix
{...}: {
  homebrew = {
    enable = true;

    brews = [
      "typst"
      "kubectx"
      "worktrunk"
      "mas"
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
      "sinelaw/fresh/fresh-editor"
      "mole"
      "luarocks"
      "adibhanna/tsm/tsm"
    ];

    taps = [
      "mongodb/brew"
      "adibhanna/tsm"
    ];

    masApps = {
      "Bitwarden" = 1352778147;
    };

    casks = [
      "mactex-no-gui"
      "hammerspoon"
      "popclip"
      "reminders-menubar"
      "only-switch"
      "browserosaurus"
      "flutter"
    ];

    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}
