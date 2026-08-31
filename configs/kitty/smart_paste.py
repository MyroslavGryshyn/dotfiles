"""Route Cmd+V to the right paste behavior depending on what's running.

kitty.conf wires Cmd+V to a raw Ctrl+V byte (0x16) so Claude Code CLI's
image-clipboard paste (hooked to literal Ctrl+V, not kitty's own
paste_from_clipboard action) sees it -- see the comment in kitty.conf for
why. But that raw byte is *also* Ctrl+V's normal meaning everywhere else:
zsh's `edit-command-line` widget and vim/nvim's built-in "insert next char
literally" binding both live on Ctrl+V too, so sending it unconditionally
pops the wrong thing open (zsh -> vim) or garbles a real paste (vim insert
mode showing ^V^V^V... instead of the clipboard text).

So: only send the raw byte when Claude Code is actually what's running in
the foreground -- directly, or one level down inside a tmux pane, since
kitty's own foreground-process view stops at the tmux client and can't see
into panes. Everywhere else, fall back to kitty's normal clipboard paste.
"""
import os
import subprocess
from typing import Optional, Sequence

from kitty.boss import Boss
from kittens.tui.handler import result_handler

# kitty is normally launched via Launch Services (Dock/Spotlight), not from a
# login shell, so its own PATH is just the bare-bones
# "/usr/bin:/bin:/usr/sbin:/sbin" -- no Homebrew. `tmux` lives under one of
# these on disk but not on that PATH, so every subprocess call below needs
# it added explicitly or `tmux` silently fails to launch (FileNotFoundError,
# swallowed by the try/except) and this whole check quietly always says "no".
_SUBPROCESS_ENV = dict(os.environ)
_SUBPROCESS_ENV["PATH"] = (
    "/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:"
    + _SUBPROCESS_ENV.get("PATH", "")
)


def main(args: list) -> str:
    pass


def _basename(cmdline: Optional[Sequence[str]]) -> str:
    return os.path.basename(cmdline[0]) if cmdline else ""


def _tmux_pane_is_claude(client_pid: int) -> bool:
    """Best-effort: is the given tmux client's active pane running claude?

    Deliberately doesn't use tmux's own `#{pane_current_command}` -- Claude
    Code renames its own process at the OS level in a way tmux's process-name
    lookup picks up (it shows the CLI's version string, e.g. "2.1.251",
    there) but plain `ps`/kitty's own foreground-process view doesn't, so
    that variable can't be trusted here. Instead this walks the real process
    tree (by pid/ppid from `ps`, same source kitty itself uses) rooted at
    the pane's leader process, looking for a `claude` descendant.
    """
    try:
        clients = subprocess.run(
            ["tmux", "list-clients", "-F", "#{client_pid} #{pane_tty}"],
            capture_output=True, text=True, timeout=1, env=_SUBPROCESS_ENV,
        ).stdout
        pane_tty = None
        for line in clients.splitlines():
            pid_str, _, tty = line.partition(" ")
            if pid_str.isdigit() and int(pid_str) == client_pid:
                pane_tty = tty
                break
        if pane_tty is None:
            return False

        panes = subprocess.run(
            ["tmux", "list-panes", "-a", "-F", "#{pane_tty} #{pane_pid}"],
            capture_output=True, text=True, timeout=1, env=_SUBPROCESS_ENV,
        ).stdout
        pane_leader_pid = None
        for line in panes.splitlines():
            tty, _, pid_str = line.partition(" ")
            if tty == pane_tty and pid_str.isdigit():
                pane_leader_pid = int(pid_str)
                break
        if pane_leader_pid is None:
            return False

        ps_out = subprocess.run(
            ["ps", "-eo", "pid=,ppid=,comm="],
            capture_output=True, text=True, timeout=1, env=_SUBPROCESS_ENV,
        ).stdout
    except Exception:
        return False

    children: dict = {}
    comms: dict = {}
    for line in ps_out.splitlines():
        parts = line.split(None, 2)
        if len(parts) < 3:
            continue
        pid_str, ppid_str, comm = parts
        if not (pid_str.isdigit() and ppid_str.isdigit()):
            continue
        pid, ppid = int(pid_str), int(ppid_str)
        children.setdefault(ppid, []).append(pid)
        comms[pid] = comm

    stack = [pane_leader_pid]
    seen: set = set()
    while stack:
        pid = stack.pop()
        if pid in seen:
            continue
        seen.add(pid)
        if os.path.basename(comms.get(pid, "")) == "claude":
            return True
        stack.extend(children.get(pid, ()))
    return False


def _is_claude(procs: list) -> bool:
    for p in procs:
        name = _basename(p.get("cmdline"))
        if name == "claude":
            return True
        if name == "tmux" and _tmux_pane_is_claude(p["pid"]):
            return True
    return False


@result_handler(no_ui=True)
def handle_result(args: list, answer: str, target_window_id: int, boss: Boss) -> None:
    w = boss.window_id_map.get(target_window_id)
    if w is None:
        return
    if _is_claude(w.child.foreground_processes):
        w.write_to_child(b"\x16")
    else:
        boss.paste_from_clipboard()
