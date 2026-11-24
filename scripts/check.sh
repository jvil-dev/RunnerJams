#!/usr/bin/env bash
# Repository check: gates every commit.
set -euo pipefail
cd "$(dirname "$0")/../Packages/RunnerJamsCore"
swift test
