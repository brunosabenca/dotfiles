import json
import difflib
import generate_lib as lib
import models


def diff_strings(expected: str, got: str) -> str:
    return "\n".join(difflib.unified_diff(expected.split("\n"), got.split("\n"), fromfile="expected", tofile="got"))


mock_data = [
    models.Swayoutput(
        name="eDP-1",
        model="0x08DA",
        current_mode=models.Current_mode(width=1920, height=1080, refresh=60.0),
        scale=1.0,
        transform="normal",
        rect=models.Rect(x=0, y=1080),
    ),
    models.Swayoutput(
        name="HDMI-A-1",
        model="U2777B",
        current_mode=models.Current_mode(width=3840, height=2160, refresh=59.997),
        scale=1.5,
        transform="normal",
        rect=models.Rect(x=1920, y=0),
    ),
    models.Swayoutput(
        name="DP-8",
        model="BenQ GL2240",
        current_mode=models.Current_mode(width=1920, height=1080, refresh=60.0),
        scale=1.0,
        transform="normal",
        rect=models.Rect(x=0, y=0),
    ),
]
disabled_mock_data = [
    models.SwayoutputDisabled(name="DP-1", model="SOMETHING"),
]
mock_swaymsg_data = json.loads(
    """[
  {
    "id": 3,
    "name": "eDP-1",
    "rect": {
      "x": 0,
      "y": 1080,
      "width": 1920,
      "height": 1080
    },
    "focus": [
      98
    ],
    "border": "none",
    "current_border_width": 0,
    "layout": "output",
    "orientation": "none",
    "percent": 0.21428571428571427,
    "window_rect": {
      "x": 0,
      "y": 0,
      "width": 0,
      "height": 0
    },
    "deco_rect": {
      "x": 0,
      "y": 0,
      "width": 0,
      "height": 0
    },
    "geometry": {
      "x": 0,
      "y": 0,
      "width": 0,
      "height": 0
    },
    "window": null,
    "urgent": false,
    "marks": [
    ],
    "fullscreen_mode": 0,
    "nodes": [
    ],
    "floating_nodes": [
    ],
    "sticky": false,
    "type": "output",
    "active": true,
    "dpms": true,
    "primary": false,
    "make": "Unknown",
    "model": "0x08DA",
    "serial": "0x00000000",
    "scale": 1.0,
    "scale_filter": "nearest",
    "transform": "normal",
    "adaptive_sync_status": "disabled",
    "current_workspace": "8",
    "modes": [
      {
        "width": 1920,
        "height": 1080,
        "refresh": 40000
      },
      {
        "width": 1920,
        "height": 1080,
        "refresh": 60000
      }
    ],
    "current_mode": {
      "width": 1920,
      "height": 1080,
      "refresh": 60000
    },
    "max_render_time": 0,
    "focused": false,
    "subpixel_hinting": "unknown"
  },
  {
    "id": 155,
    "name": "HDMI-A-1",
    "rect": {
      "x": 1920,
      "y": 0,
      "width": 2560,
      "height": 1440
    },
    "focus": [
      202,
      185,
      146,
      18
    ],
    "border": "none",
    "current_border_width": 0,
    "layout": "output",
    "orientation": "none",
    "percent": 0.38095238095238093,
    "window_rect": {
      "x": 0,
      "y": 0,
      "width": 0,
      "height": 0
    },
    "deco_rect": {
      "x": 0,
      "y": 0,
      "width": 0,
      "height": 0
    },
    "geometry": {
      "x": 0,
      "y": 0,
      "width": 0,
      "height": 0
    },
    "window": null,
    "urgent": false,
    "marks": [
    ],
    "fullscreen_mode": 0,
    "nodes": [
    ],
    "floating_nodes": [
    ],
    "sticky": false,
    "type": "output",
    "active": true,
    "dpms": true,
    "primary": false,
    "make": "Unknown",
    "model": "U2777B",
    "serial": "0x00000EF0",
    "scale": 1.5,
    "scale_filter": "linear",
    "transform": "normal",
    "adaptive_sync_status": "disabled",
    "current_workspace": "4",
    "modes": [
      {
        "width": 720,
        "height": 400,
        "refresh": 70082
      },
      {
        "width": 640,
        "height": 480,
        "refresh": 59940
      },
      {
        "width": 640,
        "height": 480,
        "refresh": 59940
      },
      {
        "width": 640,
        "height": 480,
        "refresh": 60000
      },
      {
        "width": 640,
        "height": 480,
        "refresh": 66667
      },
      {
        "width": 640,
        "height": 480,
        "refresh": 72809
      },
      {
        "width": 640,
        "height": 480,
        "refresh": 75000
      },
      {
        "width": 720,
        "height": 480,
        "refresh": 59940
      },
      {
        "width": 720,
        "height": 480,
        "refresh": 59940
      },
      {
        "width": 720,
        "height": 480,
        "refresh": 60000
      },
      {
        "width": 720,
        "height": 480,
        "refresh": 60000
      },
      {
        "width": 720,
        "height": 576,
        "refresh": 50000
      },
      {
        "width": 800,
        "height": 600,
        "refresh": 60317
      },
      {
        "width": 800,
        "height": 600,
        "refresh": 75000
      },
      {
        "width": 1024,
        "height": 768,
        "refresh": 60004
      },
      {
        "width": 1024,
        "height": 768,
        "refresh": 75029
      },
      {
        "width": 1280,
        "height": 720,
        "refresh": 50000
      },
      {
        "width": 1280,
        "height": 720,
        "refresh": 59940
      },
      {
        "width": 1280,
        "height": 720,
        "refresh": 60000
      },
      {
        "width": 1280,
        "height": 720,
        "refresh": 60000
      },
      {
        "width": 1280,
        "height": 960,
        "refresh": 60000
      },
      {
        "width": 1440,
        "height": 900,
        "refresh": 59901
      },
      {
        "width": 1440,
        "height": 900,
        "refresh": 74984
      },
      {
        "width": 1280,
        "height": 1024,
        "refresh": 60020
      },
      {
        "width": 1280,
        "height": 1024,
        "refresh": 75025
      },
      {
        "width": 1680,
        "height": 1050,
        "refresh": 59883
      },
      {
        "width": 1920,
        "height": 1080,
        "refresh": 50000
      },
      {
        "width": 1920,
        "height": 1080,
        "refresh": 59940
      },
      {
        "width": 1920,
        "height": 1080,
        "refresh": 60000
      },
      {
        "width": 1920,
        "height": 1080,
        "refresh": 60000
      },
      {
        "width": 1920,
        "height": 2160,
        "refresh": 59988
      },
      {
        "width": 3840,
        "height": 2160,
        "refresh": 23976
      },
      {
        "width": 3840,
        "height": 2160,
        "refresh": 24000
      },
      {
        "width": 3840,
        "height": 2160,
        "refresh": 25000
      },
      {
        "width": 3840,
        "height": 2160,
        "refresh": 29981
      },
      {
        "width": 3840,
        "height": 2160,
        "refresh": 29970
      },
      {
        "width": 3840,
        "height": 2160,
        "refresh": 30000
      },
      {
        "width": 3840,
        "height": 2160,
        "refresh": 30000
      },
      {
        "width": 3840,
        "height": 2160,
        "refresh": 50000
      },
      {
        "width": 3840,
        "height": 2160,
        "refresh": 59940
      },
      {
        "width": 3840,
        "height": 2160,
        "refresh": 60000
      },
      {
        "width": 3840,
        "height": 2160,
        "refresh": 59997
      }
    ],
    "current_mode": {
      "width": 3840,
      "height": 2160,
      "refresh": 59997
    },
    "max_render_time": 0,
    "focused": true,
    "subpixel_hinting": "unknown"
  },
  {
    "id": 165,
    "name": "DP-8",
    "rect": {
      "x": 0,
      "y": 0,
      "width": 1920,
      "height": 1080
    },
    "focus": [
      182
    ],
    "border": "none",
    "current_border_width": 0,
    "layout": "output",
    "orientation": "none",
    "percent": 0.21428571428571427,
    "window_rect": {
      "x": 0,
      "y": 0,
      "width": 0,
      "height": 0
    },
    "deco_rect": {
      "x": 0,
      "y": 0,
      "width": 0,
      "height": 0
    },
    "geometry": {
      "x": 0,
      "y": 0,
      "width": 0,
      "height": 0
    },
    "window": null,
    "urgent": false,
    "marks": [
    ],
    "fullscreen_mode": 0,
    "nodes": [
    ],
    "floating_nodes": [
    ],
    "sticky": false,
    "type": "output",
    "active": true,
    "dpms": true,
    "primary": false,
    "make": "BenQ Corporation",
    "model": "BenQ GL2240",
    "serial": "XBA01138SL0",
    "scale": 1.0,
    "scale_filter": "nearest",
    "transform": "normal",
    "adaptive_sync_status": "disabled",
    "current_workspace": "5",
    "modes": [
      {
        "width": 720,
        "height": 400,
        "refresh": 70082
      },
      {
        "width": 640,
        "height": 480,
        "refresh": 59940
      },
      {
        "width": 640,
        "height": 480,
        "refresh": 75000
      },
      {
        "width": 800,
        "height": 600,
        "refresh": 60317
      },
      {
        "width": 800,
        "height": 600,
        "refresh": 75000
      },
      {
        "width": 832,
        "height": 624,
        "refresh": 74551
      },
      {
        "width": 1024,
        "height": 768,
        "refresh": 60004
      },
      {
        "width": 1024,
        "height": 768,
        "refresh": 75029
      },
      {
        "width": 1280,
        "height": 720,
        "refresh": 60000
      },
      {
        "width": 1152,
        "height": 864,
        "refresh": 75000
      },
      {
        "width": 1280,
        "height": 800,
        "refresh": 59810
      },
      {
        "width": 1280,
        "height": 960,
        "refresh": 60000
      },
      {
        "width": 1280,
        "height": 1024,
        "refresh": 60020
      },
      {
        "width": 1280,
        "height": 1024,
        "refresh": 75025
      },
      {
        "width": 1600,
        "height": 900,
        "refresh": 60000
      },
      {
        "width": 1680,
        "height": 1050,
        "refresh": 59954
      },
      {
        "width": 1920,
        "height": 1080,
        "refresh": 60000
      }
    ],
    "current_mode": {
      "width": 1920,
      "height": 1080,
      "refresh": 60000
    },
    "max_render_time": 0,
    "focused": false,
    "subpixel_hinting": "unknown"
  },
  {
    "type": "output",
    "name": "DP-1",
    "active": false,
    "dpms": false,
    "primary": false,
    "make": "Unknown",
    "model": "SOMETHING",
    "serial": "0x00000000",
    "modes": [
      {
        "width": 1920,
        "height": 1080,
        "refresh": 40000
      },
      {
        "width": 1920,
        "height": 1080,
        "refresh": 60000
      }
    ],
    "current_workspace": null,
    "rect": {
      "x": 0,
      "y": 0,
      "width": 0,
      "height": 0
    },
    "percent": null
  }
]"""
)


def test_create_shell_variable():
    got = lib.create_shell_variable("var_a", ["value_1"])
    expected = """var_a=$(cat << EOF
{
value_1
}
EOF
)
"""
    assert got == expected, "failed diff: {}".format(diff_strings(expected, got))
    got = lib.create_shell_variable("var_b", ["value_1", "value_2"])
    expected = """var_b=$(cat << EOF
{
value_1
value_2
}
EOF
)
"""
    assert got == expected, "failed diff: {}".format(diff_strings(expected, got))


def test_get_workspaces_divided_per_monitor():
    got = lib.get_workspaces_divided_per_monitor(2)
    assert got == [[1, 2, 3, 4, 5], [6, 7, 8, 9, 10]], "failed expected: {}".format(got)

    got = lib.get_workspaces_divided_per_monitor(3)
    assert got == [[1, 2, 3, 4], [5, 6, 7], [8, 9, 10]], "failed expected: {}".format(got)

    got = lib.get_workspaces_divided_per_monitor(4)
    assert got == [[1, 2, 3, 4], [5, 6], [7, 8], [9, 10]], "failed expected: {}".format(got)


def test_parse_sway_output():
    (got, got_disabled) = lib.parse_sway_output(mock_swaymsg_data)
    assert got == mock_data, f"failed got: {got}"
    assert got_disabled == disabled_mock_data, f"failed got: {got}"


def test_generate_1_monitor():
    got = lib.generate([mock_data[0]], disabled_mock_data, 0)
    expected = """#!/bin/bash

set -euo pipefail

MON_0=eDP-1 # Model: '0x08DA' This is your 'primary' monitor

swaymsg "workspace 10 output $MON_0; workspace number 10; move workspace to $MON_0"
swaymsg "workspace 9 output $MON_0; workspace number 9; move workspace to $MON_0"
swaymsg "workspace 8 output $MON_0; workspace number 8; move workspace to $MON_0"
swaymsg "workspace 7 output $MON_0; workspace number 7; move workspace to $MON_0"
swaymsg "workspace 6 output $MON_0; workspace number 6; move workspace to $MON_0"
swaymsg "workspace 5 output $MON_0; workspace number 5; move workspace to $MON_0"
swaymsg "workspace 4 output $MON_0; workspace number 4; move workspace to $MON_0"
swaymsg "workspace 3 output $MON_0; workspace number 3; move workspace to $MON_0"
swaymsg "workspace 2 output $MON_0; workspace number 2; move workspace to $MON_0"
swaymsg "workspace 1 output $MON_0; workspace number 1; move workspace to $MON_0"

swaymsg output $MON_0 res 1920x1080@60.0hz scale 1.0 transform normal pos 0 1080 enable
swaymsg output DP-1 disable

prim_waybar_persistent_workspaces=$(cat << EOF
{
"1": ["$MON_0"],
"2": ["$MON_0"],
"3": ["$MON_0"],
"4": ["$MON_0"],
"5": ["$MON_0"],
"6": ["$MON_0"],
"7": ["$MON_0"],
"8": ["$MON_0"],
"9": ["$MON_0"],
"10": ["$MON_0"],
}
EOF
)

jq '."sway\/workspaces".persistent_workspaces = '"$prim_waybar_persistent_workspaces"' | ."output"= [ "'"$MON_0"'" ]' ~/.config/waybar/primary_conf_template > ~/.config/waybar/config"""
    assert got == expected, "test with 1 monitor failed\n{}".format(diff_strings(expected, got))


def test_generate_2_monitors():
    got = lib.generate(mock_data[0:2], disabled_mock_data, 2)
    expected = """#!/bin/bash

set -euo pipefail

MON_0=HDMI-A-1 # Model: 'U2777B' This is your 'primary' monitor
MON_1=eDP-1 # Model: '0x08DA'

swaymsg "workspace 10 output $MON_1; workspace number 10; move workspace to $MON_1"
swaymsg "workspace 9 output $MON_1; workspace number 9; move workspace to $MON_1"
swaymsg "workspace 8 output $MON_1; workspace number 8; move workspace to $MON_1"
swaymsg "workspace 7 output $MON_1; workspace number 7; move workspace to $MON_1"
swaymsg "workspace 6 output $MON_1; workspace number 6; move workspace to $MON_1"
swaymsg "workspace 5 output $MON_0; workspace number 5; move workspace to $MON_0"
swaymsg "workspace 4 output $MON_0; workspace number 4; move workspace to $MON_0"
swaymsg "workspace 3 output $MON_0; workspace number 3; move workspace to $MON_0"
swaymsg "workspace 2 output $MON_0; workspace number 2; move workspace to $MON_0"
swaymsg "workspace 1 output $MON_0; workspace number 1; move workspace to $MON_0"

swaymsg output $MON_1 res 1920x1080@60.0hz scale 1.0 transform normal pos 0 1080 enable
swaymsg output $MON_0 res 3840x2160@59.997hz scale 1.5 transform normal pos 1920 0 enable
swaymsg output DP-1 disable

prim_waybar_persistent_workspaces=$(cat << EOF
{
"1": ["$MON_0"],
"2": ["$MON_0"],
"3": ["$MON_0"],
"4": ["$MON_0"],
"5": ["$MON_0"],
}
EOF
)

aux_waybar_persistent_workspaces=$(cat << EOF
{
"6": ["$MON_1"],
"7": ["$MON_1"],
"8": ["$MON_1"],
"9": ["$MON_1"],
"10": ["$MON_1"],
}
EOF
)

echo -e '[' > ~/.config/waybar/config
jq '."sway\/workspaces".persistent_workspaces = '"$prim_waybar_persistent_workspaces"' | ."output"= [ "'"$MON_0"'" ]' ~/.config/waybar/primary_conf_template >> ~/.config/waybar/config
echo -e ',' >> ~/.config/waybar/config
jq '."sway\/workspaces".persistent_workspaces = '"$aux_waybar_persistent_workspaces"' | ."output"= [ "'"$MON_1"'" ]' ~/.config/waybar/aux_conf_template >> ~/.config/waybar/config
echo -e ']' >> ~/.config/waybar/config"""

    assert got == expected, "test with 2 monitors failed\n{}".format(diff_strings(expected, got))


def test_generate_3_monitors():
    got = lib.generate(mock_data, [], 2)
    expected = """#!/bin/bash

set -euo pipefail

MON_0=HDMI-A-1 # Model: 'U2777B' This is your 'primary' monitor
MON_1=eDP-1 # Model: '0x08DA'
MON_2=DP-8 # Model: 'BenQ GL2240'

swaymsg "workspace 10 output $MON_2; workspace number 10; move workspace to $MON_2"
swaymsg "workspace 9 output $MON_2; workspace number 9; move workspace to $MON_2"
swaymsg "workspace 8 output $MON_2; workspace number 8; move workspace to $MON_2"
swaymsg "workspace 7 output $MON_1; workspace number 7; move workspace to $MON_1"
swaymsg "workspace 6 output $MON_1; workspace number 6; move workspace to $MON_1"
swaymsg "workspace 5 output $MON_1; workspace number 5; move workspace to $MON_1"
swaymsg "workspace 4 output $MON_0; workspace number 4; move workspace to $MON_0"
swaymsg "workspace 3 output $MON_0; workspace number 3; move workspace to $MON_0"
swaymsg "workspace 2 output $MON_0; workspace number 2; move workspace to $MON_0"
swaymsg "workspace 1 output $MON_0; workspace number 1; move workspace to $MON_0"

swaymsg output $MON_1 res 1920x1080@60.0hz scale 1.0 transform normal pos 0 1080 enable
swaymsg output $MON_0 res 3840x2160@59.997hz scale 1.5 transform normal pos 1920 0 enable
swaymsg output $MON_2 res 1920x1080@60.0hz scale 1.0 transform normal pos 0 0 enable

prim_waybar_persistent_workspaces=$(cat << EOF
{
"1": ["$MON_0"],
"2": ["$MON_0"],
"3": ["$MON_0"],
"4": ["$MON_0"],
}
EOF
)

aux_waybar_persistent_workspaces=$(cat << EOF
{
"5": ["$MON_1"],
"6": ["$MON_1"],
"7": ["$MON_1"],
"8": ["$MON_2"],
"9": ["$MON_2"],
"10": ["$MON_2"],
}
EOF
)

echo -e '[' > ~/.config/waybar/config
jq '."sway\/workspaces".persistent_workspaces = '"$prim_waybar_persistent_workspaces"' | ."output"= [ "'"$MON_0"'" ]' ~/.config/waybar/primary_conf_template >> ~/.config/waybar/config
echo -e ',' >> ~/.config/waybar/config
jq '."sway\/workspaces".persistent_workspaces = '"$aux_waybar_persistent_workspaces"' | ."output"= [ "'"$MON_1"'","'"$MON_2"'" ]' ~/.config/waybar/aux_conf_template >> ~/.config/waybar/config
echo -e ']' >> ~/.config/waybar/config"""

    assert got == expected, "test with 3 monitors failed\n{}".format(diff_strings(expected, got))


if __name__ == "__main__":
    test_create_shell_variable()
    test_get_workspaces_divided_per_monitor()
    test_parse_sway_output()
    test_generate_1_monitor()
    test_generate_2_monitors()
    test_generate_3_monitors()
    print("Everything passed")
