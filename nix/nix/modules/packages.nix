# nix/modules/packages.nix
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # === Core System Tools ===
    mkalias
    fastfetch
    gnupg

    # === Terminal & Shell ===
    wezterm
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

    # === Development Tools ===
    neovim
    helix
    lazygit
    jujutsu
    lazyjj
    gitleaks
    gh
    stow

    # === Programming Languages & Tools ===
    # Go
    go
    gopls
    # Zig
    zig
    zls
    # Ruby
    ruby
    rbenv
    # Lua
    lua
    luajitPackages.luarocks_bootstrap
    # Others
    shellcheck
    terraform

    # === Database Tools ===
    mysql84
    (postgresql.withPackages (ps: [ps.pg_cron]))
    pgcli
    pgxnclient # PostgreSQL Extension Network client (from overlay)
    usql # Universal SQL client

    # === Cloud & DevOps ===
    awscli
    heroku
    podman
    podman-tui
    lazydocker
    dotenvx

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

    # === macOS Specific ===
    keycastr
    monitorcontrol
    macmon
    brave
  ];
}
