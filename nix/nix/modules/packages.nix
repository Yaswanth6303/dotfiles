# nix/modules/packages.nix
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # === Core System Tools ===
    mkalias
    fastfetch
    gnupg

    # === Terminal & Shell ===
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
    mise # To control versions and environments

    # === Programming Languages & Tools ===
    # Go
    go
    gopls
    air # Live reload for go apps
    # Zig
    zig
    zls
    # Ruby
    ruby
    rbenv
    # Lua
    lua
    luajitPackages.luarocks_bootstrap
    # Buildtools
    bazel
    bazelisk
    # Others
    shellcheck
    terraform

    # === Database Tools ===
    (postgresql.withPackages (ps: [ps.pg_cron]))
    pgcli
    pgxnclient # PostgreSQL Extension Network client (from overlay)
    usql # Universal SQL client
    mysql-shell-innovation

    # === Cloud & DevOps ===
    awscli
    heroku
    podman
    podman-tui
    lazydocker
    opentofu
    vault

    # === Web Servers ===
    angie # Angie web server - NGINX-compatible fork

    # === Network & Security ===
    xh
    oha
    nmap
    speedtest-cli
    trufflehog

    # === Media & Productivity ===
    imagemagick
    jellyfin-ffmpeg
    openjpeg
    pympress
    cowsay
    duf
    mailsy
    notesnook
    monitorcontrol
    tuckr

    # === macOS Specific ===
    keycastr
    macmon
  ];
}
