# ZSH_DESC - Verifica se há mudanças não commitadas no repositório

check_dotfiles_status() {
    local DOTFILES_DIR="$SETUP_ESSENTIALS_DIR"
    if [ -d "$DOTFILES_DIR/.git" ]; then
        if [ -n "$(git -C "$DOTFILES_DIR" status --porcelain 2>/dev/null)" ]; then
            log_warn "⚠️ [setup-essentials] Há alterações pendentes no repositório!\n"
            log_obs "👉 Rode 'sync_dotfiles' para atualizar o repositório remoto.\n"
            log_neutral "Mudanças não commitadas:"
            setup_essentials_git_status
        else
            log_success "✅ [setup-essentials] Repositório sincronizado e atualizado."
        fi
    fi
}