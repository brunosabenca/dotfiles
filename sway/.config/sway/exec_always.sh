#!/bin/sh

source ~/.config/dotfiles/bash_strict_mode.sh

~/.config/sway/wallpaper.sh &

#set previously used monitor layout
#lay.sh populates this file
echo "Running layout recreation"
sleep 3 #necessary to get consistent results
[ -f "$MONITOR_LAYOUT_FILE" ] && sh $(cat "$MONITOR_LAYOUT_FILE")
if [ "$?" -eq 0 ]; then
	notify-send "Monitor Layout" "Recreation succeded"
else
	notify-send "Monitor Layout" "Recreation failed"
fi
