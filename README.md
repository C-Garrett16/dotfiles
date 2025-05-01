# Dotfiles Setup for Arch, Debian, and Ubuntu

Welcome to my personal dotfiles setup. This repo includes my:

- Zsh configuration with Starship prompt
- Alacritty terminal setup (Dracula-themed)
- Doom Emacs (in `~/.config/doom`)
- Flatpak and App support
- eza, bat, fzf, ripgrep, btop, etc.

This system is designed to:

- Be portable across Arch, Ubuntu, and Debian
- Automatically install missing dependencies
- Back up and replace any conflicting configs with symlinks
- Make me feel like a command-line warlock
- Catch and report script errors with helpful messages

---

## 🚀 Quick Start

1. **Clone the repo:**

```bash
git clone git@github.com:C-Garrett16/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
```

2. **Run the install script:**

```bash
chmod +x install.sh
./install.sh
```

---

## 🧩 What Gets Set Up

- `~/.zshrc` symlinked from repo
- `~/.config/alacritty` (with Dracula theme)
- `~/.config/starship.toml`
- `~/.config/doom` (Doom Emacs config)
- `~/.config/emacs` (Doom Emacs installation)
- Emacs server added to autostart as a background daemon
- Optional packages installed with Pacman or APT
- Zsh set as the default shell

---

## 📦 Packages Installed

- zsh
- alacritty
- git
- unzip, wget, curl
- starship
- eza
- bat
- fzf
- ripgrep
- btop
- fuse3 (for rclone mount)
- flatpak

---

## ☁️ Google Drive Integration

Rclone is configured to mount `gdrive:` to `~/GoogleDrive` using `--vfs-cache-mode writes`. Your Obsidian vault and optionally your `org/` directory (for Doom Emacs) live here.

---

## ⚠️ Error Handling

The `install.sh` script includes built-in error trapping:

- Reports which command failed
- Shows the line number and exit code
- Prevents silent failures

This makes it easy to debug issues during setup.

---

## ⚙️ System Requirements

- Arch, Ubuntu, or Debian-based system
- Network connection
- GitHub SSH key set up (for cloning private repos)

---

## ❓ Questions / Tweaks

This setup is designed for nerds who know how to fork and tweak. If that’s you: go nuts.

Otherwise, shoot me a PR or open an issue and I’ll pretend I’m going to fix it.
