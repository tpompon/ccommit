---
description: Review the working tree and create a Conventional Commit, blocking on debug code, secrets and conflict markers
allowed-tools: [Bash, Read, Grep, Glob]
---

# Smart Commit - Automated Code Review and Commit

Review the current changes, block on real problems, otherwise commit them with a
Conventional Commit message. Be fast and practical. Never ask the user a
question: if you cannot proceed, print why and stop.

## Process

1. **Check git status**

   - Run `git status --porcelain`
   - If there are no changes: print "No changes to commit" and stop

2. **Get the diff**

   - Staged: `git diff --cached`
   - Unstaged: `git diff`
   - If anything is staged, commit only the staged changes. Otherwise stage everything with `git add -A`.

3. **Determine the commit type** from the diff:

   - `feat:` new feature or functionality
   - `fix:` bug fix
   - `refactor:` code change that neither fixes a bug nor adds a feature
   - `docs:` documentation only
   - `style:` formatting, whitespace, missing semicolons
   - `test:` adding or updating tests
   - `chore:` build process, dependencies, tooling

4. **Quick validation.** Block the commit if you find any of these in the diff:

   - Debugging code: `console.log`, `debugger`, `print(`, `var_dump`, `dd(`, `binding.pry`
   - Hardcoded secrets: passwords, API keys, tokens, private keys in plain text
   - Merge conflict markers: `<<<<<<<`, `=======`, `>>>>>>>`
   - Large blocks of commented-out code
   - Obvious logic errors: missing returns, unreachable code
   - Obvious spelling mistakes in user-facing text

5. **Commit or report**

   **If issues were found**, do not commit. Print:

   ```
   Issues detected:
   - [one line per issue, with file and line]

   Fix these and try again.
   ```

   **If clean:**

   - Stage changes if needed
   - Write the message in Conventional Commits format: `type(scope): description`
     - Include a scope when one is obvious from the changed paths
     - Imperative mood, lowercase, no trailing period
     - Keep the subject under 72 characters
     - Add a short body only when the subject alone would be misleading
   - Commit with `git commit -m "..."`
   - Show the result with `git log -1 --oneline` and print:

   ```
   Committed: [hash] [message]
   ```

## Rules

- Focus only on critical issues. Do not nitpick style.
- If you are unsure whether something is a real issue, mention it but still commit.
- Never add co-authors or trailers to the commit message.
- Never add emojis to the commit message.
- Never push. Never amend or rewrite existing commits.
- Do not modify files other than through `git add` and `git commit`.
