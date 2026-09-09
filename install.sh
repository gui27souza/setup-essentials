#!/bin/bash
set -e

echo "==> Instalando scripts do sistema..."
sudo cp scripts/update-efi-kernel.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/update-efi-kernel.sh

echo "==> Instalando Pacman Hooks..."
sudo mkdir -p /etc/pacman.d/hooks
sudo cp system/pacman-hooks/*.hook /etc/pacman.d/hooks/

echo "==> Instalação de utilitários de sistema concluída com sucesso!"
