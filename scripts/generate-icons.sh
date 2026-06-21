#!/usr/bin/env bash
#
# generate-icons.sh — rasterize the SVG sources into the PNG assets that
# iOS (and most social/link-preview scrapers) require.
#
# iPhones cannot use SVG for the home-screen icon (apple-touch-icon) or for
# iMessage/social Open Graph previews — those need real raster images. The
# SVG sources live in assets/ and the HTML already points at the PNG paths
# this script produces, so once you run it the site is fully wired.
#
# Usage:
#   bash scripts/generate-icons.sh
#
# Requires ONE of (auto-detected, in order of preference):
#   - rsvg-convert   (librsvg)         brew install librsvg / apt install librsvg2-bin
#   - inkscape                          brew install inkscape / apt install inkscape
#   - magick / convert (ImageMagick)    brew install imagemagick / apt install imagemagick
#   - python3 + cairosvg                pip install cairosvg
#
set -euo pipefail

cd "$(dirname "$0")/.."
ASSETS="assets"

# rasterize <src.svg> <dst.png> <width> <height>
rasterize() {
  local src="$1" dst="$2" w="$3" h="$4"
  if command -v rsvg-convert >/dev/null 2>&1; then
    rsvg-convert -w "$w" -h "$h" "$src" -o "$dst"
  elif command -v inkscape >/dev/null 2>&1; then
    inkscape "$src" --export-type=png --export-filename="$dst" -w "$w" -h "$h" >/dev/null 2>&1
  elif command -v magick >/dev/null 2>&1; then
    magick -background none -density 384 "$src" -resize "${w}x${h}" "$dst"
  elif command -v convert >/dev/null 2>&1; then
    convert -background none -density 384 "$src" -resize "${w}x${h}" "$dst"
  elif command -v python3 >/dev/null 2>&1 && python3 -c "import cairosvg" >/dev/null 2>&1; then
    python3 - "$src" "$dst" "$w" "$h" <<'PY'
import sys, cairosvg
src, dst, w, h = sys.argv[1], sys.argv[2], int(sys.argv[3]), int(sys.argv[4])
cairosvg.svg2png(url=src, write_to=dst, output_width=w, output_height=h)
PY
  else
    echo "ERROR: no SVG rasterizer found." >&2
    echo "Install one of: librsvg (rsvg-convert), inkscape, imagemagick, or 'pip install cairosvg'." >&2
    exit 1
  fi
  echo "  ✓ $dst (${w}×${h})"
}

echo "Generating raster icons + OG image…"

# Apple touch icon — iOS home screen (must be PNG, 180×180, opaque, full-bleed).
rasterize "$ASSETS/icon.svg"      "$ASSETS/apple-touch-icon.png" 180 180

# PWA / manifest icons.
rasterize "$ASSETS/icon.svg"      "$ASSETS/icon-192.png"         192 192
rasterize "$ASSETS/icon.svg"      "$ASSETS/icon-512.png"         512 512
rasterize "$ASSETS/icon.svg"      "$ASSETS/maskable-512.png"     512 512

# Classic raster favicons (fallback for older browsers / Google etc.).
rasterize "$ASSETS/favicon.svg"   "$ASSETS/favicon-32.png"        32  32
rasterize "$ASSETS/favicon.svg"   "$ASSETS/favicon-180.png"      180 180

# Open Graph / social share image (must be PNG/JPEG for iMessage & friends).
rasterize "$ASSETS/og-image.svg"  "$ASSETS/og-image.png"        1200 630

echo "Done. Commit the generated *.png files in $ASSETS/."
