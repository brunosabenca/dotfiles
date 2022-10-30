#!/bin/bash

# Load ssh keys
ssh-add ~/.ssh/id_fourforty 2>&1 > /dev/null < /dev/null

# Automatically lock and turn off screen when idle
swayidle -w \
    before-sleep 'swaylockblur'

# Import Xdefaults
xrdb -load ~/.Xdefaults

# Notification manager
mako &

~/.config/sway/wlsunset-toggle.sh &

nm-applet --indicator &

# Clipboard manager
wl-paste -t text --watch clipman store --max-items=30 &
