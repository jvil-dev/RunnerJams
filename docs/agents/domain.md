# Domain docs

How the engineering skills read this repo's domain documentation. Layout: single-context.

## Before exploring, read these

- `GLOSSARY.md` at the repo root, if it exists.
- `docs/adr/`, for decisions that touch the area you are about to work in.
- The two product documents named under "Source of truth" in `AGENTS.md`.

If `GLOSSARY.md` or `docs/adr/` does not exist yet, proceed silently. The `domain-modeling` skill creates them when a term or a decision is first settled.

## Use the glossary's vocabulary

When your output names a domain concept (in an issue title, a test name, a proposal), use the term as `GLOSSARY.md` and the product documents define it. If the concept you need has no term yet, note the gap for `domain-modeling` instead of inventing one.

## Flag ADR conflicts

If your output contradicts an existing ADR or the seed catalog decision in `AGENTS.md`, say so instead of silently overriding it.
