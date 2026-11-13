<!--
Title: type(scope): imperative summary. Each PR belongs to one leaf issue. Target: main.
Open as a DRAFT after the first commit. Fill Summary and the criteria this PR covers now; check
criteria off as commits land. Mark ready only when every box is checked.
-->

Issue: <Closes #n | Part of #n | N/A — fast path: reason>

## Summary

> TLDR: <one sentence: what changes, and for whom>

<!-- The smallest view that shows the change, next to 1–2 lines of text: pseudocode, a call tree,
a component tree, a file tree, Mermaid, or a shaped diff. Sketch it before the work is done;
redraw it if the shape changes. -->

```text

```

## Acceptance criteria

<!-- Copied from the issue. Check each off in the commit that satisfies it. -->

- [ ]

## Merge danger and rollout

<!-- A migration, a contract removal, or anything sent outward is one-way.
Delete lines that do not apply. -->

- Door: `two-way — revert the merge` / `one-way — <what cannot be undone>`
- Blast radius: `<who or what breaks if this is wrong>`
- Contract: `additive` / `deprecates <field>` / `N/A`
- Migration: `add-only, safe against running code` / `N/A`
- Launch boundary: `no new user-facing surface` / `new surface behind <boundary>, launch not approved`

## Test plan

- [ ] Evidence: before `<failing test, output, or screenshot>` → after `<passing result>`
- [ ] Automated: `<command>` or `N/A — <reason>`
- [ ] Manual: `<steps>` or `N/A — <reason>`

## Out of scope

-

<!-- Over 400 lines or 10 files? One line here saying why it is one PR. -->
