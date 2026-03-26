#!/usr/bin/env python3
"""Dotfiles health check — validate configs for zsh, tmux, nvim, alacritty."""

import argparse
import shutil
import subprocess
import sys
import tomllib
from pathlib import Path

from deploy.color_print import ColorPrint
from deploy.config import BASE_DIR

# Symlink mappings: target → source (mirrors deploy.py)
EXPECTED_SYMLINKS = {
    "~/.config/nvim/init.lua": "configs/nvim/init.lua",
    "~/.config/nvim/lua": "configs/nvim/lua",
    "~/.config/nvim/after": "configs/nvim/after",
    "~/.editorconfig": "configs/editorconfig",
    "~/.config/nvim/coc-settings.json": "configs/nvim/coc-settings.json",
    "~/.config/nvim/lazy-lock.json": "configs/nvim/lazy-lock.json",
    "~/.config/alacritty/alacritty.toml": "configs/alacritty/alacritty.toml",
    "~/.config/tmux/tmux.conf": "configs/tmux/tmux.conf",
    "~/.zshrc": "configs/zsh/zshrc",
    "~/.bash_aliases": "configs/zsh/bash_aliases",
    "~/.fzf.zsh": "configs/fzf/fzf.zsh",
    "~/.p10k.zsh": "configs/zsh/p10k.zsh",
    "~/.zsh-z.plugin.zsh": "configs/zsh/plugins/zsh-z.plugin.zsh",
}

REQUIRED_TOOLS = ["fzf", "fd", "pyenv", "rbenv", "node", "nvim", "tmux"]

ZSH_PLUGINS = {
    "zsh-syntax-highlighting": "~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting",
    "zsh-autosuggestions": "~/.oh-my-zsh/custom/plugins/zsh-autosuggestions",
    "powerlevel10k": "~/.oh-my-zsh/custom/themes/powerlevel10k",
}

VALID_COMPONENTS = ["zsh", "tmux", "nvim", "alacritty"]


def _make_messages(errors=None, warnings=None, info=None):
    return {
        "errors": errors or [],
        "warnings": warnings or [],
        "info": info or [],
    }


def check_symlinks():
    """Verify all expected symlinks exist, resolve, and point to correct target."""
    errors = []
    warnings = []
    info = []

    for target, source in EXPECTED_SYMLINKS.items():
        path = Path(target).expanduser()
        if path.is_symlink():
            if path.exists():
                resolved = path.resolve()
                expected = (BASE_DIR / source).resolve()
                if resolved != expected:
                    warnings.append(
                        f"  ! {target} → {resolved} (expected {expected})"
                    )
                else:
                    info.append(f"  ✓ {target} → {source}")
            else:
                errors.append(f"  ✗ {target} — broken symlink (target missing)")
        elif path.exists():
            errors.append(f"  ✗ {target} — exists but is not a symlink")
        else:
            errors.append(f"  ✗ {target} — missing")

    passed = len(errors) == 0
    return passed, _make_messages(errors=errors, warnings=warnings, info=info)


def check_zsh():
    """Run zsh -n syntax check on zshrc and bash_aliases."""
    if not shutil.which("zsh"):
        return True, _make_messages(warnings=["zsh not installed, skipping"])

    errors = []
    info = []
    files = [
        ("~/.zshrc", "zshrc"),
        ("~/.bash_aliases", "bash_aliases"),
    ]

    for filepath, label in files:
        expanded = str(Path(filepath).expanduser())
        result = subprocess.run(
            ["zsh", "-n", expanded],
            capture_output=True,
            text=True,
        )
        if result.returncode != 0:
            errors.append(f"  ✗ {label}: {result.stderr.strip()}")
        else:
            info.append(f"  ✓ {label} syntax OK")

    passed = len(errors) == 0
    return passed, _make_messages(errors=errors, info=info)


def check_tmux():
    """Validate tmux config by starting and immediately killing a server."""
    if not shutil.which("tmux"):
        return True, _make_messages(warnings=["tmux not installed, skipping"])

    conf = str(Path("~/.config/tmux/tmux.conf").expanduser())
    result = subprocess.run(
        ["tmux", "-f", conf, "start-server", ";", "kill-server"],
        capture_output=True,
        text=True,
    )

    if result.returncode != 0:
        return False, _make_messages(
            errors=[f"  ✗ tmux.conf: {result.stderr.strip()}"]
        )

    return True, _make_messages(info=["  ✓ tmux.conf valid"])


def check_nvim():
    """Run nvim --headless checkhealth and parse output for errors/warnings."""
    if not shutil.which("nvim"):
        return True, _make_messages(warnings=["nvim not installed, skipping"])

    result = subprocess.run(
        ["nvim", "--headless", "+checkhealth", "+qa"],
        capture_output=True,
        text=True,
        timeout=60,
    )

    errors = []
    warnings = []
    info = []

    for line in result.stdout.splitlines():
        stripped = line.strip()
        if stripped.startswith("ERROR"):
            errors.append(f"  ✗ {stripped}")
        elif stripped.startswith("WARN") or stripped.startswith("WARNING"):
            warnings.append(f"  ! {stripped}")

    if not errors and not warnings:
        info.append("  ✓ checkhealth clean")

    passed = len(errors) == 0
    return passed, _make_messages(errors=errors, warnings=warnings, info=info)


def check_python_venv():
    """Verify the nvim base_venv exists and has pynvim installed."""
    venv_dir = Path("~/.local/share/nvim/base_venv").expanduser()
    errors = []
    info = []

    if not venv_dir.exists():
        errors.append("  ✗ base_venv not found at ~/.local/share/nvim/base_venv")
        return False, _make_messages(errors=errors)

    pip_bin = str(venv_dir / "bin" / "pip")
    result = subprocess.run(
        [pip_bin, "list", "--format=columns"],
        capture_output=True,
        text=True,
    )
    if "pynvim" not in result.stdout:
        errors.append("  ✗ pynvim not installed in base_venv")
    else:
        info.append("  ✓ base_venv exists with pynvim")

    passed = len(errors) == 0
    return passed, _make_messages(errors=errors, info=info)


def check_tools():
    """Verify required CLI tools are available in PATH."""
    warnings = []
    info = []

    for tool in REQUIRED_TOOLS:
        if shutil.which(tool):
            info.append(f"  ✓ {tool}")
        else:
            warnings.append(f"  ! {tool} not found in PATH")

    return True, _make_messages(warnings=warnings, info=info)


def check_zsh_plugins():
    """Verify zsh plugin directories exist."""
    errors = []
    info = []

    for name, path in ZSH_PLUGINS.items():
        expanded = Path(path).expanduser()
        if expanded.is_dir():
            info.append(f"  ✓ {name}")
        else:
            errors.append(f"  ✗ {name} not found at {path}")

    passed = len(errors) == 0
    return passed, _make_messages(errors=errors, info=info)


def check_alacritty():
    """Validate alacritty.toml with tomllib."""
    config_path = Path("~/.config/alacritty/alacritty.toml").expanduser()

    if not config_path.exists():
        return True, _make_messages(
            warnings=["alacritty.toml not found, skipping"]
        )

    try:
        with open(config_path, "rb") as f:
            tomllib.load(f)
        return True, _make_messages(info=["  ✓ alacritty.toml valid TOML"])
    except tomllib.TOMLDecodeError as e:
        return False, _make_messages(errors=[f"  ✗ alacritty.toml: {e}"])


def parse_arguments():
    """Parse command-line arguments."""
    parser = argparse.ArgumentParser(
        description="Validate dotfiles configs",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""\
Examples:
  %(prog)s                    # Check all configs
  %(prog)s --only zsh,tmux    # Check specific tools
  %(prog)s --verbose          # Show full output on errors
        """,
    )
    parser.add_argument(
        "--only",
        type=str,
        help="Only check specific tools (comma-separated: zsh,tmux,nvim,alacritty)",
    )
    parser.add_argument(
        "--verbose",
        action="store_true",
        help="Show full command output",
    )
    return parser.parse_args()


def main():
    """Run all checks, print pass/fail summary, exit 0 or 1."""
    args = parse_arguments()

    components = VALID_COMPONENTS[:]
    if args.only:
        components = [c.strip() for c in args.only.split(",")]
        invalid = [c for c in components if c not in VALID_COMPONENTS]
        if invalid:
            ColorPrint.red(f"Invalid components: {', '.join(invalid)}")
            ColorPrint.yellow(f"Valid components: {', '.join(VALID_COMPONENTS)}")
            sys.exit(1)

    check_functions = {
        "zsh": ("Zsh", check_zsh),
        "tmux": ("Tmux", check_tmux),
        "nvim": ("Neovim", check_nvim),
        "alacritty": ("Alacritty", check_alacritty),
    }

    all_passed = True
    total_errors = 0
    total_warnings = 0

    # Always-run checks
    always_checks = [
        ("Symlinks", check_symlinks),
        ("Python Venv", check_python_venv),
        ("CLI Tools", check_tools),
        ("Zsh Plugins", check_zsh_plugins),
    ]
    for label, fn in always_checks:
        ColorPrint.bold(f"\n=== Checking {label} ===")
        passed, messages = fn()
        _print_messages(messages, args.verbose)
        if not passed:
            all_passed = False
        total_errors += len(messages["errors"])
        total_warnings += len(messages["warnings"])

    # Per-tool checks
    for component in components:
        label, fn = check_functions[component]
        ColorPrint.bold(f"\n=== Checking {label} ===")
        passed, messages = fn()
        _print_messages(messages, args.verbose)
        if not passed:
            all_passed = False
        total_errors += len(messages["errors"])
        total_warnings += len(messages["warnings"])

    # Summary
    ColorPrint.bold("\n=== Health Check Summary ===")
    if all_passed and total_warnings == 0:
        ColorPrint.green("All checks passed!")
    elif all_passed:
        ColorPrint.yellow(f"Passed with {total_warnings} warning(s)")
    else:
        ColorPrint.red(f"{total_errors} error(s), {total_warnings} warning(s)")

    sys.exit(0 if all_passed else 1)


def _print_messages(messages, verbose=False):
    """Print errors, warnings, and info messages."""
    for err in messages["errors"]:
        ColorPrint.red(err)
    for warn in messages["warnings"]:
        ColorPrint.yellow(warn)
    if verbose:
        for info in messages["info"]:
            ColorPrint.green(info)


if __name__ == "__main__":
    main()
