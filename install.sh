#!/usr/bin/env bash

set -eE -o functrace  # Exit on error and enable error tracing

# Function to trap and report errors
error_handler() {
    local exit_code=$?
    local line_no=$1
    echo "\n[✗] Error occurred at line $line_no. Exit code: $exit_code"
    echo "    → Command: ${BASH_COMMAND}"
    exit $exit_code
}

trap 'error_handler $LINENO' ERR

DOTFILES=~/Projects/dotfiles
CONFIG=$HOME/.config

# Detect the system's package manager and set appropriate commands
if command -v pacman &>/dev/null; then
    PKG_MANAGER="pacman"
    INSTALL="sudo pacman -S --noconfirm"
    UPDATE="sudo pacman -Syu"
elif command -v apt &>/dev/null; then
    PKG_MANAGER="apt"
    INSTALL="sudo apt install -y"
    UPDATE="sudo apt update && sudo apt upgrade -y"
else
    echo "[!] Unsupported distro. Install manually."
    exit 1
fi

# Function to backup existing files and create symlinks
link_dotfile() {
    local src=$1
    local dest=$2

    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        echo "[!] Backing up $dest -> $dest.backup.$(date +%s)"
        mv "$dest" "$dest.backup.$(date +%s)"
    fi

    echo "[*] Linking $dest -> $src"
    ln -sf "$src" "$dest"
}

# Update package list and install essential tools
$UPDATE
$INSTALL zsh git unzip wget curl starship alacritty eza bat fzf ripgrep btop fuse3 flatpak

# Link Starship config
link_dotfile "$DOTFILES/config/starship.toml" "$CONFIG/starship.toml"

# Link Alacritty config
link_dotfile "$DOTFILES/config/alacritty" "$CONFIG/alacritty"

# Link Zsh config
link_dotfile "$DOTFILES/.zshrc" "$HOME/.zshrc"

# Link Doom Emacs config
link_dotfile "$DOTFILES/config/doom" "$CONFIG/doom"

# Install Doom Emacs if not already installed
if [ ! -d "$HOME/.config/emacs" ]; then
    echo "[*] Installing Doom Emacs..."
    git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.config/emacs"
    "$HOME/.config/emacs/bin/doom" install --config "$CONFIG/doom" --yes

    # Create autostart entry for Emacs server
    mkdir -p ~/.config/autostart
    cat <<EOF > ~/.config/autostart/emacs-server.desktop
[Desktop Entry]
Type=Application
Exec=/usr/bin/emacs --daemon
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Emacs Server
Comment=Start Doom Emacs as a background server
EOF

    echo "[*] Emacs server autostart entry created."
fi

# Install Zinit for managing Zsh plugins
if [ ! -d "$HOME/.zinit" ]; then
    echo "[*] Installing zinit..."
    git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin
fi

# Set Zsh as the default shell
chsh -s $(which zsh)

# Finish message
echo "[✓] Dotfiles installed. Run 'doom sync' if needed. Then restart your shell or run 'exec zsh' to enjoy."
