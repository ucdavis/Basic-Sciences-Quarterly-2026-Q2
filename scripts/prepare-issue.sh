#!/usr/bin/env bash
# Copy this quarter's finals into public/<quarter>/ using stable filenames for GitHub Pages.
# Each quarter gets its own permanent subfolder (e.g. public/2026-q2/, public/2026-q3/),
# so old issues stay live at their same URL forever and nothing gets overwritten.
#
# Usage:
#   ./scripts/prepare-issue.sh <quarter-folder> <newsletter.html> <publications.html> <faculty-metrics.html>
#
# Example:
#   ./scripts/prepare-issue.sh 2026-q3 \
#     "/path/to/BSQ-Newsletter-Q3-2026-FINAL.html" \
#     "/path/to/BSQ-Publications-Q3-2026-FINAL.html" \
#     "/path/to/faculty-metrics-Q3-2026-FINAL.html"
#
# Optional: BSQ_LINK_FIX="oldname.html:newname.html;other.html:publications.html"
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PUB="$ROOT/public"

usage() {
  echo "Usage: $0 <quarter-folder> <newsletter.html> <publications.html> <faculty-metrics.html>" >&2
  echo "Example quarter-folder: 2026-q3" >&2
  echo "Copies into $PUB/<quarter-folder>/ as newsletter.html, publications.html, faculty-metrics.html" >&2
  echo "Set BSQ_LINK_FIX to rewrite internal hrefs, e.g.:" >&2
  echo '  BSQ_LINK_FIX="draft-publications.html:publications.html;draft-faculty.html:faculty-metrics.html" '"$0"' ...' >&2
  exit 1
}

[ "$#" -eq 4 ] || usage
QUARTER="$1"
ISSUE_DIR="$PUB/$QUARTER"

mkdir -p "$ISSUE_DIR"
cp "$2" "$ISSUE_DIR/newsletter.html"
cp "$3" "$ISSUE_DIR/publications.html"
cp "$4" "$ISSUE_DIR/faculty-metrics.html"

if [ -n "${BSQ_LINK_FIX:-}" ]; then
  IFS=';' read -ra PAIRS <<< "$BSQ_LINK_FIX"
  for pair in "${PAIRS[@]}"; do
    [ -z "$pair" ] && continue
    from="${pair%%:*}"
    to="${pair#*:}"
    [ "$from" = "$to" ] && continue
    for f in "$ISSUE_DIR"/*.html; do
      perl -pi -e 's/\Q'"$from"'\E/'"$to"'/g' "$f"
    done
  done
fi

echo "OK — updated $ISSUE_DIR/{newsletter,publications,faculty-metrics}.html"
echo ""
echo "Next: add a card for '$QUARTER' in $PUB/index.html if it's a new quarter"
echo "(copy an existing <li> card block and point its three links at $QUARTER/...),"
echo "then commit and push."
