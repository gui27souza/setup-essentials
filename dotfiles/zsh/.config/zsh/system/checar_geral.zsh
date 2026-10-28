# ZSH_DESC - Mostra updates pendentes, sincroniza pacotes e roda testes de integridade do sistema

# Mostra no terminal quantos updates estão esperando (sem baixar nem atualizar),
# sincroniza a lista de pacotes instalados e valida as configs/módulos do repositório.

checar_geral() {

    if ! command -v checkupdates &> /dev/null; then
        log_warn "⚠️  Instale 'pacman-contrib' para usar essa checagem: sudo pacman -S pacman-contrib"
        return 1
    fi

    local repo_updates=$(checkupdates 2>/dev/null | wc -l)
    local aur_updates=0

    if command -v yay &> /dev/null; then
        aur_updates=$(yay -Qua 2>/dev/null | wc -l)
    fi

    local total_updates=$((repo_updates + aur_updates))

    if [ "$total_updates" -gt 0 ]; then
        with_separator log_warn "📦 $total_updates atualizações pendentes ($repo_updates oficial, $aur_updates AUR). (Rode 'dar_uma_geral' quando quiser)"
    else
        with_separator log_info "✨ Sistema totalmente atualizado!"
    fi

    with_separator sync_pkglist
    with_separator quality_gate
    with_separator check_kde_status
    with_separator check_dotfiles_status

    with_separator log_info "✨ Checagem geral concluída com sucesso!"

    echo -e ""
}
