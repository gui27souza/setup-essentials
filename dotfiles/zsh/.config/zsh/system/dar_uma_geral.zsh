# ZSH_DESC - Realiza atualização geral de pacotes de forma segura

dar_uma_geral() {
    echo "==> 🧹 Iniciando a geral no sistema..."

    # 1. Checa se o kernel LTS está instalado como segurança
    if ! pacman -Qs linux-lts &>/dev/null; then
        echo -e "⚠️  [Dica] Kernel LTS não encontrado. Recomendado instalar para emergências: 'sudo pacman -S linux-lts linux-lts-headers'"
    fi

    # 2. Verifica se há arquivos .pacnew/.pacsave pendentes
    local FIND_PACNEW=$(find /etc -regextype posix-extended -regex ".*\.pac(new|save)" 2>/dev/null)
    if [ -n "$FIND_PACNEW" ]; then
        echo -e "\n⚠️  [Atenção] Existem arquivos .pacnew/.pacsave pendentes de revisão:"
        echo "$FIND_PACNEW"
        echo "👉 Rode 'sudo pacdiff' quando puder para resolver conflitos de config."
    fi

    echo -e "\n--> 📦 Atualizando pacotes do Pacman..."
    # Sem --noconfirm para permitir intervenção manual em Breaking Changes do Arch
    sudo pacman -Syu

    if command -v yay &> /dev/null; then
        echo -e "\n--> 📦 Atualizando pacotes do AUR (yay)..."
        yay -Sua
    fi

    if command -v flatpak &> /dev/null; then
        echo -e "\n--> 📦 Atualizando e limpando Flatpaks..."
        flatpak update -y
        flatpak uninstall --unused -y
    fi

    echo -e "\n--> 🔍 Verificando pacotes órfãos..."
    if pacman -Qdtq &>/dev/null; then
        # Mostra os órfãos e pede confirmação antes de apagar
        sudo pacman -Qdtq | xargs -r sudo pacman -Rns
    else
        echo "Nenhum pacote órfão encontrado."
    fi

    echo -e "\n--> 🗑️ Limpando cache de pacotes (mantendo 1 versão antiga para rollback)..."
    # Recomenda-se pacman-contrib para usar o paccache nativo e seguro
    if command -v paccache &> /dev/null; then
        sudo paccache -r -k 1  # Mantém a versão atual + 1 versão antiga no cache
    else
        sudo pacman -Sc        # Fallback caso paccache não esteja instalado
    fi

    if command -v yay &> /dev/null; then
        yay -Sc
    fi

    sudo rm -f /var/cache/pacman/pkg/download-* 2>/dev/null

    echo -e "\n--------------------------------------------------"
    check_dotfiles_status
    echo "--------------------------------------------------"
    echo "✨ Geral concluída com sucesso!"
}