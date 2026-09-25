# CLAUDE.md

## Status

Early implementation (M0). The repo is [github.com/jvil-dev/RunnerJams](https://github.com/jvil-dev/RunnerJams).

Layout:
- `RunnerJams/RunnerJams.xcodeproj`: the iOS app. It depends on the local package through `../Packages/RunnerJamsCore`.
- `Packages/RunnerJamsCore`: the pure-Swift core. Run `swift test` from that directory.
- `docs/`: product documents.

Build the app from the command line with:
`xcodebuild -project RunnerJams/RunnerJams.xcodeproj -scheme RunnerJams -destination 'generic/platform=iOS Simulator' build`

**Goal:** a resume MVP shipped as a public TestFlight link and a public GitHub repo.

- **Repo:** public, with no LICENSE file for now (all rights reserved by default).
- **Apple Developer account:** personal for now; moving it to the LLC comes later.

**Planning lives in Linear.** Workspace: JBRL Services LLC. Team: RunnerJams (key `RUN`).
- [MVP → TestFlight](https://linear.app/jbrl-llc/project/mvp-testflight-1423d7af5d89)
  - Milestones M0 Foundations → M6 Ship.
  - Each milestone has 2–4 top-level **parent issues**. Each parent has *Acceptance criteria* and a *Likely sub-tasks* checklist.
  - Promote a checklist item to a sub-issue when it becomes real work.
  - Work starts at RUN-1.
- [Post-MVP parking lot](https://linear.app/jbrl-llc/project/post-mvp-parking-lot-b510b0f61952): holds deferred ideas. Don't pull from it without an explicit decision.
- **Labels:** one `Area` label (Playback, Catalog, Engine, UI, Infra) plus one workspace `Type` label (Feature, Task, Bug, Improvement).
- AssemblyOps (`AOP`) is a separate product in the same workspace. Don't touch it from this project.

## What this project is

**Runner Jams** (working name: Personalized Running DJ) — an iOS app for Apple Music subscribers. The runner picks a duration, presses Start, and gets a music set that feels intentionally programmed for the run, not a shuffled playlist.

Product promise: *"Tell me how long you're running. I'll DJ the run for you."*

## Source of truth

Two documents define the product; read the relevant one before proposing scope or architecture:

- `docs/personalized-running-dj-brainstorm.md` — full product vision, competitor landscape, the three "brains" (music / runner / personalization), scoring model, risks, open questions.
- `docs/ios-native-mvp-brainstorm.md` — the narrowed iOS MVP: scope, architecture, feasibility table, deferral list, success criteria.

When the two conflict, the iOS MVP document wins for anything being built now; the broader brainstorm describes the later trajectory.

## Planned architecture (iOS MVP)

```
SwiftUI views
  └─ RunSessionCoordinator
       ├─ MusicKitPlaybackService      (ApplicationMusicPlayer)
       ├─ CadenceService               (Core Motion CMPedometer)
       ├─ SetPlanner and NextTrackRanker
       └─ SwiftData persistence
            ├─ Seed track catalog
            ├─ Run sessions
            └─ Track feedback events
```

Baseline: iOS 17+ deployment target, Swift 6 language mode, Xcode 27, SwiftUI, SwiftData, MusicKit, Core Motion. No backend, no accounts, no cloud sync in v1 — all state is local to the device.

- **`RunnerJamsCore`** is a local Swift package that holds all pure logic: catalog models, SetPlanner, NextTrackRanker and the scoring terms.
  - It must not import MusicKit, SwiftData or UIKit, so it can be tested on macOS with Swift Testing.
  - GitHub Actions runs `swift test` on it.
- **No third-party dependencies.**
- **Distribution** is a manual Xcode archive → TestFlight.
- **MusicKit playback doesn't run in the Simulator.** Test playback on a real device.

## Design constraints that drive the code

- **Controlled seed catalog.** v1 does not ingest the full Apple Music library. It uses a small, hand-curated catalog of tracks pre-labeled with BPM, key/Camelot, energy, duration, genre, and mood. Do not write code that assumes Apple Music supplies reliable BPM/key/energy.
- **Explainable ranking, not ML.** Next-track selection is a weighted score (taste, phase/energy fit, cadence fit, duration fit, BPM/key transition, novelty, minus recency and skip penalties) over a small candidate pool, evaluated at track boundaries. Keep the terms readable and individually inspectable.
- **Plan first, adapt lightly.** Build a provisional duration-aware queue across four phases (warm-up 15%, build 25%, main 40%, finish 20%), then adjust only the next track at boundaries. Never rebuild the whole session mid-run.
- **Cadence is optional input.** The experience must be complete when Core Motion reports nothing. No code path may require cadence.
- **No tempo shifting.** Licensing blocks speed-shifting streamed catalog tracks. Select tracks near the target tempo instead.
- **Land within ±60s** of the chosen duration; extend gracefully if the runner keeps going, end cleanly if they stop early.
- **Background playback must work** with the phone locked and headphones connected. Configure background audio.

## Explicitly deferred

Full library ingestion, Spotify, Apple Watch / HealthKit / heart rate, GPS and distance goals, interval workouts, beat-matched transitions or audio manipulation, user accounts, cloud sync, backend, ML recommender or generated music. Do not add these without an explicit decision.

## Seed catalog decision (resolved 2026-09-24)

- About 80 tracks across pop, hip-hop and EDM.
- Labeled by the developer by analyzing licensed MP3s from BPMMusic.io:
  - BPM and Camelot key come from the files' ID3 tags or DJ-software analysis.
  - Energy (0–1) is computed by a script and checked against a rubric in `docs/catalog-rubric.md`.
  - GetSongBPM or Tunebat is only a fallback.
- **Audio files never go in the repo or the app.** Only the derived `catalog.json` is committed.
- Label the version that matches Apple Music, not DJ edits. Duration always comes from Apple Music.
- Ships as a bundled `catalog.json` that is seeded into SwiftData.
- IDs are checked with a DEBUG-only MusicKit screen.
- Tracked in RUN-6, RUN-7 and RUN-8.

## Working notes

- Commit or push only when the developer asks. The default branch is `main`.
- The Xcode project file (`project.pbxproj`) is maintained by Xcode. Edit it by hand only for mechanical build-setting changes.
- Product scope belongs to the developer. Draft scope from these documents for approval before implementing.
