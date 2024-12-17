#!/usr/bin/env bash

CONFIG="$HOME/.config"
ZSH="$CONFIG/zsh"
NVIM="$CONFIG/nvim"
HYPR="$CONFIG/hypr"
WAYBAR="$CONFIG/waybar"
KITTY="$CONFIG/kitty"

sudo pacman --noconfirm -Syu
sudo pacman --noconfirm -S base base-devel git curl wget zsh lsd fzf bat hyprland hyprpaper waybar sddm okular

sudo systemctl enable sddm

# SSH
ssh-keygen -t ed25519
/bin/cat "$HOME/.ssh/id_ed25519.pub"
read -n 1 -p "Copy and add this ssh-key to Github! Press RETURN to continue."

mkdir -p "$HOME/.config"
[[ -d $NVIM ]] || git clone https://github.com/paulbknhs/nvim.git "$NVIM"
[[ -d $HYPR ]] || git clone https://github.com/paulbknhs/hypr.git "$HYPR"
[[ -d $WAYBAR ]] || git clone https://github.com/paulbknhs/waybar.git "$WAYBAR"
[[ -d $KITTY ]] || git clone https://github.com/paulbknhs/kitty.git "$KITTY"
[[ -d $ZSH ]] || git clone https://github.com/paulbknhs/zsh.git "$ZSH"

sudo ln -sf "$ZSH"/rc.zsh "$HOME"/.zshrc
sudo ln -sf "$ZSH"/zsh_plugins.txt "$HOME"/.zsh_plugins.txt

cd "$NVIM" && git remote set-url origin --push git@github.com:paulbknhs/nvim.git
cd "$HYPR" && git remote set-url origin --push git@github.com:paulbknhs/hypr.git
cd "$WAYBAR" && git remote set-url origin --push git@github.com:paulbknhs/waybar.git
cd "$KITTY" && git remote set-url origin --push git@github.com:paulbknhs/kitty.git
cd "$ZSH" && git remote set-url origin --push git@github.com:paulbknhs/zsh.git

chsh "$USER"
