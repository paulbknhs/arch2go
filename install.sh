#!/usr/bin/env bash

CONFIG="$HOME/.config"
ZSH="$CONFIG/zsh"
NVIM="$CONFIG/nvim"
HYPR="$CONFIG/hypr"
WAYBAR="$CONFIG/waybar"
KITTY="$CONFIG/kitty"

# Dialog-Titel und Nachricht
TITLE="Installation Setup"
MSG="Wählen Sie die Pakete aus, die Sie installieren möchten:"

# Paketliste für die Installation
PACKAGES=(
	"base" "Basis-System" "on"
	"base-devel" "Entwicklungswerkzeuge" "on"
	"git" "Git Versionsverwaltung" "on"
	"curl" "Datenübertragungs-Tool" "on"
	"wget" "Datei-Downloader" "on"
	"zsh" "Z-Shell" "on"
	"lsd" "Modernes ls" "on"
	"fzf" "Fuzzy Finder" "on"
	"bat" "cat mit Syntax-Highlighting" "on"
	"hyprland" "Hyprland Wayland-Compositor" "on"
	"hyprpaper" "Wallpaper-Dienst für Hyprland" "on"
	"hyprlock" "Session-Lock für Hyprland" "on"
	"hyprshot" "Screenshot-Tool für Hyprland" "on"
	"hypridle" "Auto-Suspend für Hyprland" "on"
	"waybar" "Statusleiste für Hyprland" "on"
	"sddm" "Display-Manager" "on"
	"okular" "PDF-Betrachter" "on"
	"vlc" "Medienplayer" "on"
	"firefox" "Webbrowser" "on"
)

# Dialog-Auswahl erstellen
CHOICES=$(dialog --title "$TITLE" --separate-output --checklist "$MSG" 0 0 0 \
	"${PACKAGES[@]}" 2>&1 >/dev/tty)

# Dialogfenster löschen
clear

# Prüfen, ob der Benutzer Pakete ausgewählt hat
if [[ -z $CHOICES ]]; then
	echo "Keine Pakete ausgewählt. Installation wird abgebrochen."
	exit 1
fi

# System aktualisieren
echo "Aktualisiere System..."
sudo pacman --noconfirm -Syu

# Ausgewählte Pakete installieren
echo "Installiere gewählte Pakete..."
while IFS= read -r PACKAGE; do
	echo "Installiere $PACKAGE..."
	sudo pacman --noconfirm -S "$PACKAGE"
done <<<"$CHOICES"

# SDDM aktivieren, falls ausgewählt
if echo "$CHOICES" | grep -q "sddm"; then
	echo "Aktiviere SDDM..."
	sudo systemctl enable sddm
fi

# SSH-Schlüssel erstellen
echo "Erstelle SSH-Schlüssel..."
ssh-keygen -t ed25519 -q -N "" -f "$HOME/.ssh/id_ed25519"
echo "Fügen Sie den folgenden SSH-Schlüssel zu GitHub hinzu:"
cat "$HOME/.ssh/id_ed25519.pub"
read -n 1 -p "Drücken Sie RETURN, um fortzufahren."

# Konfigurationsordner erstellen und Repos klonen
echo "Richte Konfigurationen ein..."
mkdir -p "$CONFIG"
[[ -d $NVIM ]] || git clone https://github.com/paulbknhs/nvim.git "$NVIM"
[[ -d $HYPR ]] || git clone https://github.com/paulbknhs/hypr.git "$HYPR"
[[ -d $WAYBAR ]] || git clone https://github.com/paulbknhs/waybar.git "$WAYBAR"
[[ -d $KITTY ]] || git clone https://github.com/paulbknhs/kitty.git "$KITTY"
[[ -d $ZSH ]] || git clone https://github.com/paulbknhs/zsh.git "$ZSH"

sudo ln -sf "$ZSH"/rc.zsh "$HOME"/.zshrc
sudo ln -sf "$ZSH"/zsh_plugins.txt "$HOME"/.zsh_plugins.txt
sudo ln -sf "$ZSH"/.p10k.zsh "$HOME"/.p10k.zsh

# Git-Remote-URLs für Repos setzen
for DIR in "$NVIM" "$HYPR" "$WAYBAR" "$KITTY" "$ZSH"; do
	if [[ -d $DIR ]]; then
		cd "$DIR"
		git remote set-url origin --push "git@github.com:paulbknhs/$(basename $DIR).git"
	fi
done

# Shell auf Zsh umstellen
echo "Wechsle Standard-Shell zu Zsh..."
chsh -s "$(which zsh)" "$USER"

echo "Installation abgeschlossen!"
