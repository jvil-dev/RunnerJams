#!/usr/bin/env bash
# Repository check: gates every commit and runs from the global Stop hook.
set -euo pipefail
cd "$(dirname "$0")/../Packages/RunnerJamsCore"
swift test
