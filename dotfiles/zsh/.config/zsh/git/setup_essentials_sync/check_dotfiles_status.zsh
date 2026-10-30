# ZSH_DESC - Verifica se há mudanças não commitadas no repositório com tratamento defensivo de erros

check_dotfiles_status() {

    log_neutral "⚙️ Git Status setup-essentials"

    local dotfiles_dir="${SETUP_ESSENTIALS_DIR:-$HOME/.config/zsh/../../../..}"

    if [[ -z "$dotfiles_dir" || ! -d "$dotfiles_dir" ]]; then
        log_error "Erro: Diretório dos dotfiles não encontrado em '$dotfiles_dir'."
        return 1
    fi

    if ! command -v git &>/dev/null; then
        log_error "Erro: O comando 'git' não está instalado no sistema."
        return 1
    fi

    if ! git -C "$dotfiles_dir" rev-parse --is-inside-work-tree &>/dev/null; then
        log_error "Erro: '$dotfiles_dir' não é um repositório Git válido."
        return 1
    fi

    local status_output
    status_output=$(git -C "$dotfiles_dir" status --porcelain 2>/dev/null)

    if [[ -n "$status_output" ]]; then
        log_warn "\n⚠️  Há alterações pendentes no repositório!"
        log_obs "👉 Rode 'sync_dotfiles' para atualizar o repositório remoto.\n"
        log_neutral "Mudanças não commitadas:"
        setup_essentials_git_status
    else
        log_success "\n✅ Repositório sincronizado e atualizado."
    fi
}