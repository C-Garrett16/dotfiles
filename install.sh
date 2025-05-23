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


echo "==> Detecting and installing GPU drivers..."
install_display_drivers() {
    if lspci | grep -qi nvidia; then
        echo "Detected NVIDIA GPU. Installing NVIDIA drivers..."
        sudo pacman -S --noconfirm nvidia nvidia-utils nvidia-settings
        sudo sed -i 's/GRUB_CMDLINE_LINUX="/GRUB_CMDLINE_LINUX="nvidia-drm.modeset=1 /' /etc/default/grub
        sudo grub-mkconfig -o /boot/grub/grub.cfg
    elif lspci | grep -qi amd; then
        echo "Detected AMD GPU. Installing AMD drivers..."
        sudo pacman -S --noconfirm xf86-video-amdgpu mesa
    elif lspci | grep -qi intel; then
        echo "Detected Intel GPU. Installing Intel drivers..."
        sudo pacman -S --noconfirm xf86-video-intel mesa
    else
        echo "No known GPU detected. Installing fallback VESA driver..."
        sudo pacman -S --noconfirm xf86-video-vesa
    fi
}

echo "==> Fixing LightDM config..."
fix_lightdm_config() {
    local LIGHTDM_CONF="/etc/lightdm/lightdm.conf"

    if [[ -f "$LIGHTDM_CONF" ]]; then
        # Ensure greeter-session is set to lightdm-gtk-greeter
        sudo sed -i 's/^#\?\s*greeter-session=.*/greeter-session=lightdm-gtk-greeter/' "$LIGHTDM_CONF"

        # Add it under [Seat:*] if it's not already there
        if ! grep -q '^greeter-session=lightdm-gtk-greeter' "$LIGHTDM_CONF"; then
            sudo sed -i '/^\[Seat:\*\]/a greeter-session=lightdm-gtk-greeter' "$LIGHTDM_CONF"
        fi
    fi
}



#read -p "Enter your desired username: " USERNAME
#read -p "Enter computer name: " HOSTNAME
DOTFILES=$HOME/Projects/dotfiles
CONFIG=$HOME/.config
LIGHTDM_CONF="/etc/lightdm/lightdm.conf"

#Check if Projects folder exists, if it doesn't create it.
if [[ ! -d "$DOTFILES" ]]; then
    echo "Creating Projects folder and setting permissions."
    git clone https://github.com/C-Garrett16/dotfiles.git ~/Projects/dotfiles
    echo "Dotfiles successfully cloned to $DOTFILES"
fi

# Detect distro and set package manager
if command -v pacman &>/dev/null; then
    PKG_MANAGER="pacman"
    INSTALL="sudo pacman -S --noconfirm"
    UPDATE="sudo pacman -Syu"
    PACKAGE_FILE="packages.arch"
elif command -v apt &>/dev/null; then
    PKG_MANAGER="apt"
    INSTALL="sudo apt install -y"
    UPDATE="sudo apt update && sudo apt upgrade -y"
    PACKAGE_FILE="packages.debian"
else
    echo "[!] Unsupported distro. Install manually."
    exit 1
fi

if [[ ! -f $PACKAGE_FILE ]]; then
    echo "Package list file $PACKAGE_FILE not found!"
    exit 1
fi

# This creates an array out of the contents of $PACKAGE_FILE and stores it into the PACKAGES Var.
mapfile -t PACKAGES < "$PACKAGE_FILE"

# Update system and install packages
eval $UPDATE
$INSTALL "${PACKAGES[@]}"

# Install YAY if not already.
if ! command -v yay &>/dev/null; then
    echo 'Installing yay AUR helper'
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
fi

# Install JetBrainsMono Nerd Font (Arch)
if [[ "$PKG_MANAGER" == "pacman" ]]; then
   echo "Installing JetBrainsMono Nerd Font..."
   yay -S ttf-jetbrains-mono-nerd
# Install JetBrainsMono Nerd Font (Ubuntu)
elif [[ "$PKG_MANAGER" == "apt" ]]; then
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
else
    echo "unsupported OS detected. Exiting"
    exit 1
fi

install_display_drivers

fix_lightdm_config


# Set up rclone remote if missing
#if ! rclone listremotes | grep -q "^gdrive:"; then
#    echo "[*] Configuring rclone remote 'gdrive'..."
#    rclone config create gdrive drive scope drive.file token "" config_is_local false
#    echo "[!] A browser window may open for Google authorization."
#fi

# Mount Google Drive
# mkdir -p ~/GoogleDrive
#if ! mount | grep -q "~/GoogleDrive"; then
#    echo "[*] Mounting gdrive to ~/GoogleDrive..."
#    rclone mount gdrive: ~/GoogleDrive --vfs-cache-mode writes &
#fi

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
link_dotfile "$DOTFILES/config/qtile" "$CONFIG/qtile"
link_dotfile "$DOTFILES/config/conky" "$CONFIG/conky"
link_dotfile "$DOTFILES/config/picom" "$CONFIG/picom"

# Ensure PATH and Starship prompt are configured in .zshrc
#if ! grep -q 'emacs/bin' "$HOME/.zshrc"; then
#    echo 'export PATH="$HOME/.config/emacs/bin:$PATH"' >> "$HOME/.zshrc"
#    echo "[*] Added Doom Emacs to PATH in .zshrc"
#fi

#if ! grep -q 'eval "\$(starship init zsh)"' "$HOME/.zshrc"; then
#    echo 'eval "$(starship init zsh)"' >> "$HOME/.zshrc"
#    echo "[*] Added Starship prompt initialization to .zshrc"
#fi

# Install Doom Emacs
if [ ! -d "$HOME/.config/emacs" ]; then
    echo "[*] Installing Doom Emacs..."
    git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.config/emacs"
    "$HOME/.config/emacs/bin/doom" install

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

echo "Cloning DT's wallpaper pack"
git clone https://gitlab.com/dwt1/wallpapers.git ~/Pictures/Wallpapers

echo "Cloning and building dmenu..."
git clone https://github.com/C-Garrett16/dmenu.git ~/Projects/dmenu
cd $HOME/Projects/dmenu
sudo make clean install

#Enable important things.
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

echo "exec qtile start" > $HOME/.xsession
echo "exec qtile start" > $HOME/.xinitrc


echo "[✓] Dotfiles installed. Doom synced. Restart your shell or run 'exec zsh' to enjoy."
sleep 3
echo "[*] Skipping LightDM auto-start to allow testing first"
sleep 3
echo "[*] To start LightDM manually, run: sudo systemctl start lightdm"
sleep 3
