#!/bin/bash
set -ueo pipefail
cd "$(dirname "$0")/.."

# $1: file
run_gyb() {
  local src=$1
  local dest=${src%.*}
  echo "$src => $dest"
  utils/gyb --line-directive "" "$src" > "$dest"
}

for src in $(find "Sources" -name "*.swift.gyb"); do
  run_gyb "$src"
done