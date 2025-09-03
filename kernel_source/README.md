# Ubuntu Touch adaptation for the Lenovo Tab M10 FHD Plus (2nd Gen) (X606F/X606FA/X606X/X606XA)
The repository supports Lenovo Tab M10 FHD Plus tablet with MediaTek Helio P22T SoC, which may go under slightly different names in different countries and also referred as Lenovo TB-X606, where next letter is F for Wi-Fi-only and X for LTE-capable model.

This is based on Halium 9.0, and uses the mechanism described in [this page](https://github.com/ubports/porting-notes/wiki/GitLab-CI-builds-for-devices-based-on-halium_arm64-(Halium-9)).

This project can be built manually (see the instructions below) or you can download the ready-made artifacts from gitlab: take the [latest archive](https://gitlab.com/ubports/community-ports/android9/lenovo-tab-m10-fhd-plus/lenovo-x606/-/jobs/artifacts/master/download?job=devel-flashable), unpack the `artifacts.zip` file (make sure that all files are created inside a directory called `out/`, then follow the instructions in the [Install](#install) section.

## How to build
To manually build this project, follow these steps:

```bash
./build.sh -b bd  # bd is the name of the build directory
./build/prepare-fake-ota.sh out/device_x606.tar.xz ota
./build/system-image-from-ota.sh ota/ubuntu_command out
```

## Install
 1. Unlock the device bootloader following usual unlock procedure (enable Developer mode, turn on "OEM unlocking" option, then reboot to bootloader and execute `fastboot flashing unlock`
 2. Use SP FlashTool to downgrade the device to it's earliest Android 9 build (you may find the needed firmware achive [here](https://mirrors.lolinet.com/firmware/lenovo/Tab_M10_FHD_Plus_2nd_Gen/)). Make sure to select "**Download-only**" option, as "Format all and download" will erase important device-specific configuration like NVRAM partition.
 3. Check that stock Android still boots (may take a few minutes for the first start), then reboot to bootloader again and execute the following commands with files downloaded from "devel-flashable" job artifacts:
```bash
fastboot flash boot out/boot.img
fastboot flash system out/system.img
fastboot format:ext4 userdata
fastboot reboot
```

## Known issues
* Ubuntu UI toolkit shapes have a strange graphical glitch with a thin vertical line in the middle, which seems to be specific to PowerVR GPU used by device.
* Front camera may not work on devices shipped with Android 10 due to old kernel source code (Lenovo uploaded it only for device launch firmware). Need to ask Lenovo support to provide kernel source code that matches their Android 10 release.
