#!/bin/sh
# AnyKernel3 Ramdisk Mod Script
# Minimal template for TB-X606F (achilles6_row_wifi). Adjust if your partition layout differs.

## AnyKernel setup
SKIPMOUNT=false
PROPFILE=properties
POSTFSDATA=false
LATESTARTSERVICE=false

## Kernel string
kernelstring="SukiSU for TB-X606F"

## Import AnyKernel3 functions
. tools/ak3-core.sh

## Device Check (update if needed)
device_check
do.devicecheck=1
do.is_slot_device=0
# Rope in Lenovo naming; you can expand this list if your build uses other props.
reset_ak "TB-X606F" "Lenovo TB-X606F"

## Install
block=/dev/block/bootdevice/by-name/boot
ui_print "Patching boot image..."
split_boot
flash_dtbo=false
# Replace kernel
replace_kernel Image.gz-dtb
write_boot
ui_print "Done."
