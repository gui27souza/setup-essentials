#!/bin/bash
set -e

# Função para instalar pacotes
install_packages() {
    echo "==> Instalando Pacotes Oficiais e AUR..."
    sudo pacman -S --needed - < pkglist.txt
    if command -v yay &> /dev/null; then
        yay -S --needed - < pkglist-aur.txt
    else
        echo "⚠️  yay não encontrado! Pulando lista do AUR."
    fi
}

# Função para aplicar dotfiles via Stow
apply_dotfiles() {
    echo "==> Aplicando Dotfiles via GNU Stow..."
    sudo pacman -S --needed stow
    
    # Executa a partir da pasta dotfiles se ela existir no dir atual
    if [ -d "dotfiles" ]; then
        cd dotfiles
    fi

    for app in */; do
        [ -d "$app" ] || continue
        app_name="${app%/}"
        echo "   -> Linkando $app_name..."
        stow -D -t ~ "$app_name" 2>/dev/null || true
        stow -R -t ~ "$app_name"
    done
    
    cd - > /dev/null
}

echo "=== Arch Infrastructure Setup ==="
echo "1) Instalação Completa (Pacotes + Dotfiles)"
echo "2) Apenas Dotfiles (Ideal para Headless / Servidores)"
echo "3) Apenas Pacotes (Pacman + AUR)"
echo "4) Sair"
echo "================================="
read -rp "Escolha uma opção [1-4]: " option

case $option in
    1)
        install_packages
        apply_dotfiles
        ;;
    2)
        apply_dotfiles
        ;;
    3)
        install_packages
        ;;
    4)
        echo "Operação cancelada."
        exit 0
        ;;
    *)
        echo "Opção inválida!"
        exit 1
        ;;
esac

echo "==> Setup concluído com sucesso!"
