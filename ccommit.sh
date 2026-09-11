# ccommit - run the /commit command with Claude Code from any git repo.
# Sourced from your shell profile by install.sh.

ccommit() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Not a git repository"
    return 1
  fi

  if git diff --quiet && git diff --cached --quiet; then
    echo "Nothing to commit"
    return 0
  fi

  claude -p "/commit"
}
