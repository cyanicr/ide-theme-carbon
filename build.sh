#!/usr/bin/env bash
# Builds every editor package into dist/.
set -euo pipefail
cd "$(dirname "$0")"
./jetbrains/build.sh
./zed/build.sh
