#!/bin/bash
set -e
###################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################


function installNvidiaDriversOptimusManager() {
	# Install nvidia-440xx drivers and Optimus Manager
	sudo pacman -S --noconfirm --needed linux56-nvidia-440xx nvidia-440xx-utils linux56-bbswitch lib32-virtualgl lib32-nvidia-440xx-utils xf86-video-nouveau 
	sudo pacman -S --noconfirm --needed optimus-manager 
	yay -S --noconfirm optimus-manager-qt
	sudo systemctl enable optimus-manager.service
}

function setHardwareClock() {
	# Configure hw clock to use localtime for dual booting
	sudo timedatectl set-local-rtc 1 
	sudo hwclock --systohc --local
}

function installBlueToothDriver() {
	# Install headers and dkms
	sudo pacman -S --noconfirm --needed linux56-headers dkms
	# Install Bluetooth Driver 
	yay -S --noconfirm rtbth-dkms-git
	sudo touch /etc/modules-load.d/rtbth.conf
	sudo su -c 'echo -e "rtbth" > /etc/modules-load.d/rtbth.conf'
}

function applyTweaks() {
	yay -S --noconfirm youtube-dl-gui-git
}

function installVirtualBox() {
	sudo pacman -S --needed --noconfirm virtualbox linux56-virtualbox-host-modules
}


installSublime
installNvidiaDriversOptimusManager
setHardwareClock
installBlueToothDriver
applyTweaks
installVirtualBox
