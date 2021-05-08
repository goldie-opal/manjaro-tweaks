#!/bin/bash
set -e
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

#sudo pacman -S --needed --noconfirm manjaro-tools-iso git
git clone https://gitlab.manjaro.org/profiles-and-settings/iso-profiles.git ~/iso-profiles
cp user-repos.conf ~/iso-profiles/community/cinnamon/
cat Packages-Desktop-extras >> ~/iso-profiles/community/cinnamon/Packages-Desktop
echo to build use: buildiso -f -p cinnamon -k linux510
