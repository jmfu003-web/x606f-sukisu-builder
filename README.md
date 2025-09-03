# x606f-sukisu-builder

一键云端编译 **Lenovo Tab M10 FHD Plus TB-X606F**（`achilles6_row_wifi`）内核并集成 **SukiSU Ultra**，自动打包为 **AnyKernel3** 可刷入包。

> ⚠️ 说明：本仓库提供自动化脚本与 CI 工作流；真正的编译发生在你的 GitHub Actions 或本地环境中。

## 快速开始（GitHub Actions）
1. 下载本仓库骨架，推到你自己的 GitHub 仓库。
2. 在 GitHub 仓库页面 → **Actions**，启用 Workflows。
3. 点击 **Run workflow**，可选自定义变量后启动。
4. 完成后到 **Actions → Artifacts** 下载 `AnyKernel3-sukisu-x606f.zip` 刷入设备。

## 本地构建
```bash
# 准备：Ubuntu 20.04/22.04，磁盘至少 20GB
sudo apt-get update
sudo apt-get -y install git bc bison flex libssl-dev make   gcc-aarch64-linux-gnu build-essential python3 rsync curl ccache unzip

# 拉仓库
git clone https://github.com/yourname/x606f-sukisu-builder.git
cd x606f-sukisu-builder

# 一键构建
bash build/build.sh
# 产物在 out/AnyKernel3-sukisu-x606f.zip
```

## 默认设置
- 内核源码：`https://github.com/MatiDEV-PL/kernel_lenovo_achilles6_row_wifi`（可通过环境变量自定义）
- SukiSU 仓库：`https://github.com/sukisu-ultra/sukisu-ultra`
- 工具链：默认下载 Google Clang `r416183b`（可切换为 AOSP/NDK clang）
- 目标：`arm64`，`Image.gz-dtb`
- 必要的内核配置：`CONFIG_KALLSYMS=y`、`CONFIG_KALLSYMS_ALL=y`、`CONFIG_KPROBES=y`
- 打包：AnyKernel3（已适配 TB-X606F boot 分区通用模板；如你的设备分区有差异请在 `build/ak3/anykernel.sh` 调整）

## 刷入提示
- **先解锁 BL**，并处理 **AVB/Verity**：
  ```bash
  fastboot --disable-verity --disable-verification flash vbmeta vbmeta.img
  ```
- 刷入方式：
  - **Recovery**：刷 `AnyKernel3-sukisu-x606f.zip`
  - **Fastboot**：`fastboot flash boot out/boot.img`（如果你用脚本重新打了 boot.img）

## 常见问题
- 如果编译失败，多半是：Kconfig/Makefile 挂接未成功、缺 `set_memory_*` 接口或旧核符号不全。可在 `build/scripts/patch_kernel.sh` 里按日志增补。
- 如果开机卡 LOGO：先尝试不启用额外特性（如 SUSFS/KPM），仅保留最小集成；确认 `kallsyms/kprobes` 是否启用。

---

**请务必备份原始 boot.img。操作有风险，后果需自负。**
