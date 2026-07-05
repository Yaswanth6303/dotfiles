# 🚀 My Dotfiles

Welcome to my dotfiles repository! This is where I keep all my configuration files and settings for various tools and applications I use on my macOS system.

## 📦 What's Included

- 🖥️ **Terminal & Shell**

  - [Zsh](zshrc/) - Shell configuration
  - [Tmux](tmux/) - Terminal multiplexer
  - [WezTerm](wezterm/) - Modern terminal emulator
  - [Ghostty](ghostty/) - Fast terminal emulator

- 🎨 **Window Management**

  - [Yabai](yabai/) - Tiling window manager
  - [Skhd](skhd/) - Hotkey daemon

- 📝 **Text Editors**

  - [Neovim](nvim/) - Modern Vim editor

- 🎯 **Utilities**

  - [Bat](bat/) - Modern `cat` replacement
  - [Btop](btop/) - System resource monitor
  - [Yazi](yazi/) - Terminal file manager
  - [Zellij](zellij/) - Terminal workspace

- 📦 **System provisioning**
  - [Nix](nix/) - `nix-darwin` flake that installs every CLI tool, GUI app, brew, cask, and font on this machine. See [`nix/nix/README.md`](nix/nix/README.md) for the bootstrap.

## 🛠️ Installation

This repo has two layers:

1. **Nix flake** (`nix/nix/`) — installs all software (CLI tools, brews, casks, fonts, GUI apps).
2. **Stow** — symlinks the per-tool config directories (`zshrc/`, `nvim/`, `tmux/`, …) into `$HOME`.

Run them in that order.

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

Detailed bootstrap, update, and rollback commands live in [`nix/nix/README.md`](nix/nix/README.md).

### Stow tips

```bash
stow zshrc           # symlink just one package
stow -D zshrc        # remove a stowed package
stow -R zshrc        # re-stow (useful after editing)
```

## 🔧 Prerequisites

- macOS on Apple Silicon (`aarch64-darwin`)
- Xcode Command Line Tools
- [Nix](https://nixos.org/download) (Determinate installer recommended)

Stow and Homebrew are installed for you by the Nix flake — you do not need them in advance.

## 📚 Usage

Each directory contains specific configurations for different tools. Navigate to the respective directories to find detailed setup instructions.

## 🤝 Contributing

Feel free to fork this repository and customize it to your needs. If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## 📝 License

This project is open source and available under the MIT License.

## 🙏 Acknowledgments

- Inspired by various dotfiles repositories in the community
- Special thanks to all the tool creators and maintainers

---

Made with ❤️ by Yaswanth Gudivada
