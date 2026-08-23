# nix/modules/homebrew.nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) concatStringsSep splitString take toLower unique;

  user = "yaswanthgudivada";

  # Homebrew 5.1.15+ refuses to load formulae and casks from third-party taps
  # until they are trusted, and stores that trust in ~/.homebrew/trust.json.
  # Derive the file from the lists below so adding a tap here is all that's
  # needed -- no manual `brew trust` afterwards.
  names = map (entry: toLower entry.name);

  # "owner/tap/formula" -> "owner/tap"; fully-qualified names imply their tap.
  tapOf = name: concatStringsSep "/" (take 2 (splitString "/" name));

  qualified =
    builtins.filter
    (name: builtins.length (splitString "/" name) == 3)
    (names (config.homebrew.brews ++ config.homebrew.casks));

  trustedTaps =
    builtins.sort (a: b: a < b)
    (unique (names config.homebrew.taps ++ map tapOf qualified));

  trustFile =
    (pkgs.formats.json {}).generate "homebrew-trust.json"
    {trustedtaps = trustedTaps;};
in {
  homebrew = {
    enable = true;

    brews = [
      "octave"
      "colima"
      "docker"
      "docker-buildx"
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
      "helm"
    ];

    taps = [
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
      "neohtop"
    ];

    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };

  # preActivation runs before nix-darwin's `homebrew` activation step, so the
  # trust file is in place by the time `brew bundle` reads the taps.
  system.activationScripts.preActivation.text = ''
    echo "syncing Homebrew tap trust..." >&2
    /usr/bin/install -d -o ${user} -g staff -m 0755 /Users/${user}/.homebrew
    /usr/bin/install -o ${user} -g staff -m 0600 ${trustFile} /Users/${user}/.homebrew/trust.json
  '';
}
