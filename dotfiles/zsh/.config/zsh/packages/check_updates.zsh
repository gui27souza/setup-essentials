# ZSH_DESC - Checagem de atualizações de pacotes

check_updates() {

    if ! command -v checkupdates &> /dev/null; then
        log_warn "⚠️ Instale 'pacman-contrib' para usar essa checagem: sudo pacman -S pacman-contrib"
        return 1
    fi

    log_neutral "📦 Iniciando checagem de atualizações de pacotes...\n"

    local repo_updates=$(checkupdates 2>/dev/null | wc -l)
    local aur_updates=0

    if command -v yay &> /dev/null; then
        aur_updates=$(yay -Qua 2>/dev/null | wc -l)
    fi

    local total_updates=$((repo_updates + aur_updates))

    if [ "$total_updates" -gt 0 ]; then
        log_warn "$total_updates atualizações pendentes ($repo_updates oficial, $aur_updates AUR). (Rode 'dar_uma_geral' quando quiser)"
    else
        log_success "✅ Sistema totalmente atualizado!"
    fi
}