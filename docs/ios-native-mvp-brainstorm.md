# Personalized Running DJ — iOS Native MVP

## The MVP in one sentence

An iPhone app for Apple Music subscribers: choose how long you are running, press Start, and get a music set that feels intentionally programmed for the run.

The first version should feel effortless, not technical. The runner should not need to understand BPM, key, or cadence matching for the product to work.

## What the MVP proves

The core question is:

> Does a duration-aware, DJ-shaped music experience make an ordinary runner more motivated than pressing play on a playlist?

It does **not** need to prove beat-perfect mixing, coaching, full-library intelligence, or an AI model.

## Target runner

Everyday runners who want low-friction motivation:

- They already have Apple Music.
- They want to choose a run length and go.
- They care more about momentum than precise training metrics.
- They will notice a bad song choice or a flat energy curve immediately.

## MVP experience

### 1. Onboarding

- Explain the value plainly: “Tell us how long you are running. We will soundtrack it.”
- Request Apple Music permission.
- Confirm an active Apple Music subscription.
- Request Motion & Fitness permission, but make it optional.
- Explain that listening feedback stays on the device in the first release.

### 2. Run setup

Offer four duration presets: 20, 30, 45, and 60 minutes.

The runner taps one duration and starts. No pace target, genre picker, account creation, or complicated configuration in the default path.

### 3. During the run

Show only what matters:

- Current track and artwork
- Elapsed and remaining time
- Cadence, when the phone supports it
- Skip, like, dislike, pause, and end-run controls

Behind the scenes, the app begins with a planned set and lightly adjusts the next song at track boundaries. A skip is the strongest live feedback signal. Cadence helps when available, but a missing cadence signal must not degrade the experience.

### 4. End of run

Show a short completion screen:

- Run duration
- Tracks played
- A simple learning statement, such as “More high-energy pop in the final stretch next time.”

This is optional product polish, but it makes the app feel personal before the personalization is sophisticated.

## Set programming model

Generate a provisional queue around a four-part energy arc:

| Run phase | Approximate share | Music direction |
| --- | ---: | --- |
| Warm-up | 15% | Familiar, moderate energy |
| Build | 25% | Gradually more energetic |
| Main | 40% | Consistent, motivating intensity |
| Finish | 20% | Highest-confidence, high-energy tracks |

Aim to land within one minute of the chosen duration. If the runner continues, extend the queue with the next sensible track. If they stop early, end the session without treating it as a failure.

## Music strategy: controlled seed catalog

Use a deliberately curated and pre-analyzed catalog of Apple Music tracks for v1. Each track needs:

```text
Apple Music catalog ID
Title / artist
Duration
BPM
Musical key or Camelot key
Energy score
Genre and mood tags
Availability status
```

This is the most important scoping decision. Apple Music gives the app authorized catalog/library access and playback, but the product should not depend on Apple Music to supply reliable BPM, key, and energy values for every track. A small, high-quality catalog is enough to validate the core loop.

## How the app chooses a next track

Start with explainable rules, not machine learning:

```text
score =
  taste fit
+ phase / energy fit
+ cadence fit, if available
+ duration fit
+ transition fit (BPM and key)
+ novelty
- recent-play penalty
- skip/dislike penalty
```

At the end of each track, choose from a small eligible candidate pool instead of rebuilding the whole session. This produces adaptive behavior without abrupt or erratic decisions.

### Initial learning signals

Store these on the device:

- Tracks completed and skipped
- Likes and dislikes
- Run phase where the track appeared
- Cadence band when available

The initial learning rule can be simple: reward tracks that are completed or liked in a phase; penalize skips in that phase. The app earns the right to use a more complex model later.

## Recommended iOS architecture

```text
SwiftUI views
  └─ RunSessionCoordinator
       ├─ MusicKitPlaybackService
       ├─ CadenceService (Core Motion)
       ├─ SetPlanner and NextTrackRanker
       └─ Local persistence (SwiftData)
            ├─ Seed track catalog
            ├─ Run sessions
            └─ Track feedback events
```

### Platform choices

- **SwiftUI:** native, quick to iterate, appropriate for the small screen surface.
- **MusicKit `ApplicationMusicPlayer`:** app-controlled Apple Music playback that can continue in the background when background audio is configured.
- **Core Motion `CMPedometer`:** live cadence, pace, and step data when the iPhone hardware supports it.
- **SwiftData:** local history and preferences without accounts or a backend.
- **iOS 17+:** supports a clean modern SwiftUI and SwiftData baseline.

## What is feasible now

| Capability | MVP status | Notes |
| --- | --- | --- |
| Apple Music authorization and playback | Yes | Requires user permission and subscription eligibility. |
| Background playback | Yes | Requires background audio configuration. |
| In-app queue changes between tracks | Yes | Use this for light adaptation. |
| Live phone cadence | Yes, when supported | Treat it as optional input. |
| Duration-aware queue planning | Yes | Fully local once catalog metadata exists. |
| Local feedback learning | Yes | Start with transparent weighted rules. |
| Tempo-shifting streamed tracks | No | Do not design v1 around it. |
| Reliable BPM/key for the whole Apple Music library | No | Use the controlled seed catalog. |
| Apple Watch workout and heart rate | Later | Adds a separate app, HealthKit workout lifecycle, and cross-device state. |

## What to defer

- Full Apple Music library ingestion and metadata matching
- Spotify support
- Apple Watch app and heart-rate adaptation
- GPS, distance goals, and interval workouts
- Beat-matched transitions or audio manipulation
- User accounts, cloud sync, and a backend
- AI-generated music or a proprietary ML recommender

## Main risks

1. **Music catalog quality.** If the seed set is too small or poorly tagged, the experience will feel repetitive or arbitrary.
2. **Subscription eligibility.** The app needs a clear, kind failure state for people who cannot play Apple Music through it.
3. **Cadence reliability.** The phone may not report cadence, especially depending on placement and hardware; the music arc must stand on its own.
4. **False precision.** BPM and key improve choices but should never override a runner's demonstrated taste.
5. **Background behavior.** Test real runs with the phone locked, headphones connected, interruptions, and weak connectivity.

## Success criteria for a first pilot

- A runner can start a 20–60 minute session in under 20 seconds after onboarding.
- Playback continues with the phone locked.
- The set has a noticeable energy arc rather than random sequencing.
- Skipping a track results in a more appropriate next choice.
- A second run avoids recent skips and repeats fewer recently played tracks.
- Test runners say they would choose it over starting an ordinary playlist.

## Best next decision

Define the first seed catalog: its size, genres, and who curates BPM/key/energy labels. That decision determines whether the prototype feels like a DJ or a playlist generator.
