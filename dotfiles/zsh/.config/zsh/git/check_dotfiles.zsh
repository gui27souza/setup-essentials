# ZSH_DESC - Verifica se há mudanças não commitadas no repositório

check_dotfiles_status() {
    local DOTFILES_DIR="$HOME/projetos-git/setup-essentials"
    if [ -d "$DOTFILES_DIR/.git" ]; then
        if [ -n "$(git -C "$DOTFILES_DIR" status --porcelain 2>/dev/null)" ]; then
            echo -e "\033[0;33m⚠️  [Dotfiles] Há alterações pendentes no repositório!\033[0m"
            echo -e "\033[0;36m👉 Rode 'sync_dotfiles' para atualizar o repositório remoto.\033[0m"
        else
            echo -e "\033[0;32m✅ [Dotfiles] Repositório sincronizado e atualizado.\033[0m"
        fi
    fi
}