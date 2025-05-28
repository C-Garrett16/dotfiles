# [[file:../../../Projects/dotfiles/config/qtile/README.org::*Layouts][Layouts:1]]
from libqtile import layout

layouts = [
    layout.MonadTall(margin=10, border_focus="#bd93f9", border_width=2),
    layout.Columns(border_focus="#bd93f9", margin=4),
    layout.Max(),
]
# Layouts:1 ends here
