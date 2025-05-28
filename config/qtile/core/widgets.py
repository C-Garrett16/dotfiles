# [[file:../../../Projects/dotfiles/config/qtile/README.org::*Widgets and Bar][Widgets and Bar:1]]
from libqtile import bar, widget

widget_defaults = dict(
    font="JetBrainsMono Nerd Font",
    fontsize=13,
    padding=3,
)

def my_bar(groups, primary=False):
    widgets = [
        widget.GroupBox(visible_groups=groups,
                        highlight_method="block",
                        rounded=False,
                        active="#f8f8f2",
                        inactive="#6272a4",
                        highlight_color=["#282a36", "#44475a"],
                        this_current_screen_border="#bd93f9",
                        other_current_screen_border="#50fa7b",
                        disable_drag=True),
        widget.Prompt(),
        widget.WindowName(),
        widget.Clock(format='%a %b %d, %I:%M %p', foreground="#f1fa8c"),
    ]
    if primary:
        widgets.insert(3, widget.Systray())
        widgets.insert(3, widget.DF(partition='/', format='Disk: {uf} free', foreground="#8be9fd"))
        widgets.insert(3, widget.CPU(format='CPU: {load_percent}%', foreground="#50fa7b"))
        widgets.insert(3, widget.Memory(format='Mem: {MemUsed: .0f}M', foreground="#ff79c6"))
    return bar.Bar(widgets, 38, margin=[15, 20, 5, 20], border_width=2, border_color="#44475a", background="#282a36")
# Widgets and Bar:1 ends here
