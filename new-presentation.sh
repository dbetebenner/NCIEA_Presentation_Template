#!/usr/bin/env bash
# new-presentation.sh — scaffold a new deck from template.qmd
#
# Usage:
#   ./new-presentation.sh <output-name> [options]
#
# Options (all optional; sensible defaults applied):
#   -t "Title"           Deck title
#   -s "Subtitle"        Deck subtitle
#   -a "Author Name"     Author
#   -f "Affiliation"     Author affiliation
#   -v "Venue"           Venue label (e.g., "NCIEA Staff Retreat")
#   -d YYYY-MM-DD        Date (default: today)
#
# Example:
#   ./new-presentation.sh ai_workflows \
#     -t "What Am I Actually Doing?" \
#     -s "AI-Supported Workflows in Educational Measurement" \
#     -a "Damian W. Betebenner" \
#     -f "National Center for the Improvement of Educational Assessment" \
#     -v "NCIEA Staff Retreat"
#
# Produces <output-name>.qmd at the repo root, ready to edit and render.

set -euo pipefail
cd "$(dirname "$0")"

if [[ $# -lt 1 ]]; then
  grep '^#' "$0" | sed 's/^# \{0,1\}//'
  exit 1
fi

NAME="$1"; shift
NAME="${NAME%.qmd}"

TITLE="Presentation Title"
SUBTITLE="Presentation subtitle"
AUTHOR="Damian W. Betebenner"
AFFILIATION="National Center for the Improvement of Educational Assessment"
VENUE="NCIEA"
DATE="$(date +%F)"

while getopts ":t:s:a:f:v:d:" opt; do
  case "$opt" in
    t) TITLE="$OPTARG" ;;
    s) SUBTITLE="$OPTARG" ;;
    a) AUTHOR="$OPTARG" ;;
    f) AFFILIATION="$OPTARG" ;;
    v) VENUE="$OPTARG" ;;
    d) DATE="$OPTARG" ;;
    *) echo "Unknown option: -$OPTARG" >&2; exit 1 ;;
  esac
done

OUT="${NAME}.qmd"
if [[ -e "$OUT" ]]; then
  echo "Refusing to overwrite existing $OUT" >&2
  exit 1
fi

# Substitute placeholders. Use a Python pass so titles with slashes/ampersands
# are handled safely (no sed-delimiter headaches).
TITLE="$TITLE" SUBTITLE="$SUBTITLE" AUTHOR="$AUTHOR" \
AFFILIATION="$AFFILIATION" VENUE="$VENUE" DATE="$DATE" \
python3 - "$OUT" <<'PY'
import os, sys
out = sys.argv[1]
with open("template.qmd", "r", encoding="utf-8") as fh:
    text = fh.read()
repl = {
    "{{TITLE}}": os.environ["TITLE"],
    "{{SUBTITLE}}": os.environ["SUBTITLE"],
    "{{AUTHOR}}": os.environ["AUTHOR"],
    "{{AFFILIATION}}": os.environ["AFFILIATION"],
    "{{VENUE}}": os.environ["VENUE"],
    "{{DATE}}": os.environ["DATE"],
}
for k, v in repl.items():
    text = text.replace(k, v)
with open(out, "w", encoding="utf-8") as fh:
    fh.write(text)
PY

echo "Created $OUT"
echo "Next:"
echo "  ./preview.sh $OUT      # live preview while you edit"
echo "  ./render.sh  $OUT      # build the self-contained HTML"
