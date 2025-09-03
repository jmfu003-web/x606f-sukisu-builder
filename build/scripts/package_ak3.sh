#!/usr/bin/env bash
set -euxo pipefail
WORKDIR="$GITHUB_WORKSPACE"
OUT="$WORKDIR/out"
AK3="$WORKDIR/build/ak3"

if [ ! -f "$OUT/Image.gz-dtb" ]; then
  echo "Image.gz-dtb not found in out/"
  ls -l "$OUT" || true
  exit 1
fi

cp "$OUT/Image.gz-dtb" "$AK3/"
pushd "$AK3"
zip -r "$OUT/AnyKernel3-sukisu-x606f.zip" .
popd
