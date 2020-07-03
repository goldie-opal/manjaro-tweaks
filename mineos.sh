#!/bin/bash
set -e

pacman -Syu
pacman -S --noconfirm --needed git rsync rdiff-backup screen jre8-openjdk-headless nodejs-lts-dubnium npm base-devel openssh
# maybe nodejs-lts-erbium, jre-openjdk-headless
systemctl enable sshd.service
systemctl start sshd.service
mkdir -p /usr/games
cd /usr/games
git clone https://github.com/hexparrot/mineos-node.git minecraft
cd minecraft
git config core.filemode false
chmod +x service.js mineos_console.js generate-sslcert.sh webui.js
npm install --unsafe-perm
ln -s /usr/games/minecraft/mineos_console.js /usr/local/bin/mineos
cp mineos.conf /etc/mineos.conf
cp /usr/games/minecraft/init/systemd_conf /etc/systemd/system/mineos.service
systemctl enable mineos
cd /usr/games/minecraft
./generate-sslcert.sh
systemctl start mineos
