from libqtile import bar, layout, widget, hook
from libqtile.config import Key, Group, Screen, Match
from libqtile.lazy import lazy
import os
import subprocess

mod = "mod4"
terminal = "alacritty"
rofi_launcher = "rofi -show drun -theme dracula"
editor = "emacsclient -c -a 'vim'"

keys = [
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch Terminal"),
    Key([mod, "shift"], "Return", lazy.spawn("/home/cgreid/Projects/dotfiles/config/qtile/scripts/dracula_dmenu.sh"), desc="Launch dmenu"),
    Key([mod, "shift"], "w", lazy.spawn("firefox"), desc="Launch Web Browser"),
    Key([mod], "e", lazy.spawn("thunar"), desc="Launch File Manager"),
    Key([mod], "Escape", lazy.spawn("/home/cgreid/.config/rofi/powermenu.sh"), desc="Power menu"),
    Key(
    [mod], "q",
    lazy.function(
        lambda qtile: (
            qtile.current_window.kill()
            if qtile.current_window and "Conky" not in qtile.current_window.get_wm_class()
            else None
        )
    ),
    desc="Kill window unless it's Conky"),
    Key([mod, "shift"], "q", lazy.shutdown(), desc="Logout of Qtile"),
    Key([mod], "h", lazy.layout.left(), desc="Move focus left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle layouts"),
    Key([mod, "shift"], "s", lazy.spawn("flameshot gui"), desc="Flameshot - Screenshot utility"),
    Key([mod, "shift"], "e", lazy.spawn(editor), desc="Doom Emacs"),
]

# Define workspaces
groups = [Group(i) for i in "12345"] + [Group(i) for i in "6789"]

for i in groups:
    keys.extend([
        # Switch to workspace
        Key([mod], i.name, lazy.group[i.name].toscreen(toggle=True), desc=f"Switch to group {i.name}"),

        # Move window to workspace
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name), desc=f"Move window to group {i.name}"),
    ])

layouts = [
    layout.MonadTall(
        margin=10,
        border_focus="#bd93f9",
        border_width=2,
    ),
    layout.Columns(border_focus="#bd93f9", margin=4),
    layout.Max(),
]

widget_defaults = dict(
    font="JetBrainsMono Nerd Font",
    fontsize=13,
    padding=3,
)
extension_defaults = widget_defaults.copy()

def my_bar(primary=False):
    widgets = [
        widget.GroupBox(
            highlight_method="block",
            rounded=False,
            active="#f8f8f2",
            inactive="#6272a4",
            highlight_color=["#282a36", "#44475a"],
            this_current_screen_border="#bd93f9",
            other_current_screen_border="#50fa7b",
        ),
        widget.Prompt(),
        widget.WindowName(),
    ]

    if primary:
        widgets.extend([
            widget.Memory(format='Mem: {MemUsed: .0f}M', foreground="#ff79c6"),
            widget.CPU(format='CPU: {load_percent}%', foreground="#50fa7b"),
            widget.DF(partition='/', format='Disk: {uf} free', foreground="#8be9fd"),
            widget.Systray(),
        ])

    widgets.append(widget.Clock(format='%a %b %d, %I:%M %p', foreground="#f1fa8c"))

    return bar.Bar(
        widgets,
        38,  # << chonky bar height
        margin=[15, 20, 5, 20],  # << floating look
        border_width=2,
        border_color="#44475a",
        background="#282a36",
    )

def init_screens():
    return [
        Screen(
            top=my_bar(primary=True),
        ),
        Screen(
            top=my_bar(primary=False),
        ),
    ]

screens = init_screens()

floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="Conky"),
    ]
)

@hook.subscribe.client_new
def disable_conky_borders(window):
    if window.match(wm_class="Conky"):
        window.togroup(qtile.groups[0].name)
        window.floating = True
        window.border_width = 0
        window.disable_floating()

@hook.subscribe.client_new
def ignore_conky(window):
    if window.window.get_wm_class() == ('Conky', 'Conky'):
        window.togroup(qtile.groups[0].name)
        window.floating = True
        window.border_width = 0
        window.disable_floating()
        window.set_property("QTILE_INTERNAL_NO_FOCUS", "1")

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.call([home])

    # Manually assign groups to screens
    qtile.groups_map['1'].cmd_toscreen(0)
    qtile.groups_map['4'].cmd_toscreen(1)

@hook.subscribe.screen_change
def restart_on_randr(ev) :
    lazy.restart()

dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
wl_input_rules = None
wmname = "LG3D"
