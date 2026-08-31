# CLAUDE.md

Global instructions for Claude Code, loaded in every project regardless of
which repo you're in. A repo's own `CLAUDE.md` (project-specific) adds to
this, it doesn't replace it.

## Git

- Keep commits atomic: one logical change per commit. If a change bundles
  something unrelated (e.g. an incidental lockfile bump alongside a real
  fix), split it into its own commit rather than mixing it in.
- Use conventional-commit-style prefixes (`fix:`, `feat:`, `chore:`,
  `docs:`), with a scope when it helps (`fix(nvim): ...`).
