# Review

How pull requests are reviewed. Read with the root `AGENTS.md`.

## Review lanes and the review record

- **Lanes.** `runnerjams-reviewer` runs on every PR, in task mode between tasks on a multi-task PR
  and once in final mode on the whole PR. `runnerjams-security-reviewer` runs before the final review
  when the PR touches a risk trigger in `AGENTS.md`, or when its issue was named at kickoff as touching
  one. Both cards live in `.claude/agents/`.
- **Where they run.** Marking a PR ready runs `.github/workflows/claude-review.yml`, which runs the lanes
  and submits their review. Locally, Claude runs the same cards and submits the review itself. A PR
  that changes `.claude/agents/` or `.github/workflows/claude*.yml` also gets its lanes run locally,
  because the workflow reviews with the cards the PR itself changes.
- **Tagged Claude.** On a PR, `@claude` answers questions about the diff or re-runs the lane a comment
  names. It commits only when a comment explicitly asks for a change, and it replies and commits as
  `claude[bot]`.
- **Claude comments as itself.** Every review Claude submits, locally or in the workflow, posts as
  `runnerjams-claude[bot]`, a GitHub App that can comment and review but not push. Locally, get its
  token with:

  ```bash
  GH_TOKEN="$(CLAUDE_APP_KEYCHAIN_SERVICE=runnerjams-claude-app ~/.claude/scripts/claude-gh-token.sh jvil-dev/RunnerJams)"
  ```

  The PR body and every other commit stay the developer's.
- **The review record is a PR review.** Each run submits one GitHub review: Approve when every finding
  is P3, Request changes on any P1, Comment otherwise. The latest review is the record. Each run
  dismisses the bot's earlier Approve or Request changes, and so does a push, so the Reviewers sidebar
  never shows a verdict on code no lane has seen. The ruleset requires no approvals, so Request changes
  is a signal for the developer, not a merge block.

## Findings

Each finding is an inline comment on the diff line or lines it is about. A finding about a line outside
the diff goes in the summary. A finding still open in an earlier bot thread keeps that thread: a later
review raises it again with the same first line, and the submit step lists it under "Still open from
earlier reviews" instead of posting it twice. Every field is at most two sentences:

```
**P1: <the finding>**
<who hits it, when in the run, and what they hear or see>
Fix now: Y|N (<whether leaving it adds technical debt>)
```

P1 breaks something or misleads the runner; P2 is a real gap; P3 is polish. Lanes report Conventional
Comments, which map as follows: any `(blocking)` label is P1; a non-blocking `issue`, `suggestion`,
`todo`, `question`, or `chore` is P2; `nitpick`, `note`, and `thought` are P3. `praise` is not a
finding and is not posted.

Every finding is stated as a run scenario: who hits it (a runner before the run, mid-run with the phone
locked, at the end), what they hear or see, and whether it can happen today or only after a later change.

## The summary

The review body holds the reviewed commit SHA and the lanes that ran on one line, one sentence on what
to look at first, and a **Developer checks** list. Findings only, never a summary of the code. Developer
checks are at most three one-line items from this list that the PR makes live, each naming the file or
behavior to open:

- **Scope:** the diff does only what the approved criteria say.
- **Real device:** playback, background audio, or MusicKit changes were run on a real device, because
  they don't work in the Simulator.
- **Stored data:** a SwiftData model change keeps data from an earlier TestFlight build readable.
- **Cadence optional:** the run still works when Core Motion reports nothing.
- **Secrets:** no key, token, or environment content is in the diff.

## Code review contract

Approve when the change improves code health, even if it isn't perfect. Report only gaps in correctness,
security, or the approved criteria; a style preference is not a finding. Never ask for extra abstraction,
defensive code, or tests for cases that cannot happen. Check that:

1. Every acceptance criterion this PR covers is met with evidence. A criterion without evidence is unmet.
2. Logic lives in `RunnerJamsCore` where `AGENTS.md` says it does, and the core imports no MusicKit,
   SwiftData, or UIKit.
3. Every external input (the bundled catalog, MusicKit responses, Core Motion readings) is validated, and
   async work handles its errors.
4. No secret, environment content, or stray logging enters the diff.
5. Tests ship in the same commit as the code they cover, and every commit builds and passes.
6. The code is the simplest thing that works. Cleverness the packet didn't ask for is a defect.
7. Comments say only what the code cannot, such as a reason or a constraint. `TODO:` comments stay.
8. No test was deleted, skipped (`XCTSkip`, `.disabled`), or weakened, and nothing outside the task was
   added, unless the packet called for it. Either is a blocking defect.
9. The PR stays under about 400 reviewable lines and 10 files, or says why not.

Lane reports end with **Defects** (blocking, unlimited), **Improvements** (at most three, never blocking),
**Verification gaps**, then `Verdict: Approve` or `Verdict: Request changes`.
