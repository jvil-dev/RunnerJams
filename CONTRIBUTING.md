# Contributing to RunnerJams

Pull requests merge into `main`. GitHub Issues is the tracker. A leaf issue may take several
pull requests, each on its own branch, and each pull request belongs to one leaf issue.

Work runs in one-week cycles, Monday to Sunday. Each cycle is a milestone whose description is
that week's goal; the [project board](https://github.com/users/jvil-dev/projects/9) shows what
is in it.

## Before starting

1. Read the issue: context, goals, non-goals, acceptance criteria. Or confirm the fast path.
2. Read `AGENTS.md` for the architecture and the rules that apply to this repository.
3. Surface conflicts before changing behavior. Propose dependency changes and wait.

## Branches and pull requests

Branch `<type>/<n>-<slug>` from `main`, where `n` is the issue number; fast path
`<type>/<slug>`. Types `feat`, `fix`, `chore`, `refactor`.

Open a **draft pull request after the first commit**, with the description written then: what
and why, and the acceptance criteria it covers unchecked. Push after every commit so CI runs on
the draft. Mark it ready for review only when every criterion it covers is checked. Merge with a
merge commit and delete the branch.

Under 400 reviewable lines and 10 files; over that, split the pull request, not the issue, or
justify it in one line.

## Commits

One task, one commit, under about 150 changed lines, made only after the check passes.
`<type>(<scope>): <imperative summary>` under 72 characters, with a body that says what and
why. Tests ship with the code they cover. Stage only relevant files. Commits are signed.

## Verification

```bash
scripts/check.sh
```

When a change touches the app target, also build it:

```bash
xcodebuild -project RunnerJams/RunnerJams.xcodeproj -scheme RunnerJams -destination 'generic/platform=iOS Simulator' build
```

`CI Gate` must pass before merge. Never bypass it.

Never push secrets or environment contents.
