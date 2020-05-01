#!/bin/bash
set -e
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

sudo pacman -S --needed --noconfirm manjaro-tools-iso git
git clone https://gitlab.manjaro.org/profiles-and-settings/iso-profiles.git ~/iso-profiles

