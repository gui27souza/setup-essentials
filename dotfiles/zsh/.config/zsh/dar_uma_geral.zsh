dar_uma_geral() {
    echo "==> 🧹 Iniciando a geral no sistema..."
    
    echo -e "\n--> 📦 Atualizando pacotes do Pacman..."
    sudo pacman -Syu --noconfirm

    if command -v yay &> /dev/null; then
        echo -e "\n--> 📦 Atualizando pacotes do AUR (yay)..."
        yay -Sua --noconfirm
    fi

    if command -v flatpak &> /dev/null; then
        echo -e "\n--> 📦 Atualizando e limpando Flatpaks..."
        flatpak update -y
        flatpak uninstall --unused -y
    fi

    echo -e "\n--> 🔍 Verificando e removendo pacotes órfãos..."
    if pacman -Qdtq &>/dev/null; then
        sudo pacman -Qdtq | xargs -r sudo pacman -Rns --noconfirm
    else
        echo "Nenhum pacote órfão encontrado."
    fi

    echo -e "\n--> 🗑️ Limpando cache de pacotes e arquivos residuais..."
    # Força a remoção de downloads corrompidos/incompletos antes de limpar o cache
    sudo rm -f /var/cache/pacman/pkg/download-*
    sudo pacman -Sc --noconfirm
    if command -v yay &> /dev/null; then
        yay -Sc --noconfirm
    fi

    echo -e "\n--------------------------------------------------"
    check_dotfiles_status
    echo "--------------------------------------------------"
    echo "✨ Geral concluída com sucesso!"
}