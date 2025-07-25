# Waydroid Installer for MX Linux 23.6

A simple script to install and run [Waydroid](https://waydro.id) on MX Linux 23.6.  
Includes dependencies, Liquorix kernel, UFW configuration, and initialization steps.

Repository: [differentfun/waydroid_initializer](https://github.com/differentfun/waydroid_initializer)

## 📦 What It Does

- Installs required packages and dependencies  
- Adds the official Waydroid repository  
- Installs the Liquorix kernel (6.2.14) compatible with MX Linux  
- Configures UFW to enable network forwarding (DHCP and DNS ports)  
- Provides a two-stage installation process (pre‑reboot install and post‑reboot init)  
- Includes manual launch instructions for running Waydroid via Weston

## ⚙️ Requirements

- MX Linux 23.6 (based on Debian)  
- Internet connection  
- `sudo` privileges

## 🚀 How to Use

1. Clone this repository:

$ git clone https://github.com/differentfun/waydroid_initializer.git
$ cd waydroid_initializer
$ chmod +x installa_waydroid.sh
$ ./installa_waydroid.sh

- When prompted, choose 1 for installation (pre‑reboot)
- Reboot your system
- Run the script again and choose 2 for Waydroid initialization

Optionally, choose 3 in the script to display manual run instructions.

After installing the Liquorix kernel, reboot and verify with:
uname -r

Weston is used as the minimal Wayland compositor to display Android UI.
To launch Waydroid manually, follow instructions shown by selecting option 3, or use:

$ weston &

From Weston open the terminal and: 

$ sudo waydroid container start &
$ sudo waydroid session start &
$ waydroid show-full-ui

## ✅ Tested On
MX Linux 23.6 (64‑bit)
