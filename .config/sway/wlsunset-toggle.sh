#!/usr/bin/bash
if pidof wlsunset; then
   killall -9 wlsunset
else
	exec wlsunset -l 55.6 -L 13.0 -t 2500 -g 0.8 -d 1
fi

