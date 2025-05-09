#!/usr/bin/env bash

# Check for optional flags
SYNC_DOOM=true
for arg in "$@"; do
    if [[ "$arg" == "--no-sync" ]]; then
        SYNC_DOOM=false
    fi
done

set -eE -o functrace

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

# Detect distro and set package manager
if command -v pacman &>/dev/null; then
    PKG_MANAGER="pacman"
    INSTALL="sudo pacman -S --noconfirm"
    UPDATE="sudo pacman -Syu"
    PACKAGES=(emacs zsh git unzip wget curl alacritty eza bat fzf ripgrep btop flatpak fonts-noto-color-emoji fonts-noto fonts-powerline)
elif command -v apt &>/dev/null; then
    PKG_MANAGER="apt"
    INSTALL="sudo apt install -y"
    UPDATE="sudo apt update && sudo apt upgrade -y"
    PACKAGES=(emacs zsh git unzip wget curl alacritty eza bat fzf ripgrep btop flatpak)
else
    echo "[!] Unsupported distro. Install manually."
    exit 1
fi

# Update system and install packages
eval $UPDATE
$INSTALL "${PACKAGES[@]}"

# Install JetBrainsMono Nerd Font (Ubuntu)
if [[ "$PKG_MANAGER" == "apt" ]]; then
    echo "[*] Installing JetBrainsMono Nerd Font..."
    mkdir -p ~/.local/share/fonts
    cd ~/.local/share/fonts
    wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
    unzip -o JetBrainsMono.zip > /dev/null
    rm JetBrainsMono.zip
    fc-cache -fv > /dev/null
    echo "[*] JetBrainsMono Nerd Font installed and font cache updated."

    echo "[*] Installing starship manually..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# Set up rclone remote if missing
if ! rclone listremotes | grep -q "^gdrive:"; then
    echo "[*] Configuring rclone remote 'gdrive'..."
    rclone config create gdrive drive scope drive.file token "" config_is_local false
    echo "[!] A browser window may open for Google authorization."
fi

# Mount Google Drive
mkdir -p ~/GoogleDrive
if ! mount | grep -q "~/GoogleDrive"; then
    echo "[*] Mounting gdrive to ~/GoogleDrive..."
    rclone mount gdrive: ~/GoogleDrive --vfs-cache-mode writes &
fi

# Link dotfiles
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

link_dotfile "$DOTFILES/config/starship.toml" "$CONFIG/starship.toml"
link_dotfile "$DOTFILES/config/alacritty" "$CONFIG/alacritty"
link_dotfile "$DOTFILES/.zshrc" "$HOME/.zshrc"
link_dotfile "$DOTFILES/config/doom" "$CONFIG/doom"

# Ensure PATH and Starship prompt are configured in .zshrc
if ! grep -q 'emacs/bin' "$HOME/.zshrc"; then
    echo 'export PATH="$HOME/.config/emacs/bin:$PATH"' >> "$HOME/.zshrc"
    echo "[*] Added Doom Emacs to PATH in .zshrc"
fi

if ! grep -q 'eval "\$(starship init zsh)"' "$HOME/.zshrc"; then
    echo 'eval "$(starship init zsh)"' >> "$HOME/.zshrc"
    echo "[*] Added Starship prompt initialization to .zshrc"
fi

# Install Doom Emacs
if [ ! -d "$HOME/.config/emacs" ]; then
    echo "[*] Installing Doom Emacs..."
    git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.config/emacs"
    "$HOME/.config/emacs/bin/doom" install --config "$CONFIG/doom" --yes

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

# Install Zinit
if [ ! -d "$HOME/.zinit" ]; then
    echo "[*] Installing zinit..."
    git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin
fi

# Set Zsh as default shell
chsh -s $(which zsh)

# Run Doom sync
if [[ "$SYNC_DOOM" == true ]] && command -v "$HOME/.config/emacs/bin/doom" &>/dev/null; then
    echo "[*] Running doom sync..."
    "$HOME/.config/emacs/bin/doom" sync
    echo "[*] Doom Emacs synced successfully."
fi

echo "[✓] Dotfiles installed. Doom synced. Restart your shell or run 'exec zsh' to enjoy."

