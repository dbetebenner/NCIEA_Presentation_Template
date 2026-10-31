#!/usr/bin/env bash
# preview.sh — live preview with auto-reload while you edit
#
# Usage:
#   ./preview.sh <deck.qmd>
#
# Opens the deck in your browser and re-renders on every save.
# Press Ctrl+C to stop the preview server.

set -euo pipefail
cd "$(dirname "$0")"

if [[ $# -lt 1 ]]; then
  echo "Usage: ./preview.sh <deck.qmd>" >&2
  exit 1
fi

if ! command -v quarto >/dev/null 2>&1; then
  echo "quarto not found on PATH. Install from https://quarto.org/docs/get-started/" >&2
  exit 1
fi

quarto preview "$1"
