# SV6051-SV6051P-WiFi-driver-for-Amlogic-S905W-X96-Mini-with-DKMS-support.
Includes the critical SDIO timing fix (-DSDIO_USE_SLOW_CLOCK) discovered by @lukas-kuna. Based on the Armbian Rockchip kernel patches from the @ophub/amlogic-s9xxx-openwrt project.
# SV6051/SV6051P WiFi Driver for Amlogic S905W (X96 Mini)

This driver enables WiFi on devices with the **SV6051/SV6051P** chipset, such as the **X96 Mini** (Amlogic S905W). It is based on the Armbian Rockchip kernel patches from the **@ophub/amlogic-s9xxx-openwrt** project and includes the critical fix for SDIO timing issues discovered by **@lukas-kuna**.

## 📋 The Problem & The Fix

As discovered by [@lukas-kuna](https://github.com/lukas-kuna) in [this GitHub issue](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/743#issuecomment-4224730263), the SV6051 driver does work on Amlogic platforms, but the **SDIO bus clock speed** is the key issue.

- **The Problem**: The Meson MMC controller runs the SDIO bus at a frequency that causes timing errors (CRC errors, `EILSEQ (-84)`) with the SV6051 chip.
- **The Fix**: This repository compiles the driver with the **`-DSDIO_USE_SLOW_CLOCK`** flag, which forces the SDIO bus to a stable **25 MHz**, eliminating the errors.

## ✅ Features

- **Works on Amlogic S905W (X96 Mini)** and potentially other Amlogic devices.
- **Includes the SDIO Timing Fix** (`-DSDIO_USE_SLOW_CLOCK` flag).
- **DKMS Support**: The driver automatically rebuilds when you update your kernel.
- **One-Command Installation**: Install with a single script.
- **Self-Contained**: Can be installed offline without an internet connection.
- **Tested on**: Armbian OS v26.8.0 for Aml S905W running Linux 6.18.37-ophub.

## 📦 Downloads

The latest release is available here:
- **[ssv6051-20260702.tar.gz](https://github.com/rayhanorigin/SV6051-SV6051P-WiFi-driver-for-Amlogic-S905W-X96-Mini-with-DKMS-support/releases/latest)** - Complete driver package with DKMS support

## 🛠️ Requirements

- **System**: Ubuntu or Debian-based Armbian installation.
- **Tools**: `build-essential`, `dkms`,
- **Kernel**: Kernel with Headers installed (won't install without headers)
-**Headers** - Install headers using `armbian-config`, or apt
- **Architecture**: ARM64 (aarch64)

✅ Quick Installation

### Using the Release Package (Recommended)

```bash
# Download the latest release
wget https://github.com/rayhanorigin/SV6051-SV6051P-WiFi-driver-for-Amlogic-S905W-X96-Mini-with-DKMS-support/releases/download/1.0/ssv6051-20260702.tar.gz

# Extract
tar -xzf ssv6051-20260702.tar.gz
cd ssv6051-20260702

# Run the installer (as root)
sudo ./restore-ssv6051.sh
```

### From Source (if you cloned the repo)

```bash
git clone https://github.com/rayhanorigin/SV6051-SV6051P-WiFi-driver-for-Amlogic-S905W-X96-Mini-with-DKMS-support.git
cd SV6051-SV6051P-WiFi-driver-for-Amlogic-S905W-X96-Mini-with-DKMS-support
sudo ./restore-ssv6051.sh
```

## 🔧 Manual Installation (Offline)

If you prefer to install manually or don't have internet:

```bash
# 1. Extract the DKMS source
tar -xzf ssv6051-dkms-master-backup.tar.gz -C /usr/src

# 2. Add to DKMS
sudo dkms add -m ssv6051 -v 1.0

# 3. Build and install
sudo dkms build -m ssv6051 -v 1.0
sudo dkms install -m ssv6051 -v 1.0

# 4. Load the driver
sudo modprobe ssv6051

# 5. Verify
ip a show wlan0
```

## ⚡ Manual Installation (Without DKMS)
```bash
# 1. Go to the driver source
cd ssv6051-1.0

# 2. Compile the driver
make -j$(nproc)

# 3. Install the compiled module
sudo cp ssv6051.ko /lib/modules/$(uname -r)/kernel/drivers/net/wireless/
sudo depmod -a

# 4. Load the driver
sudo modprobe ssv6051
```
## 📊 Verification

After installation, verify the driver is working:

```bash
# Check if the module is loaded
lsmod | grep ssv6051

# Check WiFi interface
ip a show wlan0

# Scan for networks
sudo iw dev wlan0 scan | grep SSID:

# Connect to WiFi (example with nmcli)
sudo nmcli dev wifi connect "YOUR_SSID" password "YOUR_PASSWORD"
```

## 🙏 Credits

This work would not have been possible without the contributions of:

- **[ophub](https://github.com/ophub)** - Maintainer of the [amlogic-s9xxx-openwrt](https://github.com/ophub/amlogic-s9xxx-openwrt) project, which provided the foundation and Armbian Rockchip kernel patches.
- **[lukas-kuna](https://github.com/lukas-kuna)** - For identifying the SDIO timing issue and discovering that compiling with `-DSDIO_USE_SLOW_CLOCK` makes the driver work reliably on Amlogic devices.
- **The Armbian Community** - For testing, collaboration, and support.

> *"The main issue is the SDIO bus clock speed... the driver itself appears to be usable on Amlogic devices with only minimal adjustments."* — [@lukas-kuna](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/743#issuecomment-4224730263)

## 📚 References

- Original Issue: [Request: Armbian Server Build with Linux 4.4 for S905W (SV6051P Wi-Fi) #743](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/743)
- Discovery of the SDIO fix: [Comment by @lukas-kuna](https://github.com/ophub/amlogic-s9xxx-openwrt/issues/743#issuecomment-4224730263)
- Armbian Rockchip kernel patches: [armbian/build](https://github.com/armbian/build/tree/main/patch/kernel/archive/rockchip-6.19/patches.armbian)

## 📄 License

This project is open-source and available under the MIT License.

---

## 📝 Changelog

### v1.0 (2026-07-02)
- Initial release
- Tested on Armbian OS v26.8.0 for Aml S905W
- Kernel 6.18.37-ophub
- DKMS support for automatic kernel updates
- Includes `-DSDIO_USE_SLOW_CLOCK` SDIO timing fix
