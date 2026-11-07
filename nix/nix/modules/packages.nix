# nix/modules/packages.nix
{pkgs, ...}: let
  # Google's official launcher, exposed under the name `bazel`.
  # A symlink rather than an overrideAttrs so bazelisk still comes prebuilt
  # from the binary cache; it then fetches the genuine upstream Bazel release
  # each project pins in its .bazelversion.
  bazel-via-bazelisk =
    pkgs.runCommand "bazel-via-bazelisk" {
      meta.mainProgram = "bazel";
    } ''
      mkdir -p "$out/bin"
      ln -s ${pkgs.bazelisk}/bin/bazelisk "$out/bin/bazel"
    '';
in {
  environment.systemPackages = with pkgs; [
    # === Core System Tools ===
    fastfetch
    gnupg

    # === Terminal & Shell ===
    terminaltexteffects
    tuios
    aria2
    kind
    kubectl
    opam
    devbox
    ffmpeg
    plantuml
    sapling
    television
    gawk
    tmux
    fish
    nushell
    zsh
    eza
    yazi
    bat
    fd
    ripgrep
    zoxide
    fzf
    tldr
    tree
    pay-respects
    carapace
    sesh
    btop
    pastel
    navi
    cbonsai
    croc
    ttyd
    wttrbar
    starship
    lima
    fx
    zellij
    qtpass
    zbar

    # === Development Tools ===
    neovim
    drawio
    helix
    lazygit
    gitleaks
    gh
    stow
    gitea
    httpie
    python313Packages.faker
    pass
    mise

    # === Programming Languages & Tools ===
    # Go
    go
    gopls
    air
    # Zig
    zig
    zls
    # Lua
    lua
    luajitPackages.luarocks_bootstrap
    # Python
    ruff
    basedpyright
    # Web (TypeScript, Svelte, HTML/CSS/JSON, YAML)
    vtsls
    svelte-language-server
    vscode-langservers-extracted
    yaml-language-server
    # Others
    shellcheck
    cocoapods

    # === Build Systems ===
    bazelisk
    bazel-via-bazelisk

    # === Database Tools ===
    pgcli
    usql
    mysql-shell-innovation

    # === Cloud & DevOps ===
    awscli
    heroku
    podman
    podman-compose
    podman-tui
    lazydocker
    opentofu

    # === Web Servers ===
    # angie

    # === Network & Security ===
    xh
    oha
    nmap
    speedtest-cli
    trufflehog

    # === Media & Productivity ===
    imagemagick
    openjpeg
    pympress
    cowsay
    duf
    mailsy
    monitorcontrol
    tuckr

    # === macOS Specific ===
    keycastr
    macmon
  ];
}
