# nix-darwin bootstrap

Fresh-Mac setup for `m4air`. Run top-to-bottom.

## Layout

```
nix/nix/
├── flake.nix              # entrypoint; pinned inputs + mkDarwin helper
├── flake.lock             # version lock (reproducibility)
├── modules/
│   ├── configuration.nix  # nix settings, GC, Touch ID, /Applications wiring
│   ├── packages.nix       # every CLI tool, font, GUI app to install via nix
│   ├── homebrew.nix       # brews/casks/taps managed via nix-homebrew
│   ├── macos-defaults.nix # declarative dock/finder/trackpad/etc. settings
│   └── networking.nix     # hostname → computerName / NetBIOS / Bonjour
└── overlays/
    └── pgxnclient.nix     # local package, not in nixpkgs
```

## 1. Prerequisites

```sh
xcode-select --install
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
```

Open a new shell so `nix` is on `PATH`.

## 2. Clone the dotfiles repo

```sh
git clone https://github.com/Yaswanth6303/dotfiles.git ~/dotfiles
```

## 3. First activation

`darwin-rebuild` is not installed yet — bootstrap it via `nix run`:

```sh
mkdir -p ~/Pictures/Screenshots   # path declared in macos-defaults.nix
nix run nix-darwin/master#darwin-rebuild -- \
  switch --flake ~/dotfiles/nix/nix#m4air
```

First run takes 15–30 min. After completion you have:

- `nix-darwin` itself, plus every package in `modules/packages.nix`
- Homebrew (installed by `nix-homebrew`) and every brew/cask in `modules/homebrew.nix`
- Touch ID for `sudo` (via PAM)
- Weekly automatic GC + store optimisation (launchd: `org.nixos.nix-gc`, `org.nixos.nix-optimise`)
- All Dock / Finder / trackpad / clock / Stage Manager / login-window defaults applied
- Hostname, Bonjour name, NetBIOS name, and computer name all derived from `flake.nix`

## 4. Stow user dotfiles

```sh
cd ~/dotfiles && stow .
```

## 5. Verify (recommended after first switch)

```sh
# Touch ID sudo wiring
cat /etc/pam.d/sudo_local                       # → 'auth sufficient pam_tid.so'

# Hostname surfaces all coherent
scutil --get LocalHostName                      # → m4air
scutil --get ComputerName                       # → Yaswanth's MacBook Air
defaults read /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName  # → M4AIR

# GC + optimise launchd jobs registered
sudo launchctl list | grep org.nixos

# Current generation
sudo darwin-rebuild --list-generations | tail -3
```

## Subsequent updates

```sh
cd ~/dotfiles/nix/nix
nix flake update                  # bump pinned inputs in flake.lock
nix flake check                   # static eval (type-check, no build)
darwin-rebuild build --flake .#m4air   # build new system without activating
sudo darwin-rebuild switch --flake .#m4air   # activate
```

## Recovery cheatsheet

| Need | Command |
|---|---|
| Roll back to previous generation | `sudo darwin-rebuild --rollback` |
| List generations | `sudo darwin-rebuild --list-generations` |
| Free disk now (weekly GC also runs) | `nix-collect-garbage -d` |
| Format `.nix` files | `nix fmt` |
| Add / rename a host | `flake.nix` → add another `mkDarwin "<name>"` |
| Change machine identity | edit `networking.hostName` in `flake.nix` (everything else follows) |
| Lift a manual `defaults write` into nix | `defaults read <domain> <key>`, then add under matching block in `modules/macos-defaults.nix` (or `CustomUserPreferences` if untyped) |
