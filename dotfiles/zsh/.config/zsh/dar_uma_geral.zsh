# ZSH_DESC - Realiza atualização geral de pacotes de forma segura

dar_uma_geral() {
    echo "==> 🧹 Iniciando a geral no sistema..."

    # 1. Checa se o kernel LTS está instalado como segurança
    if ! pacman -Qs linux-lts &>/dev/null; then
        echo -e "⚠️  [Dica] Kernel LTS não encontrado. Recomendado instalar para emergências: 'sudo pacman -S linux-lts linux-lts-headers'"
    fi

    # 2. Verifica se há arquivos .pacnew pendentes de mesclagem
    local pacnews=$(pacman -Qtdq 2>/dev/null; FIND_PACNEW=$(find /etc -regextype posix-extended -regex ".*\.pac(new|save)" 2>/dev/null))
    if [ -n "$FIND_PACNEW" ]; then
        echo -e "\n⚠️  [Atenção] Existem arquivos .pacnew/.pacsave pendentes de revisão:"
        echo "$FIND_PACNEW"
        echo "👉 Rode 'sudo pacdiff' quando puder para resolver conflitos de config."
    fi

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

    echo -e "\n--> 🗑️ Limpando cache de pacotes (mantendo versões atuais para rollback)..."
    # Preserva pacotes instalados e remove apenas o cache antigo
    sudo pacman -Sc --noconfirm
    if command -v yay &> /dev/null; then
        yay -Sc --noconfirm
    fi
    # Remove arquivos de download temporários incompletos que sobraram
    sudo rm -f /var/cache/pacman/pkg/download-* 2>/dev/null

    echo -e "\n--------------------------------------------------"
    check_dotfiles_status
    echo "--------------------------------------------------"
    echo "✨ Geral concluída com sucesso!"
}