# ccommit

A `/commit` command for Claude Code, and a `ccommit` shell function that runs it
from the terminal.

The command reviews your working tree, refuses to commit if it finds debug
statements, hardcoded secrets or merge-conflict markers, and otherwise writes a
[Conventional Commit](https://www.conventionalcommits.org/) message and commits.
No co-author trailers, no emojis, no push.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/tpompon/ccommit/main/install.sh | bash
```

This puts the command at `~/.claude/commands/commit.md` and adds one line to
your `~/.zshrc` (or `~/.bashrc`) that sources `~/.ccommit.sh`.

## Use

Inside Claude Code:

```
/commit
```

From the terminal, in any git repo:

```sh
ccommit
```

That is the whole function:

```sh
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
```

It runs Claude Code in print mode with the `/commit` command. The command's
`allowed-tools` frontmatter pre-approves `Bash`, `Read`, `Grep` and `Glob`, so
there are no permission prompts.

## What the command does

1. Runs `git status`. Stops if the tree is clean.
2. Reads the diff. If anything is staged it commits only that, otherwise it stages everything.
3. Picks the Conventional Commit type (`feat`, `fix`, `refactor`, `docs`, `style`, `test`, `chore`) and a scope when obvious.
4. Blocks on debug code, secrets, conflict markers, large commented-out blocks and obvious logic errors, and tells you what to fix.
5. Otherwise commits with a subject under 72 characters and prints the result.

The full prompt is [`commit.md`](commit.md). Edit it and re-run the installer,
or edit `~/.claude/commands/commit.md` directly.

## Uninstall

```sh
curl -fsSL https://raw.githubusercontent.com/tpompon/ccommit/main/install.sh | bash -s -- --uninstall
```

## License

MIT
