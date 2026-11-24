# Issue tracker: GitHub

Issues and specs for this repo live as GitHub issues on `jvil-dev/RunnerJams`. Use the `gh` CLI for all operations. Never create markdown issue files in the repo.

## Conventions

- **Create an issue**: `gh issue create --title "..." --body "..."`. Use a heredoc for multi-line bodies.
- **Read an issue**: `gh issue view <number> --json number,title,body,labels,comments`.
- **List issues**: `gh issue list --state open --json number,title,labels` with `--label` and `--state` filters as needed.
- **Make an issue a sub-issue of a parent**: `gh issue create --parent <parent> ...`, or `gh issue edit <parent> --add-sub-issue <child>` afterwards. Without sub-issues, put `Part of #<parent>` at the top of the child body.
- **Blocking**: GitHub's native issue dependencies. Where they are not available, put a `Blocked by: #<n>` line at the top of the child body.
- **Comment on an issue**: `gh issue comment <number> --body "..."`.
- **Apply or remove labels**: `gh issue edit <number> --add-label "..."` or `--remove-label "..."`. The triage labels are in `docs/agents/triage-labels.md`.
- **Close**: `gh issue close <number> --comment "..."`.

This repository is public. Keep personal details, employer details, and anything from another project out of issues, comments and pull requests.

## When a skill says "publish to the issue tracker"

Create a GitHub issue.

## When a skill says "fetch the relevant ticket"

Read it as in **Read an issue** above.

## Pull requests as a triage surface

**PRs as a request surface: no.** Pull requests are open to collaborators only.
