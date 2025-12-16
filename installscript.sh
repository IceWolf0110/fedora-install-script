#!/bin/bash

# Define the lines you want to add
line1="fastestmirror=True"
line2="install_weak_deps=False"

# Add the lines to the /etc/dnf/dnf.conf file if they don't already exist
grep -qxF "$line1" /etc/dnf/dnf.conf || sudo echo "$line1" >> /etc/dnf/dnf.conf
grep -qxF "$line2" /etc/dnf/dnf.conf || sudo echo "$line2" >> /etc/dnf/dnf.conf

echo "dnf.conf configured"

sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf update --refresh

sudo dnf install akmod-nvidia xorg-x11-drv-nvidia-cuda xorg-x11-drv-nvidia-power git ffmpeg compat-ffmpeg4 tuned-ppd fastfetch pipewire-pulse network-manager-applet NetworkManager-wifi
sudo sh -c 'echo "%_with_kmod_nvidia_open 1" > /etc/rpm/macros.nvidia-kmod'
sudo akmods --force --rebuild
sudo dracut --regenerate-all --force --verbose
echo "required packages installed"

sudo dnf install gnome-shell gnome-tweaks file-roller firefox unzip unrar p7zip gnome-backgrounds nautilus flatpak gnome-software gnome-control-center gnome-system-monitor gnome-text-editor ptyxis
echo "installed gnome"

sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
echo "enabled Flathub"

sudo systemctl set-default graphical
echo "enabled desktop mode"
