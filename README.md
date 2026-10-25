<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://shieldcn.dev/header/graph.svg?title=dotfiles&subtitle=Declarative+macOS+setup+with+nix-darwin+and+GNU+Stow&logo=nixos&mode=dark" />
    <img alt="dotfiles" src="https://shieldcn.dev/header/graph.svg?title=dotfiles&subtitle=Declarative+macOS+setup+with+nix-darwin+and+GNU+Stow&logo=nixos&mode=light" />
  </picture>
</p>

<p align="center">
  <a href="https://github.com/nix-darwin/nix-darwin"><img alt="nix-darwin" src="https://shieldcn.dev/badge/nix--darwin-flake-5277C3.svg?logo=nixos&variant=secondary" /></a>
  <a href="https://www.apple.com/macos/"><img alt="macOS Apple Silicon" src="https://shieldcn.dev/badge/macOS-Apple_Silicon-000000.svg?logo=apple&variant=secondary" /></a>
  <a href="https://nvchad.com"><img alt="Neovim NvChad" src="https://shieldcn.dev/badge/Neovim-NvChad-57A143.svg?logo=neovim&variant=secondary" /></a>
  <a href="https://github.com/Yaswanth6303/dotfiles/commits/main"><img alt="Last commit" src="https://shieldcn.dev/github/last-commit/Yaswanth6303/dotfiles.svg?variant=secondary" /></a>
  <a href="https://github.com/Yaswanth6303/dotfiles/stargazers"><img alt="GitHub stars" src="https://shieldcn.dev/github/stars/Yaswanth6303/dotfiles.svg?variant=secondary" /></a>
</p>

My macOS setup in one repo. A Nix flake installs every tool, app and font, and GNU Stow links each tool's config into `$HOME`.

## 📦 What's Included

| Area | Tools |
|---|---|
| 🖥️ **Terminal & shell** | [Zsh](zshrc/) · [Starship](starship/) prompt · [Tmux](tmux/) · [Zellij](zellij/) · [WezTerm](wezterm/) · [Ghostty](ghostty/) |
| 📝 **Editors** | [Neovim](nvim/) (NvChad, lazy.nvim, Mason LSPs, DAP, Treesitter) · [Vim](vimrc/) |
| 🎨 **Window management** | [Yabai](yabai/) tiling WM · [Skhd](skhd/) hotkeys · [Hammerspoon](hammerspoon/) (AClock, CountDown spoons) |
| 🎯 **Utilities** | [Bat](bat/) · [Btop](btop/) · [Yazi](yazi/) file manager |
| 📦 **System provisioning** | [Nix](nix/nix/): a `nix-darwin` flake with `nix-homebrew` |

### What the Nix flake manages

- **~95 CLI packages** from nixpkgs: shell tools, languages (Go, Zig, Lua), language servers, Kubernetes, cloud and database CLIs
- **Homebrew**, pinned through `nix-homebrew`, with ~30 brews and ~12 casks declared in [`homebrew.nix`](nix/nix/modules/homebrew.nix)
- **macOS defaults**: Dock, Finder, trackpad and dark mode in [`macos-defaults.nix`](nix/nix/modules/macos-defaults.nix)
- **Fonts**: JetBrains Mono Nerd Font

```
nix/nix/
├── flake.nix              # inputs + the m4air host
└── modules/
    ├── configuration.nix  # core system settings, fonts
    ├── packages.nix       # CLI packages from nixpkgs
    ├── homebrew.nix       # brews, casks, taps
    ├── macos-defaults.nix # System Settings, declaratively
    └── networking.nix
```

## 🛠️ Installation

This repo has two layers. Run them in this order:

1. **Nix flake** (`nix/nix/`) installs all software.
2. **Stow** symlinks the per-tool config folders (`zshrc/`, `nvim/`, `tmux/`, …) into `$HOME`.

### Fresh Mac

```bash
# 1. Xcode CLI tools (needed for git)
xcode-select --install

# 2. Install Nix (Determinate)
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate

# 3. Clone this repo
git clone https://github.com/Yaswanth6303/dotfiles.git ~/dotfiles

# 4. Bring up the system (installs stow, brew, every app)
nix run nix-darwin/master#darwin-rebuild -- \
  switch --flake ~/dotfiles/nix/nix#m4air

# 5. Symlink the per-tool configs
cd ~/dotfiles && stow .
```

Detailed bootstrap, update and rollback commands live in [`nix/nix/README.md`](nix/nix/README.md).

### Day-to-day

```bash
# Apply changes after editing a .nix file
sudo darwin-rebuild switch --flake ~/dotfiles/nix/nix#m4air

# Update nixpkgs + nix-darwin together
nix flake update --flake ~/dotfiles/nix/nix
```

### Stow tips

```bash
stow zshrc      # symlink just one package
stow -D zshrc   # remove a stowed package
stow -R zshrc   # re-stow (useful after editing)
```

`.stowrc` targets `$HOME` and skips `.DS_Store`, `.git`, `.gitignore` and `README.md`.

## 🔧 Prerequisites

- macOS on Apple Silicon (`aarch64-darwin`)
- Xcode Command Line Tools
- [Nix](https://nixos.org/download) (Determinate installer recommended)

The Nix flake installs Stow and Homebrew for you, so you don't need them in advance.

## 🤝 Contributing

Feel free to fork this repository and make it your own. If you find an issue or have an idea, open an issue or a pull request.

## 📝 License

This project is open source and available under the MIT License.

## 🙏 Acknowledgments

- Inspired by many dotfiles repositories in the community
- Thanks to all the tool creators and maintainers

---

<p align="center">Made with ❤️ by Yaswanth Gudivada</p>
