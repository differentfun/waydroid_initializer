#!/bin/bash

# Waydroid Installer Script with Menu
# Automatically exits on any error
set -e

# Function: Phase 1 - Pre-reboot installation
phase1_install() {
    echo "==> Step 1: Installing dependencies"
    sudo apt update
    sudo apt install -y curl ca-certificates ufw

    echo "==> Step 2: Adding Waydroid repository"
    curl -s https://repo.waydro.id | sudo bash

    echo "==> Step 3: Installing Waydroid and required kernel"
    sudo apt update
    sudo apt install -y waydroid weston linux-image-6.2.14-1-liquorix-amd64 linux-headers-6.2.14-1-liquorix-amd64

    echo "==> Step 4: Adding current user to weston-launch group"
    sudo usermod -aG weston-launch $USER

    echo "==> Step 5: Configuring UFW for Waydroid networking"
    sudo bash -c 'echo -e "\nnet/ipv4/ip_forward=1\nnet/ipv6/conf/default/forwarding=1" >> /etc/ufw/sysctl.conf'
    sudo ufw allow 67/udp
    sudo ufw allow 53
    sudo ufw default allow FORWARD
    sudo ufw reload

    echo -e "\n==> INSTALLATION COMPLETE (PHASE 1)."
    echo "Please REBOOT your system now."
    echo "After reboot, run this script again and choose option 2 to initialize Waydroid."
}

# Function: Phase 2 - Post-reboot initialization
phase2_initialize() {
    echo "==> Initializing Waydroid with GAPPS support"
    sudo waydroid init -f -s GAPPS
    echo "==> Initialization complete."
    echo "You can now start Waydroid using:"
    echo "   waydroid session start"
}

# Function: Show instructions to run Waydroid manually
show_run_instructions() {
    echo ""
    echo "To run Waydroid manually:"
    echo "1. Launch a Weston session (you can run 'weston' in a separate terminal or tty)."
    echo "2. Start the Waydroid container and session in background:"
    echo "   sudo waydroid container start &"
    echo "   sudo waydroid session start &"
    echo "3. In Weston, launch the Android UI with:"
    echo "   waydroid show-full-ui"
    echo ""
}

# Menu selection
echo "#############################################"
echo "#            WAYDROID INSTALL SCRIPT        #"
echo "#############################################"
echo ""
echo "1) Full installation (pre-reboot)"
echo "2) Initialize Waydroid (post-reboot)"
echo "3) Show how to run Waydroid manually"
echo "4) Exit"
echo ""
read -p "Select an option [1-4]: " choice

case $choice in
    1)
        phase1_install
        ;;
    2)
        phase2_initialize
        ;;
    3)
        show_run_instructions
        ;;
    4)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid option. Try again."
        exit 1
        ;;
esac
