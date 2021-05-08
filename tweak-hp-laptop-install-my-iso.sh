#!/bin/bash
set -e
###################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

function installSublime() {
    curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
    echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
    sudo pacman -Sy --noconfirm --needed sublime-text
}

function installNvidiaDriversOptimusManager() {
	# Install nvidia-440xx drivers and Optimus Manager
	sudo pacman -S --noconfirm --needed linux510-nvidia-440xx nvidia-440xx-utils linux510-bbswitch lib32-virtualgl lib32-nvidia-440xx-utils xf86-video-nouveau 
	sudo pacman -S --noconfirm --needed optimus-manager 
	sudo systemctl enable optimus-manager.service
	yay -S --noconfirm optimus-manager-qt
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

function installVirtualBox() {
	sudo pacman -S --needed --noconfirm virtualbox linux56-virtualbox-host-modules
}

function setPeriodicTrim() {
	#Enable periodic trim
	sudo sed -i 's/,discard / /g' /etc/fstab
	sudo systemctl enable fstrim.timer
	sudo systemctl start fstrim.timer
}

function setSilentBoot() {
	#Remove fsck message
	sudo sed -i 's/ fsck/ /g' /etc/mkinitcpio.conf
	sudo mkinitcpio -p linux
}

#installSublime
installNvidiaDriversOptimusManager
setHardwareClock
installBlueToothDriver
installVirtualBox
setPeriodicTrim
setSilentBoot
