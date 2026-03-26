#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse
import logging
import os
import shutil
import sys

from pathlib import Path
from subprocess import run, CalledProcessError, PIPE

from deploy.color_print import ColorPrint
from deploy.config import CONFIG
from deploy.utils import create_symlink

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('deploy.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)


class InstallationTracker:
    """Track successful and failed installations."""
    def __init__(self):
        self.successful = []
        self.failed = []
        self.skipped = []

    def add_success(self, package_name):
        self.successful.append(package_name)

    def add_failure(self, package_name, error):
        self.failed.append((package_name, str(error)))

    def add_skipped(self, package_name):
        self.skipped.append(package_name)

    def print_summary(self):
        """Print installation summary."""
        ColorPrint.bold("\n=== Installation Summary ===")

        if self.successful:
            ColorPrint.green(f"\nSuccessfully installed ({len(self.successful)}):")
            for pkg in self.successful:
                ColorPrint.green(f"  ✓ {pkg}")

        if self.skipped:
            ColorPrint.yellow(f"\nSkipped ({len(self.skipped)}):")
            for pkg in self.skipped:
                ColorPrint.yellow(f"  - {pkg}")

        if self.failed:
            ColorPrint.red(f"\nFailed ({len(self.failed)}):")
            for pkg, error in self.failed:
                ColorPrint.red(f"  ✗ {pkg}: {error}")
            return False
        return True


tracker = InstallationTracker()


def command_exists(command):
    """Check if a command exists in PATH."""
    return shutil.which(command) is not None


def brew_package_installed(package_name):
    """Check if a brew package is installed."""
    if not command_exists("brew"):
        return False
    try:
        result = run(["brew", "list", package_name], capture_output=True, text=True)
        return result.returncode == 0
    except Exception:
        return False


def git_repo_exists(path):
    """Check if a git repository exists at the given path."""
    return Path(path).expanduser().is_dir()


def install_package(package_name, brew_args=None, display_name=None,
                   check_command=None, force=False):
    """
    Generic package installer using brew.

    Args:
        package_name: Name of the package to install
        brew_args: List of brew arguments (default: ["install", package_name])
        display_name: Display name for messages (default: package_name)
        check_command: Command to check if already installed (default: package_name)
        force: Force installation even if package exists
    """
    display_name = display_name or package_name
    brew_args = brew_args or ["install", package_name]
    check_command = check_command or package_name

    # Check if already installed
    if not force:
        if brew_package_installed(package_name):
            ColorPrint.yellow(f"{display_name} is already installed (skipping)")
            tracker.add_skipped(display_name)
            return True

    try:
        ColorPrint.blue(f"Installing {display_name}...")
        run(["brew"] + brew_args, check=True)
        ColorPrint.green(f"{display_name} has been successfully installed")
        tracker.add_success(display_name)
        logger.info(f"Successfully installed {display_name}")
        return True
    except CalledProcessError as e:
        error_msg = f"Failed to install {display_name}"
        ColorPrint.red(error_msg)
        tracker.add_failure(display_name, e)
        logger.error(f"{error_msg}: {e}")
        return False


def install_git_repo(repo_url, target_path, display_name, force=False):
    """
    Clone a git repository.

    Args:
        repo_url: URL of the git repository
        target_path: Path where to clone the repository
        display_name: Display name for messages
        force: Force clone even if directory exists
    """
    expanded_path = os.path.expanduser(target_path)

    # Check if already cloned
    if not force and git_repo_exists(expanded_path):
        ColorPrint.yellow(f"{display_name} is already cloned (skipping)")
        tracker.add_skipped(display_name)
        return True

    try:
        ColorPrint.blue(f"Cloning {display_name}...")
        run(["git", "clone", repo_url, expanded_path], check=True)
        ColorPrint.green(f"{display_name} has been successfully cloned")
        tracker.add_success(display_name)
        logger.info(f"Successfully cloned {display_name}")
        return True
    except CalledProcessError as e:
        error_msg = f"Failed to clone {display_name}"
        ColorPrint.red(error_msg)
        tracker.add_failure(display_name, e)
        logger.error(f"{error_msg}: {e}")
        return False


def install_brew(force=False):
    """Install Homebrew package manager."""
    if not force and command_exists("brew"):
        ColorPrint.yellow("Homebrew is already installed (skipping)")
        tracker.add_skipped("Homebrew")
        return True

    try:
        ColorPrint.blue("Installing Homebrew...")
        run([
            "/bin/bash", "-c",
            "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        ], check=True)
        ColorPrint.green("Homebrew has been successfully installed")
        tracker.add_success("Homebrew")
        logger.info("Successfully installed Homebrew")
        return True
    except CalledProcessError as e:
        error_msg = "Failed to install Homebrew"
        ColorPrint.red(error_msg)
        tracker.add_failure("Homebrew", e)
        logger.error(f"{error_msg}: {e}")
        return False


def install_zsh_plugins(force=False):
    """Install zsh plugins."""
    success = True

    success &= install_package(
        "zsh-syntax-highlighting",
        display_name="zsh-syntax-highlighting",
        force=force
    )

    success &= install_package(
        "zsh-autosuggestions",
        display_name="zsh-autosuggestions",
        force=force
    )

    success &= install_git_repo(
        "https://github.com/loiccoyle/zsh-github-copilot",
        "~/.oh-my-zsh/custom/plugins/zsh-github-copilot",
        "zsh-github-copilot",
        force=force
    )

    success &= install_package(
        "powerlevel10k",
        display_name="powerlevel10k",
        force=force
    )

    return success


def install_apps(force=False):
    """Install all applications."""
    ColorPrint.bold("\n=== Installing Applications ===\n")

    install_brew(force)
    install_package("neovim", display_name="Neovim", force=force)
    install_package("tmux", display_name="Tmux", force=force)
    install_package(
        "font-jetbrains-mono-nerd-font",
        brew_args=["install", "--cask", "font-jetbrains-mono-nerd-font"],
        display_name="JetBrains Mono Nerd Font",
        force=force
    )
    install_package("node", display_name="Node.js", force=force)
    install_zsh_plugins(force)
    install_package("pyenv", display_name="pyenv", force=force)
    install_package("fzf", display_name="fzf", force=force)
    install_package("thefuck", display_name="thefuck", force=force)


def setup_neovim():
    """Set up Neovim configuration and virtual environment."""
    ColorPrint.bold("\n=== Setting up Neovim ===\n")

    # Set up virtual environment
    virtualenv_dir = Path(CONFIG["Paths"]["VIRTUALENV_DIR"]).expanduser()
    virtualenv_dir.parent.mkdir(parents=True, exist_ok=True)

    if not Path(virtualenv_dir).exists():
        try:
            ColorPrint.blue("Creating Python virtual environment for Neovim...")
            run(["python3", "-m", "venv", str(virtualenv_dir)], check=True)
            ColorPrint.blue("Installing Python packages...")
            run(
                [
                    str(Path(virtualenv_dir, "bin", "pip")),
                    "install",
                    "-r",
                    "./configs/deploy/requirements.txt",
                ],
                check=True,
            )
            ColorPrint.green("Neovim virtual environment created successfully")
            tracker.add_success("Neovim venv")
        except CalledProcessError as e:
            error_msg = "Failed to create Neovim virtual environment"
            ColorPrint.red(error_msg)
            tracker.add_failure("Neovim venv", e)
            logger.error(f"{error_msg}: {e}")
    else:
        ColorPrint.yellow("Neovim virtual environment already exists (skipping)")
        tracker.add_skipped("Neovim venv")

    # Set up nvim related config files
    create_symlink("configs/nvim/init.lua", "~/.config/nvim/init.lua")
    create_symlink("configs/nvim/lua", "~/.config/nvim/lua")
    create_symlink("configs/nvim/after", "~/.config/nvim/after")
    create_symlink("configs/editorconfig", "~/.editorconfig")
    create_symlink("configs/nvim/coc-settings.json", "~/.config/nvim/coc-settings.json")
    create_symlink("configs/nvim/lazy-lock.json", "~/.config/nvim/lazy-lock.json")


def setup_alacritty():
    """Set up Alacritty terminal configuration."""
    ColorPrint.bold("\n=== Setting up Alacritty ===\n")
    create_symlink("configs/alacritty/alacritty.toml", "~/.config/alacritty/alacritty.toml")


def setup_tmux():
    """Set up Tmux configuration."""
    ColorPrint.bold("\n=== Setting up Tmux ===\n")
    create_symlink("configs/tmux/tmux.conf", "~/.config/tmux/tmux.conf")


def setup_zsh():
    """Set up Zsh configuration and plugins."""
    ColorPrint.bold("\n=== Setting up Zsh ===\n")
    create_symlink("configs/zsh/zshrc", "~/.zshrc")
    create_symlink("configs/zsh/bash_aliases", "~/.bash_aliases")
    create_symlink("configs/fzf/fzf.zsh", "~/.fzf.zsh")
    # Link for oh-my-zsh theme config
    create_symlink("configs/zsh/p10k.zsh", "~/.p10k.zsh")
    # Link z plugin
    create_symlink("configs/zsh/plugins/zsh-z.plugin.zsh", "~/.zsh-z.plugin.zsh")


def parse_arguments():
    """Parse command-line arguments."""
    parser = argparse.ArgumentParser(
        description="Deploy dotfiles and install development tools",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s                          # Full installation and setup
  %(prog)s --skip-install           # Only create symlinks, skip installations
  %(prog)s --only nvim              # Only set up Neovim
  %(prog)s --only tmux,zsh          # Only set up Tmux and Zsh
  %(prog)s --force                  # Force reinstall even if already installed
        """
    )

    parser.add_argument(
        '--skip-install',
        action='store_true',
        help='Skip package installations, only set up configurations'
    )

    parser.add_argument(
        '--only',
        type=str,
        help='Only set up specific tools (comma-separated: nvim,tmux,zsh,alacritty)'
    )

    parser.add_argument(
        '--force',
        action='store_true',
        help='Force reinstallation even if packages are already installed'
    )

    parser.add_argument(
        '--dry-run',
        action='store_true',
        help='Show what would be done without actually doing it'
    )

    return parser.parse_args()


def main():
    """Main entry point."""
    args = parse_arguments()

    if args.dry_run:
        ColorPrint.yellow("DRY RUN MODE - No changes will be made\n")
        logger.info("Starting dry run")

    # Determine which components to set up
    components = ['nvim', 'alacritty', 'tmux', 'zsh']
    if args.only:
        components = [c.strip() for c in args.only.split(',')]
        invalid = [c for c in components if c not in ['nvim', 'alacritty', 'tmux', 'zsh']]
        if invalid:
            ColorPrint.red(f"Invalid components: {', '.join(invalid)}")
            ColorPrint.yellow("Valid components: nvim, alacritty, tmux, zsh")
            sys.exit(1)

    # Install applications
    if not args.skip_install:
        if not args.dry_run:
            install_apps(force=args.force)
        else:
            ColorPrint.yellow("[DRY RUN] Would install applications")

    # Set up configurations
    setup_functions = {
        'nvim': setup_neovim,
        'alacritty': setup_alacritty,
        'tmux': setup_tmux,
        'zsh': setup_zsh
    }

    for component in components:
        if component in setup_functions:
            if not args.dry_run:
                try:
                    setup_functions[component]()
                except Exception as e:
                    ColorPrint.red(f"Failed to set up {component}: {e}")
                    logger.error(f"Failed to set up {component}: {e}")
            else:
                ColorPrint.yellow(f"[DRY RUN] Would set up {component}")

    # Print summary
    if not args.skip_install and not args.dry_run:
        success = tracker.print_summary()
        sys.exit(0 if success else 1)
    else:
        ColorPrint.bold("\n=== Setup Complete ===\n")


if __name__ == "__main__":
    main()
