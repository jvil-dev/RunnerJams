# Personalized Running DJ — Product Brainstorm

## Working concept

**A personalized DJ for runners.**

The app turns a run into a programmed musical set instead of a generic workout playlist. A runner chooses a session—initially, a duration—and the app selects and sequences music around their taste, running context, and the arc of the workout.

The central question is not “What song matches this cadence?” It is:

> What would a DJ play next, right now, for this runner?

The idea originated with Jacq as a simpler running companion: load a runner’s library and recommend high-energy music tailored to what they already like. The DJ framing gives that idea a distinct product and technical shape.

## Product thesis and differentiation

Most running-music products focus on BPM matching, a playlist, or a pre-made workout mix. This product aims to combine:

- Personal taste and existing listening library
- Live running context: cadence, pace, workout phase, and eventually heart rate
- DJ logic: energy progression, BPM movement, key compatibility, and intentional transitions
- Personal learning from what a specific runner plays, skips, and responds to
- A session-length-aware musical program

The useful metaphor is that a DJ reads a room; this app learns to **read one runner**. It should feel like an autonomous DJ actively programming a run—not merely a music recommender that happens to know tempo.

## The three “brains”

### Music brain

Understands the musical relationship between tracks:

- BPM and feasible tempo changes
- Musical key and Camelot-wheel compatibility
- Energy, intensity, mood, genre, and danceability
- Track-to-track transitions and overall set progression
- Song duration and how it fits the remaining session

### Runner brain

Understands the runner’s current situation:

- Cadence / steps per minute
- Pace and changes in pace
- Workout phase or structure
- Distance and elapsed time
- Optional future signals, such as heart rate and acceleration

### Personalization brain

Builds a model of this person’s musical taste and running behavior:

- Favorite artists, genres, eras, and tempo ranges
- Frequently played and recently played tracks
- In-run skips, completions, likes, and dislikes
- Which songs work well at particular phases or intensities
- Whether certain music is associated with changes in cadence or pace

Together, these systems decide the next track based on musical compatibility, current running state, the planned workout arc, and learned individual preferences.

## Competitor landscape

The space is validated but crowded around individual pieces of the concept.

| Product | Relevant capability | Takeaway |
| --- | --- | --- |
| Spotify Running Mode | Personalized sessions by taste, workout, duration, and BPM; beat matching and optional speed changes | Closest large-platform competitor; validates demand, so avoid a “Spotify for runners” positioning. |
| RockMyRun | DJ-created workout mixes that can match steps or heart rate | Philosophically close, but its music is DJ-curated rather than a runner-specific DJ decision engine. |
| Cadence | Apple Music tracks matched to target cadence; live cadence adaptation; AI-generated supplement tracks | Close technically, especially for cadence matching and adaptable music. |
| PaceDJ | Uses an Apple Music library and BPM metadata to make tempo-matched playlists | Validates library-based curation and an external analysis database. |
| jog.fm | Matches library music to pace and learns from skips and favorites | Validates behavioral learning, though it is an older product. |
| Weav Run | Historically created tempo-synchronized arrangements for footfall matching | Shows that real-time synchronization has been explored before. |
| FITRADIO | Professional-DJ workout music that can match stride | Adjacent, mix-first experience. |
| AudioRun | Dynamically generated music responding to cadence, acceleration, and sprints | Adjacent but a different, generation-first approach. |

### Positioning implication

The differentiator is the **combination**: personal music taste + live running context + DJ-style programming + musical compatibility + learning from individual running behavior. The product promise should stay close to:

> Tell me how long you’re running. I’ll DJ the run for you.

## Session-duration curation

Time is a particularly strong initial interaction. A runner says, for example, “30 minutes,” and receives a personalized set designed to last about that long.

For a 30-minute steady run, an initial energy arc could be:

| Time | Phase | Musical direction |
| --- | --- | --- |
| 0–5 min | Warm-up | Familiar tracks; moderate energy |
| 5–12 min | Build | Gradual increase in BPM and/or energy |
| 12–23 min | Main run | Sustained, motivating intensity |
| 23–28 min | Push | Strongest, highest-motivation selections |
| 28–30 min | Finish or cooldown | Final push or a gentler landing, based on preference |

Song duration is a first-class selection constraint. Rather than filling a playlist with arbitrary songs, the engine should search for tracks that satisfy taste, energy, BPM, key/transition quality, and the remaining amount of time. A reasonable early target is to land within **±60 seconds** of the selected duration.

### Planned but adaptive behavior

The session should begin with a plan but not be rigid:

- If the runner continues past the planned time, extend the set with the next musically sensible track.
- If the runner stops early, the session simply ends; the plan is not a failure.
- Future session definitions can include distance (for example, 5K), structured workouts (such as intervals), or an open-ended run.

This is more compelling than a static playlist: it is a DJ set with a plan that can respond to what actually happens.

## Technical architecture direction

### Library and playback integrations

An authorized user can connect a streaming library as the taste starting point. Apple Music is a practical initial platform because MusicKit can support library access, recently played content, recommendations, and playback control. Spotify can expose library data too, but its developer access is more restrictive.

The integration supplies catalog and user-behavior context; it should not be assumed to provide raw audio files for arbitrary analysis. The product needs its own analysis layer to connect catalog IDs to music features.

### Track-analysis database

Maintain or obtain an analysis record keyed to a service-specific track ID, with fields such as:

```text
Track
├── serviceTrackId
├── title / artist / genre
├── duration
├── BPM
├── musical key / Camelot key
├── energy and intensity
├── danceability and valence / mood
├── vocal vs. instrumental
└── run-suitability attributes
```

This record combines familiar DJ metadata with product-specific attributes. The library import identifies what the user knows and likes; the analysis database makes that library usable for set programming.

### Real-time decision loop

1. Import library, history, and available preference signals after authorization.
2. Match tracks to the analysis database and create an initial taste fingerprint.
3. When a run starts, build a provisional sequence for its duration and workout arc.
4. Before each track transition, read current running and interaction signals.
5. Score candidate tracks, select the next one, and update the remaining session plan.
6. Record the outcome—play-through, skip, like/dislike, and relevant runner context—for personalization.

## BPM, key, and cadence logic

BPM and key are useful DJ inputs, not the whole recommendation. Cadence can map to music at the same rate or a musically sensible half/double-time relationship. For example, a runner at 166 steps per minute may align naturally to approximately 83 or 166 BPM, depending on the beat interpretation and song structure.

Key compatibility improves the odds of a smooth transition. Camelot-key proximity can be one component of the ranking, while DJ rules should remain soft constraints: a familiar, highly motivating song may be worth a less-perfect transition.

Tempo shifting should not be assumed available for streamed catalog tracks. Licensing restrictions may prevent it; PaceDJ reportedly removed BPM shifting for Apple Music streams for this reason. The MVP should select tracks near the target tempo rather than depend on altering recordings. Dynamically generated or separately licensed music could make real-time stretching possible later.

## Personalization and learning

The user’s library is the initial taste fingerprint, not necessarily training data for a large model. Start with explicit, interpretable signals:

- Library membership, favorites, repeat listening, and recent listening
- Preferred artists, genres, eras, and BPM ranges
- In-app skips, replays, saves, likes, and dislikes
- Full-track completion within each run phase
- Aggregate relationship between tracks and cadence, pace, or heart-rate changes

Over time, the app’s own data becomes the higher-value signal. Example:

```text
Track X has appeared in 8 runs
├── skipped in 6 warm-ups
├── completed in 7 of 8 high-intensity segments
└── associated with a 4-SPM average cadence increase

Inference: deprioritize Track X in warm-up; prefer it for hard efforts.
```

An ML model may become useful once enough behavioral data exists, but the initial product can learn through transparent rules and user-specific weight adjustments.

## Candidate scoring logic

Begin with a weighted, explainable score rather than a large AI model:

```text
nextTrackScore =
  0.25 × tasteMatch
+ 0.25 × cadenceMatch
+ 0.20 × energyMatch
+ 0.15 × BPMTransition
+ 0.10 × keyCompatibility
+ 0.05 × novelty
```

The weights can gradually adapt by runner. Additional practical scoring terms include remaining-duration fit, workout-phase suitability, recency avoidance, track availability, and a skip penalty.

Example decision state:

```text
Current track: 124 BPM, 8A, energy 0.70
Runner: 166 SPM, increasing heart rate, sustained-run phase

Candidate A: 126 BPM, 8A, energy 0.76, taste 93%
Candidate B: 140 BPM, 4B, energy 0.91, taste 72%
Candidate C: 125 BPM, 9A, energy 0.81, taste 89%

Likely choice: Candidate C
```

The example captures the product principle: the engine programs an energy journey, not simply the closest BPM.

## MVP recommendation

Keep the first version narrow and demonstrable:

1. One music service, ideally Apple Music, for authorized library access and playback.
2. Time-based runs only: the user selects a duration.
3. A pre-analyzed track catalog with BPM, key, duration, energy, and basic genre/mood data.
4. A provisional, duration-aware DJ sequence with simple phases: warm-up, build, main run, finish.
5. Basic adaptation at track boundaries using cadence if available, plus skips and favorites.

This makes the promise concrete without requiring real-time audio manipulation, a large proprietary music dataset, health integrations, or an AI model on day one.

## Risks and constraints

- **Streaming rights and APIs:** Library access, playback control, metadata availability, and permitted transformations vary by provider and can change.
- **Audio analysis access:** Streaming services generally do not give unrestricted raw audio for proprietary analysis; a separate metadata/analysis strategy is required.
- **Tempo manipulation:** Do not design the MVP around speed-shifting commercial streamed tracks.
- **Metadata coverage and quality:** BPM, key, mood, and energy may be absent, inconsistent, or disputed across catalog sources.
- **Cold start:** New users with small libraries or little history need a graceful path, such as taste onboarding or catalog recommendations.
- **Live signal reliability:** Cadence, pace, and heart rate can be noisy or unavailable depending on the device and permissions.
- **Privacy:** Running, health, and listening behavior are sensitive. Use clear consent, minimize collection, and explain how personalization works.
- **Competitive pressure:** Spotify’s recent entry is validation but raises the bar; the experience must feel meaningfully more DJ-like and personal.

## Future possibilities

- Distance-based sessions, interval plans, and open-ended runs
- Heart-rate-informed selection and energy adjustment
- Voice or natural-language run setup (for example, “30 minutes, nostalgic house, finish hard”)
- Coaching cues timed to musical transitions
- AI-generated or separately licensed adaptive tracks that can safely change tempo
- Richer transition logic, including mix points and intentional set-breaking moments
- Post-run summary: what played, what was skipped, and what the app learned
- Taste profiles for different contexts: easy run, race day, treadmill, hills, recovery
- Cross-service support where rights and APIs allow

## Open product questions

1. Is the core audience runners who already care about music/DJ flow, or runners who simply want effortless motivation?
2. Should the MVP be a real-time selector at every track boundary, or a smart prebuilt set with only extension behavior?
3. What minimum track-analysis source can provide credible BPM/key/energy coverage for the initial catalog?
4. How much control should runners have over energy curve, genres, explicit content, and discovery versus familiarity?
5. Which platform can deliver the cleanest end-to-end prototype under its current playback and data rules?

## Short product statement

**Personalized Running DJ is an adaptive music companion that plans a run-length-aware set from a runner’s taste, then keeps programming the next best track from their pace, cadence, workout phase, and learned behavior.**
