# Sway monitor configer

This script enables you to save your monitor setup to a shell script.
This also includes setting up waybar, which requires some work because I use different configs for the primary monitors and the other monitors.

Note: setting up you monitors is not done here. See for example https://github.com/artizirk/wdisplays

This is essentially a code generator for swaymsg.

See `./generate_test.py` for example output of the script.

## Usage
```bash
./generate -h
usage: generate [-h] [-l] [-g monitor number]

optional arguments:
  -h, --help            show this help message and exit
  -l, --list            List monitors to pick as primary monitor
  -g monitor number, --generate monitor number
                        Pick primary monitor and the layout will be generated
```
