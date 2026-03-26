#!/usr/bin/env python3
"""Tests for check.py — dotfiles health check script."""

import subprocess
import sys
import unittest
from io import StringIO
from pathlib import Path
from unittest.mock import MagicMock, patch, call

# Ensure repo root is on the path so we can import check
sys.path.insert(0, str(Path(__file__).resolve().parent))

import check


class TestExpectedSymlinks(unittest.TestCase):
    """EXPECTED_SYMLINKS must cover all configs deployed by deploy.py."""

    def test_expected_symlinks_is_nonempty_dict(self):
        self.assertIsInstance(check.EXPECTED_SYMLINKS, dict)
        self.assertTrue(len(check.EXPECTED_SYMLINKS) > 0)

    def test_all_sources_are_relative_to_configs(self):
        for target, source in check.EXPECTED_SYMLINKS.items():
            self.assertTrue(
                source.startswith("configs/"),
                f"Source {source} should start with 'configs/'",
            )

    def test_all_targets_start_with_tilde(self):
        for target in check.EXPECTED_SYMLINKS:
            self.assertTrue(
                target.startswith("~"),
                f"Target {target} should start with '~'",
            )


class TestCheckSymlinks(unittest.TestCase):
    """check_symlinks() verifies expected symlinks exist and resolve."""

    @patch("check.Path")
    def test_all_symlinks_valid_returns_pass(self, mock_path_cls):
        mock_target = MagicMock()
        mock_target.is_symlink.return_value = True
        mock_target.resolve.return_value = Path("/resolved")
        mock_target.exists.return_value = True
        mock_path_cls.return_value.expanduser.return_value = mock_target

        passed, messages = check.check_symlinks()

        self.assertTrue(passed)
        self.assertEqual(len(messages["errors"]), 0)

    @patch("check.Path")
    def test_missing_symlink_returns_fail(self, mock_path_cls):
        mock_target = MagicMock()
        mock_target.is_symlink.return_value = False
        mock_target.exists.return_value = False
        mock_path_cls.return_value.expanduser.return_value = mock_target

        passed, messages = check.check_symlinks()

        self.assertFalse(passed)
        self.assertTrue(len(messages["errors"]) > 0)

    @patch("check.Path")
    def test_broken_symlink_returns_fail(self, mock_path_cls):
        mock_target = MagicMock()
        mock_target.is_symlink.return_value = True
        mock_target.exists.return_value = False
        mock_path_cls.return_value.expanduser.return_value = mock_target

        passed, messages = check.check_symlinks()

        self.assertFalse(passed)
        self.assertTrue(len(messages["errors"]) > 0)


class TestCheckZsh(unittest.TestCase):
    """check_zsh() runs zsh -n on config files."""

    @patch("check.shutil.which", return_value="/bin/zsh")
    @patch("check.subprocess.run")
    def test_valid_zsh_config_returns_pass(self, mock_run, _mock_which):
        mock_run.return_value = MagicMock(returncode=0, stderr="", stdout="")

        passed, messages = check.check_zsh()

        self.assertTrue(passed)
        self.assertEqual(len(messages["errors"]), 0)

    @patch("check.shutil.which", return_value="/bin/zsh")
    @patch("check.subprocess.run")
    def test_syntax_error_returns_fail(self, mock_run, _mock_which):
        mock_run.return_value = MagicMock(
            returncode=1, stderr="syntax error near unexpected token", stdout=""
        )

        passed, messages = check.check_zsh()

        self.assertFalse(passed)
        self.assertTrue(len(messages["errors"]) > 0)

    @patch("check.shutil.which", return_value=None)
    def test_zsh_not_installed_returns_warning(self, _mock_which):
        passed, messages = check.check_zsh()

        self.assertTrue(passed)
        self.assertTrue(len(messages["warnings"]) > 0)


class TestCheckTmux(unittest.TestCase):
    """check_tmux() validates tmux config by starting and killing server."""

    @patch("check.shutil.which", return_value="/usr/local/bin/tmux")
    @patch("check.subprocess.run")
    def test_valid_tmux_config_returns_pass(self, mock_run, _mock_which):
        mock_run.return_value = MagicMock(returncode=0, stderr="", stdout="")

        passed, messages = check.check_tmux()

        self.assertTrue(passed)
        self.assertEqual(len(messages["errors"]), 0)

    @patch("check.shutil.which", return_value="/usr/local/bin/tmux")
    @patch("check.subprocess.run")
    def test_invalid_config_returns_fail(self, mock_run, _mock_which):
        mock_run.return_value = MagicMock(
            returncode=1,
            stderr="unknown option: bad-option",
            stdout="",
        )

        passed, messages = check.check_tmux()

        self.assertFalse(passed)
        self.assertTrue(len(messages["errors"]) > 0)

    @patch("check.shutil.which", return_value=None)
    def test_tmux_not_installed_returns_warning(self, _mock_which):
        passed, messages = check.check_tmux()

        self.assertTrue(passed)
        self.assertTrue(len(messages["warnings"]) > 0)


class TestCheckNvim(unittest.TestCase):
    """check_nvim() runs nvim --headless checkhealth and parses output."""

    @patch("check.shutil.which", return_value="/usr/local/bin/nvim")
    @patch("check.subprocess.run")
    def test_clean_checkhealth_returns_pass(self, mock_run, _mock_which):
        mock_run.return_value = MagicMock(
            returncode=0,
            stdout="OK: everything is fine\n",
            stderr="",
        )

        passed, messages = check.check_nvim()

        self.assertTrue(passed)
        self.assertEqual(len(messages["errors"]), 0)

    @patch("check.shutil.which", return_value="/usr/local/bin/nvim")
    @patch("check.subprocess.run")
    def test_checkhealth_with_errors_returns_fail(self, mock_run, _mock_which):
        mock_run.return_value = MagicMock(
            returncode=0,
            stdout="ERROR: python provider not found\n",
            stderr="",
        )

        passed, messages = check.check_nvim()

        self.assertFalse(passed)
        self.assertTrue(len(messages["errors"]) > 0)

    @patch("check.shutil.which", return_value="/usr/local/bin/nvim")
    @patch("check.subprocess.run")
    def test_checkhealth_with_warnings_returns_warnings(self, mock_run, _mock_which):
        mock_run.return_value = MagicMock(
            returncode=0,
            stdout="WARNING: node provider not found\nWARN: something else\n",
            stderr="",
        )

        passed, messages = check.check_nvim()

        self.assertTrue(passed)
        self.assertTrue(len(messages["warnings"]) > 0)

    @patch("check.shutil.which", return_value=None)
    def test_nvim_not_installed_returns_warning(self, _mock_which):
        passed, messages = check.check_nvim()

        self.assertTrue(passed)
        self.assertTrue(len(messages["warnings"]) > 0)


class TestCheckAlacritty(unittest.TestCase):
    """check_alacritty() validates TOML config with tomllib."""

    @patch(
        "builtins.open",
        unittest.mock.mock_open(read_data=b'[window]\ndecorations = "full"\n'),
    )
    @patch("check.Path")
    def test_valid_toml_returns_pass(self, mock_path_cls):
        mock_path = MagicMock()
        mock_path.expanduser.return_value = mock_path
        mock_path.exists.return_value = True
        mock_path_cls.return_value = mock_path

        passed, messages = check.check_alacritty()

        self.assertTrue(passed)
        self.assertEqual(len(messages["errors"]), 0)

    @patch("check.Path")
    def test_missing_config_returns_warning(self, mock_path_cls):
        mock_path = MagicMock()
        mock_path.expanduser.return_value = mock_path
        mock_path.exists.return_value = False
        mock_path_cls.return_value = mock_path

        passed, messages = check.check_alacritty()

        self.assertTrue(passed)
        self.assertTrue(len(messages["warnings"]) > 0)

    @patch(
        "builtins.open",
        unittest.mock.mock_open(read_data=b"[window\nbroken toml"),
    )
    @patch("check.Path")
    def test_invalid_toml_returns_fail(self, mock_path_cls):
        mock_path = MagicMock()
        mock_path.expanduser.return_value = mock_path
        mock_path.exists.return_value = True
        mock_path_cls.return_value = mock_path

        passed, messages = check.check_alacritty()

        self.assertFalse(passed)
        self.assertTrue(len(messages["errors"]) > 0)


class TestParseArguments(unittest.TestCase):
    """CLI argument parsing."""

    def test_no_args_returns_defaults(self):
        with patch("sys.argv", ["check.py"]):
            args = check.parse_arguments()
        self.assertIsNone(args.only)
        self.assertFalse(args.verbose)

    def test_only_flag_parses_csv(self):
        with patch("sys.argv", ["check.py", "--only", "zsh,tmux"]):
            args = check.parse_arguments()
        self.assertEqual(args.only, "zsh,tmux")

    def test_verbose_flag(self):
        with patch("sys.argv", ["check.py", "--verbose"]):
            args = check.parse_arguments()
        self.assertTrue(args.verbose)


class TestMain(unittest.TestCase):
    """main() orchestrates all checks and exits with correct code."""

    @patch("check.check_alacritty", return_value=(True, {"errors": [], "warnings": [], "info": []}))
    @patch("check.check_nvim", return_value=(True, {"errors": [], "warnings": [], "info": []}))
    @patch("check.check_tmux", return_value=(True, {"errors": [], "warnings": [], "info": []}))
    @patch("check.check_zsh", return_value=(True, {"errors": [], "warnings": [], "info": []}))
    @patch("check.check_symlinks", return_value=(True, {"errors": [], "warnings": [], "info": []}))
    def test_all_pass_exits_zero(self, *_mocks):
        with patch("sys.argv", ["check.py"]):
            with self.assertRaises(SystemExit) as ctx:
                check.main()
        self.assertEqual(ctx.exception.code, 0)

    @patch("check.check_alacritty", return_value=(True, {"errors": [], "warnings": [], "info": []}))
    @patch("check.check_nvim", return_value=(True, {"errors": [], "warnings": [], "info": []}))
    @patch("check.check_tmux", return_value=(True, {"errors": [], "warnings": [], "info": []}))
    @patch("check.check_zsh", return_value=(False, {"errors": ["syntax error"], "warnings": [], "info": []}))
    @patch("check.check_symlinks", return_value=(True, {"errors": [], "warnings": [], "info": []}))
    def test_any_fail_exits_one(self, *_mocks):
        with patch("sys.argv", ["check.py"]):
            with self.assertRaises(SystemExit) as ctx:
                check.main()
        self.assertEqual(ctx.exception.code, 1)

    @patch("check.check_alacritty", return_value=(True, {"errors": [], "warnings": [], "info": []}))
    @patch("check.check_nvim", return_value=(True, {"errors": [], "warnings": [], "info": []}))
    @patch("check.check_tmux", return_value=(True, {"errors": [], "warnings": [], "info": []}))
    @patch("check.check_zsh", return_value=(True, {"errors": [], "warnings": [], "info": []}))
    @patch("check.check_symlinks", return_value=(True, {"errors": [], "warnings": [], "info": []}))
    def test_only_flag_runs_subset(self, mock_sym, mock_zsh, mock_tmux, mock_nvim, mock_alac):
        with patch("sys.argv", ["check.py", "--only", "zsh"]):
            with self.assertRaises(SystemExit):
                check.main()
        mock_zsh.assert_called_once()
        mock_tmux.assert_not_called()
        mock_nvim.assert_not_called()
        mock_alac.assert_not_called()
        # symlinks always run
        mock_sym.assert_called_once()

    @patch("check.check_alacritty", return_value=(True, {"errors": [], "warnings": [], "info": []}))
    @patch("check.check_nvim", return_value=(True, {"errors": [], "warnings": [], "info": []}))
    @patch("check.check_tmux", return_value=(True, {"errors": [], "warnings": [], "info": []}))
    @patch("check.check_zsh", return_value=(True, {"errors": [], "warnings": [], "info": []}))
    @patch("check.check_symlinks", return_value=(True, {"errors": [], "warnings": [], "info": []}))
    def test_invalid_only_component_exits_one(self, *_mocks):
        with patch("sys.argv", ["check.py", "--only", "foobar"]):
            with self.assertRaises(SystemExit) as ctx:
                check.main()
            self.assertEqual(ctx.exception.code, 1)


if __name__ == "__main__":
    unittest.main()
