#!/usr/bin/env bash
set -euxo pipefail

WORKDIR="$GITHUB_WORKSPACE"
SRC="$WORKDIR/src"
KERNEL="$SRC/kernel"

# Toolchain
CLANG="$GITHUB_WORKSPACE/prebuilts/clang/${CLANG_VER:-r416183b}/bin/clang"
export ARCH=arm64
export SUBARCH=arm64
export CC="${CLANG}"
export CROSS_COMPILE=aarch64-linux-gnu-
export LLVM=1
export LLVM_IAS=1
export PATH="$(dirname "$CLANG"):$PATH"

# ccache
if [ "${USE_CCACHE:-true}" = "true" ]; then
  export CC="ccache ${CC}"
  ccache -M 5G || true
fi

# Choose defconfig
if [ -z "${DEFCONFIG:-}" ]; then
  DEFCONFIG=$(ls -1 "$KERNEL/arch/arm64/configs/"*defconfig | xargs -n1 -I{} basename {} | head -n1)
fi

pushd "$KERNEL"
make "${DEFCONFIG}"
# Make sure options are set even if defconfig is minimal
scripts/config --file .config -e KALLSYMS -e KALLSYMS_ALL -e KPROBES || true
yes "" | make olddefconfig

# Build
make -j"$(nproc)" ${EXTRA_MAKE_FLAGS:-}

# Collect artifact (Image.gz-dtb expected path may vary)
OUTDIR="$WORKDIR/out"
mkdir -p "$OUTDIR"
IMG="arch/arm64/boot/Image.gz-dtb"
if [ -f "$IMG" ]; then
  cp "$IMG" "$OUTDIR/"
else
  # Try common alternatives
  if [ -f "arch/arm64/boot/Image.gz" ] && [ -f "arch/arm64/boot/dtb.img" ]; then
    cat arch/arm64/boot/Image.gz arch/arm64/boot/dtb.img > "$OUTDIR/Image.gz-dtb"
  fi
fi
popd
