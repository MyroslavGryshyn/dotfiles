#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os

from pathlib import Path
from subprocess import call, run, CalledProcessError

from deploy.config import CONFIG
from deploy.utils import create_symlink


def install_brew():
    try:
        run(["/bin/bash", "-c", "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"], check=True)
        print("Homebrew has been successfully installed.")
    except CalledProcessError as e:
        print(f"An error occurred: {e}")


def install_neovim():
    try:
        run(["brew", "install", "neovim"], check=True)
        print("Neovim has been successfully installed.")
    except CalledProcessError as e:
        print(f"An error occurred: {e}")


def install_tmux():
    try:
        run(["brew", "install", "tmux"], check=True)
        print("Tmux has been successfully installed.")
    except CalledProcessError as e:
        print(f"An error occurred: {e}")


def install_node():
    try:
        run(["brew", "install", "node"], check=True)
        print("Node has been successfully installed.")
    except CalledProcessError as e:
        print(f"An error occurred: {e}")


def install_alacritty_font():
    try:
        run(["brew", "install", "--cask", "font-jetbrains-mono-nerd-font"], check=True)
        print("Alacritty font has been successfully installed.")
    except CalledProcessError as e:
        print(f"An error occurred: {e}")


def install_zsh_plugins():
    try:
        run(["brew", "install", "zsh-syntax-highlighting"], check=True)
        print("zsh-syntax-highlighting has been successfully installed.")
    except CalledProcessError as e:
        print(f"An error occurred: {e}")

    try:
        run(["brew", "install", "zsh-autosuggestions"], check=True)
        print("zsh-syntax-highlighting has been successfully installed.")
    except CalledProcessError as e:
        print(f"An error occurred: {e}")

    try:
        run(
            [
                "git",
                "clone",
                "https://github.com/loiccoyle/zsh-github-copilot",
                os.path.expanduser("~/.oh-my-zsh/custom/plugins/zsh-github-copilot")
            ],
            check=True
        )
        print("zsh-syntax-highlighting has been successfully installed.")
    except CalledProcessError as e:
        print(f"An error occurred: {e}")

    try:
        run(["brew", "install", "powerlevel10k"], check=True)
        print("zsh-syntax-highlighting has been successfully installed.")
    except CalledProcessError as e:
        print(f"An error occurred: {e}")


def install_pyenv():
    try:
        run(["brew", "install", "pyenv"], check=True)
        print("pyenv has been successfully installed.")
    except CalledProcessError as e:
        print(f"An error occurred: {e}")


def install_fzf():
    try:
        run(["brew", "install", "fzf"], check=True)
        print("fzf has been successfully installed.")
    except CalledProcessError as e:
        print(f"An error occurred: {e}")


def install_thefuck():
    try:
        run(["brew", "install", "thefuck"], check=True)
        print("thefuck has been successfully installed.")
    except CalledProcessError as e:
        print(f"An error occurred: {e}")


def install_apps():
    install_brew()
    install_neovim()
    install_tmux()
    install_alacritty_font()
    install_node()
    install_zsh_plugins()
    install_pyenv()
    install_fzf()
    install_thefuck()


def setup_neovim():
    # Set up virtual environment
    virtualenv_dir = Path(CONFIG["Paths"]["VIRTUALENV_DIR"]).expanduser()
    virtualenv_dir.parent.mkdir(parents=True, exist_ok=True)

    if not Path(virtualenv_dir).exists():
        call(["python3", "-m", "venv", virtualenv_dir])
        call(
            [
                Path(virtualenv_dir, "bin", "pip"),
                "install",
                "-r",
                "./configs/deploy/requirements.txt",
            ]
        )

    # Set up nvim related config files
    create_symlink("configs/nvim/init.lua", "~/.config/nvim/init.lua")
    create_symlink("configs/nvim/lua", "~/.config/nvim/lua")
    create_symlink("configs/editorconfig", "~/.editorconfig")


def setup_alacritty():
    create_symlink("configs/alacritty/alacritty.toml", "~/.config/alacritty/alacritty.toml")


def setup_tmux():
    create_symlink("configs/tmux/tmux.conf", "~/.config/tmux/tmux.conf")


def setup_zsh():
    create_symlink("configs/zsh/zshrc", "~/.zshrc")
    create_symlink("configs/zsh/bash_aliases", "~/.bash_aliases")
    create_symlink("configs/fzf/fzf.zsh", "~/.fzf.zsh")
    # Link for oh-my-zsh theme config
    create_symlink("configs/zsh/p10k.zsh", "~/.p10k.zsh")


if __name__ == "__main__":
    install_apps()
    setup_neovim()
    setup_alacritty()
    setup_tmux()
    setup_zsh()
