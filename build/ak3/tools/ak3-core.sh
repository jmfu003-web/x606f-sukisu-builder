#!/bin/sh
# Placeholder for ak3-core.sh to make packaging work offline.
# In real flash environment, AnyKernel3 provides full ak3-core.sh.
# We embed only minimal bits used by our anykernel.sh here.

ui_print() { echo "$@"; }

# Minimal stubs (real AK3 has complex logic)
split_boot() { :; }
replace_kernel() { cp "$1" zImage || cp "$1" Image.gz-dtb || true; }
write_boot() { :; }
reset_ak() { :; }
device_check() { :; }
