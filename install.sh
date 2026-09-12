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

echo "==> 3. Permissões de Scripts..."
chmod +x scripts/*.sh 2>/dev/null || true

echo "==> Setup concluído com sucesso!"
echo "Dica: Para configurar o boot UEFI nesta máquina hospedeira, execute:"
echo "  sudo ./scripts/setup-refind-boot.sh"