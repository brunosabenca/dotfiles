#!/bin/bash
#
source ~/.config/dotfiles/bash_strict_mode.sh

#used to get "config" function
source ~/bin/scripts/functions.sh

config submodule init
config submodule update
config pull
~/.config/dotfiles/install.sh
echo "Updated dotfiles from git repo and updated settings!"
