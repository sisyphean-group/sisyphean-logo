#!/usr/bin/env bash
set -euo pipefail

svg="logo.svg"
font_family="JetBrainsMono Nerd Font Mono"
sizes=(64 128 192 256 460 512 1024)
resvg_bin="${RESVG:-resvg}"

if ! command -v "$resvg_bin" >/dev/null 2>&1; then
  echo "error: resvg is required but was not found" >&2
  echo "hint: install resvg or run with RESVG=/path/to/resvg" >&2
  exit 1
fi

if [[ ! -f "$svg" ]]; then
  echo "error: $svg was not found" >&2
  exit 1
fi

for size in "${sizes[@]}"; do
  out="logo_${size}x${size}.png"
  "$resvg_bin" \
    --monospace-family "$font_family" \
    --width "$size" \
    --height "$size" \
    "$svg" \
    "$out"
  echo "exported $out"
done
