from typing import List, NamedTuple, Dict


class Monitor(NamedTuple):
    # Like [1,2,3]
    assigned_workspaces: List[int]
    # Like $MON_1
    variable_name: str
    is_primary: bool
    model: str


# Keyed on monitor interface like DP-1
MonitorMap = Dict[str, Monitor]


class Current_mode(NamedTuple):
    width: int
    height: int
    refresh: float


class Rect(NamedTuple):
    x: int
    y: int
    #  width: int
    #  height: int


class Swayoutput(NamedTuple):
    # e.g DP-1
    name: str
    # e.g HP E27q G4
    model: str
    current_mode: Current_mode
    # e.g 2
    scale: float
    # e.g normal, 270, 90
    transform: str
    rect: Rect


class SwayoutputDisabled(NamedTuple):
    name: str
    model: str
