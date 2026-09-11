#!/usr/bin/env bash
# ccommit installer
#
#   curl -fsSL https://raw.githubusercontent.com/tpompon/ccommit/main/install.sh | bash
#
# Installs the /commit command for Claude Code and adds the `ccommit` shell
# function to your ~/.zshrc (or ~/.bashrc). Pass --uninstall to remove both.

set -euo pipefail

RAW_URL="https://raw.githubusercontent.com/tpompon/ccommit/main"
COMMAND_FILE="$HOME/.claude/commands/commit.md"
FUNC_FILE="$HOME/.ccommit.sh"
SOURCE_LINE='[ -f ~/.ccommit.sh ] && . ~/.ccommit.sh # ccommit'

case "$(basename "${SHELL:-}")" in
  zsh) RC="${ZDOTDIR:-$HOME}/.zshrc" ;;
  *)   RC="$HOME/.bashrc" ;;
esac

if [ "${1:-}" = "--uninstall" ]; then
  rm -f "$COMMAND_FILE" "$FUNC_FILE"
  if [ -f "$RC" ] && grep -q '# ccommit$' "$RC"; then
    grep -v '# ccommit$' "$RC" > "$RC.tmp" && mv "$RC.tmp" "$RC"
  fi
  echo "ccommit removed."
  exit 0
fi

# Use the local checkout when run from one, otherwise download.
here="$(cd "$(dirname "${BASH_SOURCE[0]:-/dev/null}")" 2>/dev/null && pwd || true)"
mkdir -p "$(dirname "$COMMAND_FILE")"
if [ -n "$here" ] && [ -f "$here/commit.md" ] && [ -f "$here/ccommit.sh" ]; then
  cp "$here/commit.md" "$COMMAND_FILE"
  cp "$here/ccommit.sh" "$FUNC_FILE"
else
  curl -fsSL "$RAW_URL/commit.md" -o "$COMMAND_FILE"
  curl -fsSL "$RAW_URL/ccommit.sh" -o "$FUNC_FILE"
fi
echo "  /commit  -> $COMMAND_FILE"
echo "  ccommit  -> $FUNC_FILE"

if [ -f "$RC" ] && grep -q '# ccommit$' "$RC"; then
  echo "  $RC already sources it"
else
  printf '\n%s\n' "$SOURCE_LINE" >> "$RC"
  echo "  added to $RC"
fi

echo
echo "Done. Open a new shell (or run: source $RC), then type 'ccommit' in any git repo."
