#!/bin/bash
set -e
###################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

function addRepos() {
	sudo pacman-key -r 74F5DE85A506BF64
	sudo pacman-key --lsign-key 74F5DE85A506BF64
	sudo pacman-key --refresh-keys

	echo "Getting the latest arcolinux mirrors file"

	sudo pacman -S wget --noconfirm --needed
	sudo wget https://raw.githubusercontent.com/arcolinux/arcolinux-mirrorlist/master/etc/pacman.d/arcolinux-mirrorlist -O /etc/pacman.d/arcolinux-mirrorlist


echo '
[arcolinux_repo_3party]
SigLevel = Required DatabaseOptional
Include = /etc/pacman.d/arcolinux-mirrorlist

[arcolinux_repo_xlarge]
SigLevel = Required DatabaseOptional
Include = /etc/pacman.d/arcolinux-mirrorlist' | sudo tee --append /etc/pacman.conf

	sudo pacman -Syy
}

function installSublime() {
    curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg
    echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
    sudo pacman -Sy --noconfirm --needed sublime-text
}

function installNvidiaDriversOptimusManager() {
	# Install nvidia-440xx drivers and Optimus Manager
	sudo pacman -S --noconfirm --needed linux56-nvidia-440xx nvidia-440xx-utils linux56-bbswitch lib32-virtualgl lib32-nvidia-440xx-utils xf86-video-nouveau 

	if pacman -Qi "optimus-manager" &> /dev/null; then
		echo
	else
		sudo pacman -S --noconfirm --needed optimus-manager 
		yay -S --noconfirm optimus-manager-qt
		sudo systemctl enable optimus-manager.service
	fi	
}

function setHardwareClock() {
	# Configure hw clock to use localtime for dual booting
	sudo timedatectl set-local-rtc 1 
	sudo hwclock --systohc --local
}

function installBlueToothDriver() {
	# Install headers and dkms
	sudo pacman -S --noconfirm --needed linux56-headers dkms
	# Install Bluetooth Driver -  may be causing issues with latest kernels
	if pacman -Qi "rtbth-dkms-git" &> /dev/null; then
		echo
	else
		yay -S --noconfirm rtbth-dkms-git
		sudo touch /etc/modules-load.d/rtbth.conf
		sudo su -c 'echo -e "rtbth" > /etc/modules-load.d/rtbth.conf'
	fi

}

function applyTweaks() {
	# Fix dns issues during and after vpn connection
	sudo pacman -S --needed systemd-resolvconf 
	sudo pacman -S --needed --noconfirm vivaldi-widevine vivaldi-ffmpeg-codecs flashplugin pepper-flash vivaldi vlc  
	sudo pacman -S --needed --noconfirm qt5-translations aspell-en gimp-help-en hunspell-en_AU hyphen-en firefox-i18n-en-us hunspell-en_US
	yay -S --noconfirm youtube-dl-gui-git
	# Extra Network Manager VPN clients
	sudo pacman -S --needed --noconfirm networkmanager-fortisslvpn openfortivpn xl2tpd strongswan freerdp remmina
	yay -S --noconfirm networkmanager-l2tp

}

function Gaming() {
	sudo pacman -S --needed --noconfirm wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader wine-gecko wine-mono
	sudo pacman -S --needed --noconfirm lutris steam-native steam-manjaro
}

function installVirtualBox() {
	sudo pacman -S --needed --noconfirm virtualbox linux56-virtualbox-host-modules
}


addRepos
installSublime
installNvidiaDriversOptimusManager
setHardwareClock
installBlueToothDriver
applyTweaks
Gaming
installVirtualBox
