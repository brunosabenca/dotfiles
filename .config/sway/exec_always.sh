#!/bin/sh

source ~/.config/dotfiles/bash_strict_mode.sh

~/.config/sway/wallpaper.sh &

~/bin/scripts/configure-monitors

~/.config/waybar/waybar.sh
