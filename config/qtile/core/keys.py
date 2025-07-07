# [[file:../../../Projects/dotfiles/config/qtile/README.org::*Keybindings][Keybindings:1]]
from libqtile.config import Key
from libqtile.lazy import lazy
import os

mod = "mod4"
terminal = "alacritty"
editor = "emacsclient -c -a 'vim'"

keys = [
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod, "shift"], "Return", lazy.spawn("/home/cgreid/.local/bin/dmenu_launch.sh"), desc="Launch dmenu"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch Terminal"),
    Key([mod, "shift"], "w", lazy.spawn("firefox"), desc="Launch Web Browser"),
    Key([mod], "e", lazy.spawn("thunar"), desc="Launch File Manager"),
    Key([mod], "Escape", lazy.spawn("~/.config/rofi/powermenu.sh"), desc="Power menu"),
    Key([mod, "shift"], "s", lazy.spawn("flameshot gui"), desc="Screenshot"),
    Key([mod, "shift"], "e", lazy.spawn(editor), desc="Doom Emacs"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "q", lazy.shutdown(), desc="Logout"),
    Key([mod], "h", lazy.layout.left(), desc="Focus left"),
    Key([mod], "l", lazy.layout.right(), desc="Focus right"),
    Key([mod], "j", lazy.layout.down(), desc="Focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Focus up"),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle layout"),
]
# Keybindings:1 ends here
