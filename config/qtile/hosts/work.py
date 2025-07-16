# [[file:../../../Projects/dotfiles/config/qtile/README.org::*Host: Work][Host: Work:1]]
from libqtile import hook, layout
from libqtile.config import Group, Screen, Match, Key
from libqtile.lazy import lazy
from core.keys import keys
from core.layouts import layouts
from core.widgets import my_bar
import os, subprocess

groups = [Group(str(i)) for i in range(1, 10)]

group_screen_map = {
    '4': 1, '5': 1, '6': 1,
    '7': 0, '8': 0, '9': 0,
    '1': 2, '2': 2, '3': 2
}

for group in groups:
    keys.extend([
        Key(["mod4"], group.name, lazy.to_screen(group_screen_map[group.name]), lazy.group[group.name].toscreen(), desc=f"Switch to group {group.name}"),
        Key(["mod4", "shift"], group.name, lazy.window.togroup(group.name), desc=f"Send window to group {group.name}"),
    ])

screens = [
    Screen(top=my_bar(['7', '8', '9'])),
    Screen(top=my_bar(['4', '5', '6'], primary=True)),
    Screen(top=my_bar(['1', '2', '3'])),
]

floating_layout = layout.Floating(float_rules=[*layout.Floating.default_float_rules, Match(wm_class="Conky")])

@hook.subscribe.startup_complete
def startup_complete_hook():
    subprocess.call([os.path.expanduser('~/.config/qtile/autostart.sh')])
    print("Moving groups on startup")
    qtile.groups_map['1'].cmd_toscreen(0)
    qtile.groups_map['4'].cmd_toscreen(1)
    qtile.groups_map['7'].cmd_toscreen(2)
# Host: Work:1 ends here
