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

## 🛠️ Installation

1. Install GNU Stow:

   ```bash
   brew install stow
   ```

2. Clone this repository:

   ```bash
   git clone https://github.com/Yaswanth6303/dotfiles.git
   cd dotfiles
   ```

3. Use Stow to create symlinks (choose one method):

   **Method 1: Stow all configurations at once**

   ```bash
   stow .
   ```

   **Method 2: Stow specific configurations**

   ```bash
   stow zshrc
   stow nvim
   stow tmux
   # ... and so on for other configurations
   ```

   To remove a stowed configuration:

   ```bash
   stow -D zshrc  # Removes zshrc symlinks
   ```

## 🔧 Prerequisites

- macOS (tested on macOS 24.4.0)
- Homebrew package manager
- Git
- GNU Stow

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
