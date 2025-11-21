# Dotfiles

Personal configuration files for macOS development environment.

## Overview

This repository contains configuration files for:

- **Shell**: Zsh with Oh My Zsh, Powerlevel10k theme
- **Editor**: Neovim (Lua-based configuration with lazy.nvim)
- **Terminal**: Alacritty terminal emulator
- **Multiplexer**: tmux
- **Window Manager**: yabai + skhd (macOS tiling window manager)
- **Tools**: fzf, pyenv, thefuck, ctags, sqlfluff
- **Note-taking**: Obsidian with Vim mode

## Prerequisites

- macOS (required for yabai/skhd)
- Python 3
- Git
- Internet connection for downloading packages

## Installation

### Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Run the deployment script
./deploy.py
```

### What Gets Installed

The `deploy.py` script will:

1. **Install Homebrew** (if not already installed)
2. **Install applications** via Homebrew:
   - neovim
   - tmux
   - node
   - pyenv
   - fzf
   - thefuck
   - zsh-syntax-highlighting
   - zsh-autosuggestions
   - powerlevel10k
   - JetBrains Mono Nerd Font (for terminal icons)
3. **Install Zsh plugins**:
   - zsh-github-copilot (cloned to `~/.oh-my-zsh/custom/plugins/`)
4. **Create Python virtual environment** for Neovim LSP support at `~/.local/share/nvim/base_venv`
5. **Symlink configuration files** to their appropriate locations:
   - Neovim configs → `~/.config/nvim/`
   - Alacritty config → `~/.config/alacritty/`
   - tmux config → `~/.config/tmux/`
   - Zsh configs → `~/.zshrc`, `~/.bash_aliases`, `~/.p10k.zsh`
   - fzf config → `~/.fzf.zsh`
   - EditorConfig → `~/.editorconfig`

### Manual Steps

Some tools require manual installation or configuration:

1. **Install Oh My Zsh** (required for zsh config):
   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

2. **Set Zsh as default shell** (if not already):
   ```bash
   chsh -s $(which zsh)
   ```

3. **Install Alacritty**:
   ```bash
   brew install --cask alacritty
   ```

4. **Install yabai and skhd** (optional, for window management):
   ```bash
   brew install koekeishiya/formulae/yabai
   brew install koekeishiya/formulae/skhd
   brew services start yabai
   brew services start skhd
   ```

5. **Configure Powerlevel10k theme**:
   - Restart your terminal
   - The p10k configuration wizard will run automatically
   - Or manually run: `p10k configure`

## Repository Structure

```
dotfiles/
├── configs/                    # All configuration files
│   ├── alacritty/             # Terminal emulator
│   ├── ctags/                 # Code indexing
│   ├── deploy/                # Deployment configs (virtualenv requirements)
│   ├── fzf/                   # Fuzzy finder
│   ├── macos/                 # macOS-specific (skhd, yabai)
│   ├── nvim/                  # Neovim editor
│   │   ├── lua/
│   │   │   ├── config/        # lazy.nvim setup
│   │   │   ├── mero/          # Personal configs (keymaps, settings, utils)
│   │   │   ├── plugins/       # Plugin configurations
│   │   │   └── snippets/      # Code snippets
│   │   └── after/plugin/      # Plugin-specific configs
│   ├── obsidian/              # Obsidian note-taking app
│   ├── tmux/                  # Terminal multiplexer
│   ├── zsh/                   # Shell configuration
│   ├── editorconfig           # EditorConfig standard
│   └── sqlfluff               # SQL formatter
├── deploy/                     # Python deployment module
│   ├── color_print.py         # Colorized terminal output
│   ├── config.py              # Configuration reader
│   └── utils.py               # File/symlink utilities
├── deploy.py                   # Main installation script
└── zsh-z.plugin.zsh           # Directory navigation plugin
```

## Customization

### Neovim

- Plugin configurations: `configs/nvim/lua/plugins/`
- Keymaps: `configs/nvim/lua/mero/remap.lua`
- Settings: `configs/nvim/lua/mero/set.lua`
- LSP configurations: `configs/nvim/after/plugin/lsp.lua`

### Zsh

- Main config: `configs/zsh/zshrc`
- Aliases: `configs/zsh/bash_aliases`
- Theme: `configs/zsh/p10k.zsh`

### tmux

- Config: `configs/tmux/tmux.conf`
- Prefix key: Check config file for current binding

### Alacritty

- Config: `configs/alacritty/alacritty.toml`
- Font, colors, and window settings

## Backup Strategy

The deployment script automatically backs up existing configuration files before creating symlinks:
- Backups are saved with timestamp suffix (e.g., `.zshrc.backup.1234567890`)
- Broken symlinks are automatically removed
- Original files are preserved

## Uninstalling

To remove symlinks and restore backups:

```bash
# Manually remove symlinks
rm ~/.zshrc ~/.bash_aliases ~/.p10k.zsh ~/.fzf.zsh
rm -rf ~/.config/nvim ~/.config/alacritty ~/.config/tmux

# Restore backups (find them with timestamp suffix)
# Example:
# mv ~/.zshrc.backup.1234567890 ~/.zshrc
```

## Updating

```bash
cd ~/dotfiles
git pull origin main
./deploy.py  # Re-run to update symlinks if needed
```

## Notes

- The deployment script must be run from the repository root directory
- Existing configurations will be backed up automatically
- Some Homebrew packages may take time to install
- After installation, restart your terminal for all changes to take effect

## Troubleshooting

### Neovim plugins not loading
```bash
# Open Neovim and run
:Lazy sync
```

### Zsh plugins not working
- Ensure Oh My Zsh is installed
- Check that plugins are enabled in `configs/zsh/zshrc`
- Restart terminal after changes

### tmux config not applied
```bash
# Reload tmux config
tmux source-file ~/.config/tmux/tmux.conf
```

## License

Personal use only.
