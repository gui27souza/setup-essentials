# ZSH_DESC - Mostra updates pendentes e sincroniza lista de pacotes no repositório

# Mostra no terminal quantos updates estão esperando (sem baixar nem atualizar)
# e sincroniza a lista de pacotes instalados no repositório.

checar_geral() {

    echo -e ""

    if ! command -v checkupdates &> /dev/null; then
        echo -e "⚠️  Instale 'pacman-contrib' para usar essa checagem: sudo pacman -S pacman-contrib"
        return 1
    fi

    local repo_updates=$(checkupdates 2>/dev/null | wc -l)
    local aur_updates=0

    if command -v yay &> /dev/null; then
        aur_updates=$(yay -Qua 2>/dev/null | wc -l)
    fi

    local total_updates=$((repo_updates + aur_updates))

    if [ "$total_updates" -gt 0 ]; then
        echo -e "📦 \033[1;33m$total_updates atualizações pendentes\033[0m ($repo_updates oficial, $aur_updates AUR). (Rode 'dar_uma_geral' quando quiser)"
    else
        echo -e "✨ \033[1;32mSistema totalmente atualizado!\033[0m"
    fi

    # Sincroniza e verifica se há novos pacotes para adicionar aos pkg lists
    if command -v sync_pkglist &> /dev/null; then
        echo -e "\n--------------------------------------------------"
        sync_pkglist
    fi

    echo -e "\n--------------------------------------------------"
    check_dotfiles_status
    echo "--------------------------------------------------"
    echo "\n✨ Checagem geral concluída com sucesso!"
}