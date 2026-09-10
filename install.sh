#!/bin/bash
set -e

echo "==> 1. Instalando Pacotes Oficiais e AUR..."
sudo pacman -S --needed - < pkglist.txt
if command -v yay &> /dev/null; then
    yay -S --needed - < pkglist-aur.txt
fi

echo "==> 2. Aplicando Dotfiles via GNU Stow..."
sudo pacman -S --needed stow
cd dotfiles
for app in */; do
    app_name="${app%/}"
    stow -D -t ~ "$app_name" 2>/dev/null || true
    stow -t ~ "$app_name"
done
cd ..

echo "==> 3. Configurando Scripts de Sistema e Hooks..."
sudo cp scripts/update-efi-kernel.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/update-efi-kernel.sh

sudo mkdir -p /etc/pacman.d/hooks
sudo cp system/pacman-hooks/*.hook /etc/pacman.d/hooks/

echo "==> Setup concluído com sucesso!"