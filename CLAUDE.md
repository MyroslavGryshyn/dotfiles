# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal macOS dotfiles: `configs/` holds the actual config sources (nvim, tmux, kitty, zsh, fzf, etc.), and two Python entry points at the root manage them — `deploy.py` (install tools + symlink configs into place) and `check.py` (validate that everything is correctly installed/symlinked). **`configs/` is the source of truth**; the deployed paths (`~/.config/nvim`, `~/.zshrc`, ...) are symlinks into it, so always edit under `configs/`, never the symlink target.

## Commands

```bash
# Full install + symlink everything
./deploy.py

# Only re-symlink configs, skip brew/package installs
./deploy.py --skip-install

# Scope to one or more components: nvim, kitty, tmux, zsh
./deploy.py --only nvim,tmux

# Preview without changing anything
./deploy.py --dry-run

# Validate configs/symlinks/tools are actually in place (same --only components)
./check.py
./check.py --only tmux --verbose

# Run check.py's test suite
python3 -m unittest test_check -v

# Reload tmux config in a live session
tmux source-file ~/.config/tmux/tmux.conf

# Sync/install nvim plugins (inside nvim)
:Lazy sync
```

There's no test suite for `deploy.py` itself, only for `check.py` (`test_check.py`).

## Architecture

**`deploy.py` and `check.py` are two independent scripts that must be kept in sync by hand.** `deploy.py`'s `setup_*()` functions call `create_symlink(source, target)` for each config file; `check.py`'s `EXPECTED_SYMLINKS` dict lists the same target→source pairs so it can verify them independently. Required CLI tools are similarly duplicated across `deploy.py`'s `install_*_apps()` functions and `check.py`'s `REQUIRED_TOOLS`. Adding a new symlinked config or dependency means updating both files.

Both scripts share the small `deploy/` package: `deploy/config.py` exposes `BASE_DIR` (repo root) and `CONFIG` (parsed `configs/deploy/config.ini`); `deploy/utils.py`'s `create_symlink()` handles the backup-then-link dance (existing files get renamed to a timestamped `.bak`, broken symlinks are removed first); `deploy/color_print.py` is just ANSI-colored `print()` wrappers used for all CLI output in both scripts.

**tmux plugin install is non-interactive-hostile.** tmux.conf bootstraps TPM via `run -b '.../tpm/tpm'`, but that line only fires inside a real, fully-processed tmux session — a bare `tmux start-server` (all `deploy.py` can do non-interactively) never triggers it. `install_tmux_plugins()` in `deploy.py` works around this by spinning up a short-lived detached session on a private socket (`-L dotfiles-deploy`) to force tmux.conf to load for real, then invokes TPM's own installer script directly against that session's `TMUX` env var. See that function's docstring for the full reasoning before touching it.

**Never run `tmux kill-server` (or `pkill`/`killall tmux`) against the default socket while testing.** Claude Code itself is very likely running inside the user's live tmux session on that same socket — killing it kills the CLI's own hosting session, not just the test session. Use an isolated socket for any throwaway tmux testing: `tmux -L <name> new-session ...` / `tmux -L <name> kill-server`.

### Neovim (`configs/nvim/`)

`init.lua` just does `require("config.lazy")` (bootstraps lazy.nvim, then loads plugin specs from `lua/plugins/*.lua`) followed by `require("mero")` (personal keymaps/settings/utils, independent of plugins).

- `lua/plugins/install.lua` — most plugin specs.
- `lua/plugins/coc.lua` — coc.nvim keymaps and, critically, `g.coc_global_extensions`: the declarative list of coc extensions to auto-install. **`coc-settings.json` and `coc_global_extensions` are two separate, easy-to-desync things** — a setting can exist in `coc-settings.json` for an extension (e.g. `python.pythonPath` is a coc-pyright setting) that was never added to `coc_global_extensions`, and it will silently do nothing rather than error. If an LSP feature (`gd`, hover, diagnostics) doesn't work for a filetype, check both files, not just one.
- `after/plugin/*.lua` — runtime config that must run once a plugin is fully loaded, kept separate from the plugin's own `config = function() ... end` in its spec (e.g. `treesitter.lua`, `harpoon.lua`, `lualine.lua`).
- `nvim-treesitter` tracks the `main` branch (not `master`, which is now frozen/legacy). `main` dropped the old `nvim-treesitter.configs` module entirely — parser install, highlighting, folding, and indent are all wired through core `vim.treesitter.*` APIs instead (see `after/plugin/treesitter.lua` and the `foldexpr` in `lua/mero/set.lua`). Building parsers requires the actual `tree-sitter` CLI (`brew install tree-sitter-cli` — Homebrew's `tree-sitter` formula only ships the library now, not the binary).
- `configs/nvim/lazy-lock.json` pins exact plugin commits. Version bumps that come along for the ride from an unrelated `:Lazy sync` belong in their own commit, separate from whatever you were actually changing.

## Git workflow

Commits in this repo are kept atomic and use conventional-commit-style prefixes (`fix(nvim): ...`, `feat(tmux): ...`, `chore(nvim): ...`). When a change touches multiple unrelated things (e.g. a real fix plus incidental lockfile bumps from `:Lazy sync`), split them into separate commits rather than bundling them. Branch off `main` before committing; don't commit straight to `main`.
