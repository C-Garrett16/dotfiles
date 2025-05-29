# [[file:../../../Projects/dotfiles/config/qtile/README.org::*Host: Home][Host: Home:1]]
from libqtile import hook, layout
from libqtile.config import Group, Screen, Match, Key
from libqtile.lazy import lazy
from core.keys import keys
from core.layouts import layouts
from core.widgets import my_bar
import os, subprocess

groups = [Group(str(i)) for i in "123456789"]

for group in groups:
    keys.extend([
        Key(["mod4"], group.name, lazy.group[group.name].toscreen(toggle=True), desc=f"Switch to group {group.name}"),
        Key(["mod4", "shift"], group.name, lazy.window.togroup(group.name), desc=f"Send window to group {group.name}"),
    ])

screens = [
    Screen(top=my_bar(['1', '2', '3'], primary=True)),
    Screen(top=my_bar(['4', '5', '6'])),
]

floating_layout = layout.Floating(float_rules=[*layout.Floating.default_float_rules, Match(wm_class="Conky")])

@hook.subscribe.startup_once
def autostart():
    subprocess.call([os.path.expanduser('~/.config/qtile/autostart.sh')])
    qtile.groups_map['1'].cmd_toscreen(0)
    qtile.groups_map['4'].cmd_toscreen(1)
# Host: Home:1 ends here
