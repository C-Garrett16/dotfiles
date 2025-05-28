# [[file:../../Projects/dotfiles/config/qtile/README.org::*Main Config][Main Config:1]]
import os
import socket

host = os.getenv("QTILE_HOST") or socket.gethostname()

if "work" in host:
    from hosts.work import *
elif "home" in host:
    from hosts.home import *
else:
    from hosts.default import *
# Main Config:1 ends here
