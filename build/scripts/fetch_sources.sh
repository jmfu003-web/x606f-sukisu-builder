#!/usr/bin/env bash
set -euxo pipefail
KERNEL_REPO="${KERNEL_REPO:-https://github.com/MatiDEV-PL/kernel_lenovo_achilles6_row_wifi}"
KERNEL_BRANCH="${KERNEL_BRANCH:-}"
WORKDIR="$GITHUB_WORKSPACE"
SRC="$WORKDIR/src"
mkdir -p "$SRC"

if [ ! -d "$SRC/kernel" ]; then
  git clone --depth=1 ${KERNEL_BRANCH:+-b "$KERNEL_BRANCH"} "$KERNEL_REPO" "$SRC/kernel"
fi

if [ ! -d "$SRC/sukisu" ]; then
  git clone --depth=1 https://github.com/sukisu-ultra/sukisu-ultra "$SRC/sukisu"
fi
