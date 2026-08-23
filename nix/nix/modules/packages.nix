# nix/modules/packages.nix
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # === Core System Tools ===
    fastfetch
    gnupg

    # === Terminal & Shell ===
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
    emacs
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
    # Build tools
    bazelisk
    # Others
    shellcheck
    cocoapods

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
