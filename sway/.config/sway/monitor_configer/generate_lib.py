import math
from typing import List, Dict, Tuple, Generator, Sequence
import models


def divide_chunks(list: List[int], count: int) -> Generator[List[int], None, None]:
    for i in range(0, len(list), count):
        yield list[i : i + count]


def get_monitor_names(sway_outputs: Sequence[models.Swayoutput]) -> List[str]:
    monitor_names = []
    for monitor in sway_outputs:
        monitor_names.append(monitor.name)
    return monitor_names


def list_monitors(sway_outputs: Sequence[models.Swayoutput]):
    print("Use the number of your desired primary monitor as argument to the --generate command\n")
    counter = 1
    for monitor in sway_outputs:
        print("{}: {} ({})".format(counter, monitor.name, monitor.model))
        counter += 1


def get_workspaces_divided_per_monitor(monitor_count: int) -> List[List[int]]:
    workspaces = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    chunk_size = math.floor(len(workspaces) / monitor_count)

    # Check if our workspaces are evenly distributable on our monitors
    if len(workspaces) % monitor_count == 0:
        return list(divide_chunks(workspaces, chunk_size))
    else:
        monitor_desktop_chunks: List[List[int]] = []
        remains = len(workspaces) % monitor_count
        is_first_monitor_handled = False
        next = 0
        for i in range(0, monitor_count):
            if not is_first_monitor_handled:
                next = chunk_size + remains
                monitor_desktop_chunks.insert(i, workspaces[i:next])
                is_first_monitor_handled = True
            else:
                monitor_desktop_chunks.insert(i, workspaces[next : next + chunk_size])
                next = next + chunk_size

        return monitor_desktop_chunks


def monitor_assignments(monitors_map: models.MonitorMap, primary_monitor: str) -> List[str]:
    out = []
    for monitor_name, monitor in monitors_map.items():
        if monitor_name is primary_monitor:
            out.append(
                "{}={} # Model: '{}' This is your 'primary' monitor".format(
                    monitor.variable_name.replace("$", ""),
                    monitor_name,
                    monitor.model,
                )
            )
        else:
            out.append(
                "{}={} # Model: '{}'".format(
                    monitor.variable_name.replace("$", ""),
                    monitor_name,
                    monitor.model,
                ),
            )

    return out


def conf_outputs(
    sway_outputs: Sequence[models.Swayoutput],
    sway_outputs_disabled: Sequence[models.SwayoutputDisabled],
    monitor_variables_map: models.MonitorMap,
) -> List[str]:
    out = []
    for monitor in sway_outputs:
        out.append(
            " ".join(
                [
                    "swaymsg output {}".format(monitor_variables_map[monitor.name].variable_name),
                    "res {}x{}@{}hz".format(
                        monitor.current_mode.width,
                        monitor.current_mode.height,
                        monitor.current_mode.refresh,
                    ),
                    "scale {}".format(monitor.scale),
                    "transform {}".format(monitor.transform),
                    "pos {} {}".format(monitor.rect.x, monitor.rect.y),
                    "enable",
                ]
            )
        )

    for m in sway_outputs_disabled:
        out.append("swaymsg output {} disable".format(m.name))

    return out


def arrange_workspaces(monitor_map: models.MonitorMap) -> List[str]:
    out = []
    for monitor_name, monitor in monitor_map.items():
        for workspace in monitor.assigned_workspaces:
            out.append(
                f'swaymsg "workspace {workspace} output {monitor.variable_name}; workspace number {workspace}; move workspace to {monitor.variable_name}"'
            )
    # This makes it so that the first workspace on each monitor is focused
    out.reverse()
    return out


def waybar_monitors(monitor_map: models.MonitorMap) -> Tuple[List[str], List[str]]:
    out_primary_monitor = []
    out_aux_monitors = []
    for monitor_name, monitor in monitor_map.items():
        for workspace in monitor.assigned_workspaces:
            if monitor.is_primary:
                out_primary_monitor.append('"{}": ["{}"],'.format(workspace, monitor.variable_name))
            else:
                out_aux_monitors.append('"{}": ["{}"],'.format(workspace, monitor.variable_name))

    return (out_primary_monitor, out_aux_monitors)


def create_shell_variable(name: str, value: List[str]) -> str:
    return """{}=$(cat << EOF
{{
{}
}}
EOF
)
""".format(
        name, "\n".join(value)
    )


WAYBAR_CONFIG_FILE = "~/.config/waybar/config"
WAYBAR_PRIMARY_TEMPLATE = "~/.config/waybar/primary_conf_template"
WAYBAR_AUX_TEMPLATE = "~/.config/waybar/aux_conf_template"


def waybar(monitor_map: models.MonitorMap) -> List[str]:

    # Now we setup things for waybar
    # I want Waybar to have one type of bar layout for the primary monitor and another for the non-primary monitors(called aux monitors in the script)
    # We have ~/.config/waybar/primary_conf_template and ~/.config/waybar/aux_conf_template which are templates to create our final waybar config file
    primary_monitor_waybar_cfg, aux_monitors_waybar_cfg = waybar_monitors(monitor_map)

    primary_mon_variable = ""
    aux_mon_vars = []
    for monitor_name, monitor in monitor_map.items():
        if monitor.is_primary:
            primary_mon_variable = monitor.variable_name
            continue
        aux_mon_vars.append(monitor.variable_name)

    out = []
    primary_workspaces_var_name = "prim_waybar_persistent_workspaces"
    out.append(create_shell_variable(primary_workspaces_var_name, primary_monitor_waybar_cfg))

    if len(aux_mon_vars) > 0:
        aux_workspaces_var_name = "aux_waybar_persistent_workspaces"
        out.append(create_shell_variable(aux_workspaces_var_name, aux_monitors_waybar_cfg))

        out.append(
            f"""echo -e '[' > {WAYBAR_CONFIG_FILE}
jq '."sway\/workspaces".persistent_workspaces = '"${primary_workspaces_var_name}"' | ."output"= [ "'"{primary_mon_variable}"'" ]' {WAYBAR_PRIMARY_TEMPLATE} >> {WAYBAR_CONFIG_FILE}
echo -e ',' >> {WAYBAR_CONFIG_FILE}
jq '."sway\/workspaces".persistent_workspaces = '"${aux_workspaces_var_name}"' | ."output"= [ "'"{'''"'","'"'''.join(aux_mon_vars)}"'" ]' {WAYBAR_AUX_TEMPLATE} >> {WAYBAR_CONFIG_FILE}
echo -e ']' >> {WAYBAR_CONFIG_FILE}"""
        )
    else:
        out.append(
            f"""jq '."sway\/workspaces".persistent_workspaces = '"${primary_workspaces_var_name}"' | ."output"= [ "'"{primary_mon_variable}"'" ]' {WAYBAR_PRIMARY_TEMPLATE} > {WAYBAR_CONFIG_FILE}"""
        )

    return out


def create_monitor_map(sway_outputs: Sequence[models.Swayoutput], primary_monitor: str) -> models.MonitorMap:
    monitor_names = get_monitor_names(sway_outputs)

    monitor_desktop_chunks = get_workspaces_divided_per_monitor(len(monitor_names))
    monitor_map: Dict[str, models.Monitor] = {}

    def assign(output: models.Swayoutput, current_chunk: int):
        monitor_assigned_chunk = monitor_desktop_chunks[current_chunk]
        monitor_map[output.name] = models.Monitor(
            model=output.model,
            variable_name="$MON_{}".format(current_chunk),
            assigned_workspaces=monitor_assigned_chunk,
            is_primary=output.name is primary_monitor,
        )

    current_chunk_counter = 0
    # Handle primary monitor first because it needs to have $MON_0 variable
    for monitor in sway_outputs:
        if monitor.name is primary_monitor:
            assign(monitor, current_chunk_counter)
            current_chunk_counter += 1
            break

    # Then the others
    for monitor in sway_outputs:
        if monitor.name is not primary_monitor:
            assign(monitor, current_chunk_counter)
            current_chunk_counter += 1

    return monitor_map


def parse_sway_output(
    sway_outputs,
) -> Tuple[List[models.Swayoutput], List[models.SwayoutputDisabled]]:
    out = []
    disabled = []
    for monitor in sway_outputs:
        if monitor["active"]:
            out.append(
                models.Swayoutput(
                    name=monitor["name"],
                    model=monitor["model"],
                    current_mode=models.Current_mode(
                        width=monitor["current_mode"]["width"],
                        height=monitor["current_mode"]["height"],
                        refresh=monitor["current_mode"]["refresh"] / 1000,
                    ),
                    scale=monitor["scale"],
                    transform=monitor["transform"],
                    rect=models.Rect(
                        x=monitor["rect"]["x"],
                        y=monitor["rect"]["y"],
                    ),
                )
            )
        else:
            disabled.append(
                models.SwayoutputDisabled(
                    name=monitor["name"],
                    model=monitor["model"],
                )
            )

    return (out, disabled)


def generate(
    sway_outputs: Sequence[models.Swayoutput],
    sway_outputs_disabled: Sequence[models.SwayoutputDisabled],
    primary_monitor_number: int,
) -> str:
    monitor_names = get_monitor_names(sway_outputs)
    primary_monitor = monitor_names[primary_monitor_number - 1]
    monitor_map = create_monitor_map(sway_outputs, primary_monitor)

    out = []
    out.append("#!/bin/bash\n")
    out.append("set -euo pipefail\n")
    out.append("\n".join(monitor_assignments(monitor_map, primary_monitor)))
    out.append("")
    out.append("\n".join(arrange_workspaces(monitor_map)))
    out.append("")
    out.append("\n".join(conf_outputs(sway_outputs, sway_outputs_disabled, monitor_map)))
    out.append("")
    out.append("\n".join(waybar(monitor_map)))

    return "\n".join(out)
