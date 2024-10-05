#!/bin/bash

# Main list of packages
packages=(
    "libxcb-randr0-dev"
    "libxcb-util-dev"
    "libxcb-icccm4-dev"
    "libxcb-cursor-dev"
    "libxcb-keysyms1-dev"
    "libxcb-res0-dev"
    "sxhkd"
    "suckless-tools"
    "polybar"
    "tilix"
    "kitty"
    "firefox-esr"
)

# Function to read common packages from a file
read_common_packages() {
    local common_file="$1"
    if [ -f "$common_file" ]; then
        packages+=( $(< "$common_file") )
    else
        echo "Common packages file not found: $common_file"
        exit 1
    fi
}

# Read common packages from file
read_common_packages "$HOME/bookworm-scripts/install_scripts/common_packages.txt"

# Function to install packages if they are not already installed
install_packages() {
    local pkgs=("$@")
    local missing_pkgs=()

    # Check if each package is installed
    for pkg in "${pkgs[@]}"; do
        if ! dpkg -l | grep -q " $pkg "; then
            missing_pkgs+=("$pkg")
        fi
    done

    # Install missing packages
    if [ ${#missing_pkgs[@]} -gt 0 ]; then
        echo "Installing missing packages: ${missing_pkgs[@]}"
        sudo apt update
        sudo apt install -y "${missing_pkgs[@]}"
        if [ $? -ne 0 ]; then
            echo "Failed to install some packages. Exiting."
            exit 1
        fi
    else
        echo "All required packages are already installed."
    fi
}

# Call function to install packages
install_packages "${packages[@]}"

sudo systemctl enable avahi-daemon
sudo systemctl enable acpid

xdg-user-dirs-update
mkdir ~/Screenshots/

cd ~/Downloads

git clone https://bitbucket.org/natemaia/dk.git
cd dk
make
sudo make install
mkdir -p ~/.config/dk
rm -rf ~/Downloads/dk

SCRIPT_DIR=~/bookworm-scripts
REPO_URL=https://github.com/drewgrif/dotfiles.git


\cp -r ~/bookworm-scripts/dotfiles/scripts/ ~
\cp -r ~/bookworm-scripts/dotfiles/.config/dk/ ~/.config/
\cp -r ~/bookworm-scripts/dotfiles/.config/polybar/ ~/.config/
\cp -r ~/bookworm-scripts/dotfiles/.config/backgrounds/ ~/.config/
\cp -r ~/bookworm-scripts/dotfiles/.config/picom/ ~/.config/
\cp -r ~/bookworm-scripts/dotfiles/.config/rofi/ ~/.config/
\cp -r ~/bookworm-scripts/dotfiles/.config/kitty/ ~/.config/
\cp -r ~/bookworm-scripts/dotfiles/.config/dunst/ ~/.config/

chmod +x ~/.config/dk/dkrc
chmod +x ~/.config/dk/polybar-dk

# FT-Labs picom and nerdfonts are installed
bash ~/bookworm-scripts/install_scripts/picom.sh
bash ~/bookworm-scripts/install_scripts/nerdfonts.sh

# adding gtk theme and icon theme
bash ~/bookworm-scripts/colorschemes/blue.sh

