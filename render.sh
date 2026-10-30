#!/usr/bin/env bash
# render.sh — render a deck to a single self-contained HTML file
#
# Usage:
#   ./render.sh <deck.qmd>       # render one deck
#   ./render.sh                  # render every *.qmd at the repo root
#
# Output: <deck>.html sits next to the source (embed-resources = single file).

set -euo pipefail
cd "$(dirname "$0")"

if ! command -v quarto >/dev/null 2>&1; then
  echo "quarto not found on PATH. Install from https://quarto.org/docs/get-started/" >&2
  exit 1
fi

render_one() {
  local qmd="$1"
  echo "──────────────────────────────────────────────────────────"
  echo "Rendering: $qmd"
  echo "──────────────────────────────────────────────────────────"
  quarto render "$qmd"
  echo "  → ${qmd%.qmd}.html"
  echo ""
}

if [[ $# -ge 1 ]]; then
  render_one "$1"
else
  shopt -s nullglob
  decks=( *.qmd )
  if [[ ${#decks[@]} -eq 0 ]]; then
    echo "No .qmd files at repo root." >&2
    exit 1
  fi
  for d in "${decks[@]}"; do
    [[ "$d" == "template.qmd" ]] && continue   # skip the showcase skeleton
    render_one "$d"
  done
fi

echo "Done."
