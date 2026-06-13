#!/bin/bash

set -e

# Enable automatic yes if -y or --yes is passed
DNF_OPTS=""
if [[ "$1" == "-y" || "$1" == "--yes" ]]; then
    DNF_OPTS="-y"
fi

dnf_install() {
    sudo dnf install $DNF_OPTS "$@"
}

echo "Configuring dnf..."

line1="fastestmirror=True"
line2="install_weak_deps=False"

grep -qxF "$line1" /etc/dnf/dnf.conf || \
    echo "$line1" | sudo tee -a /etc/dnf/dnf.conf >/dev/null

grep -qxF "$line2" /etc/dnf/dnf.conf || \
    echo "$line2" | sudo tee -a /etc/dnf/dnf.conf >/dev/null

echo "dnf.conf configured"

echo "Installing RPM Fusion..."

dnf_install "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
dnf_install "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

echo "Updating system..."

sudo dnf update --refresh $DNF_OPTS

echo "Installing required packages..."

dnf_install \
    akmod-nvidia \
    xorg-x11-drv-nvidia-cuda \
    xorg-x11-drv-nvidia-power \
    git \
    ffmpeg \
    compat-ffmpeg4 \
    tuned-ppd \
    fastfetch \
    pipewire-pulse \
    network-manager-applet \
    NetworkManager-wifi \
    fcitx5-unikey \
    fcitx5-configtool \
    fcitx5-gtk \
    fcitx5-qt \
    fcitx5-autostart \
    fcitx5 \
    pipewire-jack-audio-connection-kit

sudo akmods --force --rebuild
sudo dracut --regenerate-all --force --verbose

echo "Required packages installed"

echo "Installing GNOME desktop..."

dnf_install \
    gnome-shell \
    gnome-tweaks \
    file-roller \
    firefox \
    unzip \
    unrar \
    p7zip \
    nautilus \
    flatpak \
    gnome-software \
    gnome-control-center \
    gnome-system-monitor \
    gnome-text-editor \
    ptyxis

echo "GNOME installed"

echo "Enabling Flathub..."

sudo flatpak remote-add --if-not-exists flathub \
    https://dl.flathub.org/repo/flathub.flatpakrepo

echo "Flathub enabled"

echo "Setting graphical target..."

sudo systemctl set-default graphical

echo "Desktop mode enabled"

echo "Setup complete."
echo "Reboot recommended."
