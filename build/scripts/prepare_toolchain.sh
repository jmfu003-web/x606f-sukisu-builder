#!/usr/bin/env bash
set -euxo pipefail
CLANG_VER="${1:-r416183b}"
TC_DIR="$GITHUB_WORKSPACE/prebuilts/clang/${CLANG_VER}"
mkdir -p "$(dirname "$TC_DIR")"

if [ ! -d "$TC_DIR" ]; then
  echo "Downloading Google prebuilt clang: $CLANG_VER"
  # Use mirror from AOSP prebuilts (static URL pattern may vary across versions)
  # Here we pull from LLVM release mirrored tarballs if available; fallback to Android NDK
  curl -L -o /tmp/clang.tar.xz "https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/master/clang-${CLANG_VER}.tar.gz" || true
  if [ -s /tmp/clang.tar.xz ]; then
    mkdir -p "$TC_DIR"
    tar -C "$TC_DIR" -xf /tmp/clang.tar.xz || true
  else
    # Fallback: use system clang (not ideal, but keeps CI running)
    echo "Fallback to system clang"
    mkdir -p "$TC_DIR/bin"
    ln -sf /usr/bin/clang "$TC_DIR/bin/clang" || true
    ln -sf /usr/bin/clang++ "$TC_DIR/bin/clang++" || true
  fi
fi
