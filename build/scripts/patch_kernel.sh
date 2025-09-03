#!/usr/bin/env bash
set -euxo pipefail
WORKDIR="$GITHUB_WORKSPACE"
SRC="$WORKDIR/src"
KERNEL="$SRC/kernel"
SUKISU="$SRC/sukisu"

# Place SukiSU kernel side into drivers/sukisu (or external/ if you prefer)
mkdir -p "$KERNEL/drivers/sukisu"
# Many repos place kernel-side code under 'kernel' dir
if [ -d "$SUKISU/kernel" ]; then
  rsync -a --delete "$SUKISU/kernel/" "$KERNEL/drivers/sukisu/"
else
  # Fallback if layout changes: copy everything and filter in Makefile later
  rsync -a --delete "$SUKISU/" "$KERNEL/drivers/sukisu/"
fi

# Ensure Kconfig and Makefile hooks
if ! grep -q "sukisu" "$KERNEL/drivers/Makefile"; then
  echo 'obj-y += sukisu/' >> "$KERNEL/drivers/Makefile"
fi

if [ -f "$KERNEL/drivers/Kconfig" ] && ! grep -q "sukisu" "$KERNEL/drivers/Kconfig"; then
  echo 'source "drivers/sukisu/Kconfig"' >> "$KERNEL/drivers/Kconfig"
fi

# Defconfig tweaks
DEFCONFIG_FILE=""
# Try to guess a defconfig
if [ -z "${DEFCONFIG:-}" ]; then
  # pick the first *_defconfig under arch/arm64/configs
  DEFCONFIG_FILE=$(ls -1 "$KERNEL/arch/arm64/configs/"*defconfig | head -n1 || true)
else
  DEFCONFIG_FILE="$KERNEL/arch/arm64/configs/${DEFCONFIG}"
fi

if [ -n "$DEFCONFIG_FILE" ] && [ -f "$DEFCONFIG_FILE" ]; then
  # idempotent add
  grep -q '^CONFIG_KALLSYMS=y' "$DEFCONFIG_FILE" || echo 'CONFIG_KALLSYMS=y' >> "$DEFCONFIG_FILE"
  grep -q '^CONFIG_KALLSYMS_ALL=y' "$DEFCONFIG_FILE" || echo 'CONFIG_KALLSYMS_ALL=y' >> "$DEFCONFIG_FILE"
  grep -q '^CONFIG_KPROBES=y' "$DEFCONFIG_FILE" || echo 'CONFIG_KPROBES=y' >> "$DEFCONFIG_FILE"
  # Optional SukiSU symbols if provided
  grep -q '^CONFIG_KPM=y' "$DEFCONFIG_FILE" || echo '# CONFIG_KPM can be enabled if available' >> "$DEFCONFIG_FILE"
fi

# Header backports for <4.19 (best-effort placeholder)
INCLUDE="$KERNEL/include/linux"
if [ ! -f "$INCLUDE/set_memory.h" ]; then
  cat > "$INCLUDE/set_memory.h" << 'EOF'
/* Minimal placeholder for set_memory_* APIs for old kernels.
 * You may need to provide proper implementations/backports as per your kernel version.
 */
#ifndef _LINUX_SET_MEMORY_H
#define _LINUX_SET_MEMORY_H
static inline int set_memory_rw(unsigned long addr, int numpages) { return 0; }
static inline int set_memory_ro(unsigned long addr, int numpages) { return 0; }
static inline int set_memory_x(unsigned long addr, int numpages) { return 0; }
static inline int set_memory_nx(unsigned long addr, int numpages) { return 0; }
#endif
EOF
fi
