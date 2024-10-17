#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from pathlib import Path
from subprocess import call

from deploy.config import CONFIG
from deploy.utils import add_line_to_file, create_symlink


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
    create_symlink("configs/tmux/tmux.conf", ".config/tmux/tmux.conf")

def setup_zsh():
    create_symlink("configs/zsh/zshrc", "~/.zshrc")



if __name__ == "__main__":
    setup_neovim()
    setup_alacritty()
    setup_tmux()
    setup_zsh()
