# Runner Jams

[![Core Tests](https://github.com/jvil-dev/RunnerJams/actions/workflows/core-tests.yml/badge.svg)](https://github.com/jvil-dev/RunnerJams/actions/workflows/core-tests.yml)

*Tell me how long you're running. I'll DJ the run for you.* An iOS app for Apple Music subscribers that programs a music set to fit your run.

**Status:** in development.

## Layout

- `RunnerJams/RunnerJams.xcodeproj`: the iOS app.
- `Packages/RunnerJamsCore`: the pure-Swift core (catalog models, set planning, next-track ranking).
- `docs/`: product documents.

## Running the tests

```sh
cd Packages/RunnerJamsCore
swift test
```
