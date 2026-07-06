#!/usr/bin/env bash
# Copy this quarter's finals into public/ using stable filenames for GitHub Pages.
# Optional: BSQ_LINK_FIX="oldname.html:newname.html;other.html:publications.html"
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PUB="$ROOT/public"
usage() {
  echo "Usage: $0 <newsletter.html> <publications.html> <faculty-metrics.html>" >&2
  echo "Copies into $PUB as newsletter.html, publications.html, faculty-metrics.html" >&2
  echo "Set BSQ_LINK_FIX to rewrite internal hrefs, e.g.:" >&2
  echo '  BSQ_LINK_FIX="draft-publications.html:publications.html;draft-faculty.html:faculty-metrics.html" '"$0"' ...' >&2
  exit 1
}
[ "$#" -eq 3 ] || usage
mkdir -p "$PUB"
cp "$1" "$PUB/newsletter.html"
cp "$2" "$PUB/publications.html"
cp "$3" "$PUB/faculty-metrics.html"
if [ -n "${BSQ_LINK_FIX:-}" ]; then
  IFS=';' read -ra PAIRS <<< "$BSQ_LINK_FIX"
  for pair in "${PAIRS[@]}"; do
    [ -z "$pair" ] && continue
    from="${pair%%:*}"
    to="${pair#*:}"
    [ "$from" = "$to" ] && continue
    for f in "$PUB"/*.html; do
      perl -pi -e 's/\Q'"$from"'\E/'"$to"'/g' "$f"
    done
  done
fi
echo "OK — updated $PUB/{newsletter,publications,faculty-metrics}.html"
echo "Edit $PUB/index.html subtitle if needed, then commit and push."
