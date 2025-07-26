#!/bin/bash

# Waydroid Installer Script with Weston Compilation Support
set -e

# Phase 1 - Pre-reboot installation
phase1_install() {
    echo "==> Step 1: Installing base dependencies"
    sudo apt update
    sudo apt install -y curl ca-certificates ufw git meson ninja-build pkg-config \
        libdrm-dev libxkbcommon-dev libwayland-dev libegl1-mesa-dev libgles2-mesa-dev \
        libpam0g-dev libinput-dev libudev-dev libxcb-composite0-dev libxcb-xkb-dev \
        libxkbcommon-x11-dev libxcb-image0-dev libxcb-shm0-dev libpixman-1-dev \
        cmake wayland-protocols libcairo2-dev libjpeg-dev libwebp-dev libgbm-dev \
        libva-dev libx11-xcb-dev libxcursor-dev liblcms2-dev libcolord-dev \
        libpipewire-0.3-dev libpango1.0-dev libxml2-dev

    echo "==> Step 2: Adding Waydroid repository"
    curl -s https://repo.waydro.id | sudo bash

    echo "==> Step 3: Installing Waydroid and Liquorix kernel"
    sudo apt update
    sudo apt install -y waydroid linux-image-6.2.14-1-liquorix-amd64 linux-headers-6.2.14-1-liquorix-amd64

    echo "==> INSTALLATION COMPLETE (PHASE 1)"
    echo "Next: compile Weston by selecting option 2."
}

# Phase 2 - Compile and install Weston from source
compile_weston() {
    echo "==> Cloning Weston v9.0 source"
    git clone --branch 9.0 https://gitlab.freedesktop.org/wayland/weston.git ~/weston-build
    cd ~/weston-build

    echo "==> Configuring build with X11 backend enabled"
    meson setup build --prefix=/usr -Dlauncher-logind=false -Dsystemd=false \
        -Dremoting=false -Dbackend-rdp=false -Dpipewire=false -Dbackend-x11=true

    echo "==> Building Weston"
    ninja -C build

    echo "==> Installing Weston"
    sudo ninja -C build install

    echo "==> Adding weston-launch group and user"
    sudo groupadd -f weston-launch
    sudo usermod -aG weston-launch $USER

    echo "✅ Weston compiled and installed successfully."
    echo "Please reboot to apply group permissions."
}

# Phase 3 - Post-reboot initialization
phase3_initialize() {
    echo "==> Initializing Waydroid with GAPPS support"
    sudo waydroid init -f -s GAPPS
    echo "==> Initialization complete."
    echo "You can now start Waydroid using:"
    echo "   waydroid session start"
}

# Phase 4 - Manual instructions
show_run_instructions() {
    echo ""
    echo "To run Waydroid manually:"
    echo "1. Switch to a TTY (Ctrl+Alt+F3)"
    echo "2. Log in and run:"
    echo "   weston-launch"
    echo "3. Inside Weston terminal, run:"
    echo "   waydroid session start &"
    echo "   waydroid show-full-ui"
    echo ""
}

# Phase 5 - Cleanup (optional)
cleanup_weston() {
    echo "==> Removing compiled Weston"
    sudo rm -rf ~/weston-build
    sudo rm -f /usr/share/applications/start-weston-waydroid.desktop
    sudo rm -f /usr/local/bin/start_weston_waydroid.sh
    sudo apt remove --purge -y weston || true
    sudo apt autoremove --purge -y
    echo "✅ Weston removed."
}

# Menu
echo "#############################################"
echo "#         WAYDROID INSTALLER MENU           #"
echo "#############################################"
echo ""
echo "1) Full installation (pre-reboot)"
echo "2) Compile and install Weston (v9 with X11)"
echo "3) Initialize Waydroid (post-reboot)"
echo "4) Show manual launch instructions"
echo "5) Remove Weston build and launcher"
echo "6) Exit"
echo ""
read -p "Select an option [1-6]: " choice

case $choice in
    1)
        phase1_install
        ;;
    2)
        compile_weston
        ;;
    3)
        phase3_initialize
        ;;
    4)
        show_run_instructions
        ;;
    5)
        cleanup_weston
        ;;
    6)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid option. Try again."
        exit 1
        ;;
esac
