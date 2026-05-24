#!/usr/bin/env bash
set -euo pipefail

svg="logo.svg"
font_family="JetBrainsMono Nerd Font Mono"
sizes=(64 128 192 256 460 512 1024)
resvg_bin="${RESVG:-resvg}"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

if ! command -v "$resvg_bin" >/dev/null 2>&1; then
  echo "error: resvg is required but was not found" >&2
  echo "hint: install resvg or run with RESVG=/path/to/resvg" >&2
  exit 1
fi

if [[ ! -f "$svg" ]]; then
  echo "error: $svg was not found" >&2
  exit 1
fi

light_stylesheet="$tmpdir/light.css"
dark_stylesheet="$tmpdir/dark.css"

printf 'path, circle { fill: black !important; }\n' >"$light_stylesheet"
printf 'path, circle { fill: white !important; }\n' >"$dark_stylesheet"

export_png() {
  local size="$1"
  local stylesheet="$2"
  local background="$3"
  local out="$4"

  local background_args=()
  if [[ -n "$background" ]]; then
    background_args=(--background "$background")
  fi

  "$resvg_bin" \
    --quiet \
    --stylesheet "$stylesheet" \
    "${background_args[@]}" \
    --monospace-family "$font_family" \
    --width "$size" \
    --height "$size" \
    "$svg" \
    "$out"
  echo "exported $out"
}

for size in "${sizes[@]}"; do
  export_png "$size" "$light_stylesheet" "" "logo_light_transparent_${size}x${size}.png"
  export_png "$size" "$light_stylesheet" "#fff" "logo_light_opaque_${size}x${size}.png"
  export_png "$size" "$dark_stylesheet" "" "logo_dark_transparent_${size}x${size}.png"
  export_png "$size" "$dark_stylesheet" "#000" "logo_dark_opaque_${size}x${size}.png"
done
