# ZSH_DESC - Sincroniza estado do repositório local commitando no remoto após passar pelo Quality Gate

sync_dotfiles() {
    ensure_command "ensure_command"
    ensure_command "sync_pkglist"
    ensure_command "quality_gate"

    local DOTFILES_DIR="${SETUP_ESSENTIALS_DIR:-$HOME/.config/zsh/../../../..}"
    echo "==> 🚀 Sincronizando dotfiles..."

    # 1. Guardrail de Integridade: Executa o Quality Gate ANTES de qualquer coisa
    echo -e "\n--------------------------------------------------"
    if ! quality_gate; then
        echo "--------------------------------------------------"
        echo -e "❌ \033[1;31mSincronização abortada!\033[0m O Quality Gate encontrou erros que precisam ser corrigidos."
        return 1
    fi
    echo "--------------------------------------------------"

    # 2. Sincroniza listas de pacotes
    if command -v sync_pkglist &>/dev/null; then
        sync_pkglist
    fi

    cd "$DOTFILES_DIR" || return 1

    if [ -z "$(git status --porcelain)" ]; then
        echo "\n✨ Nenhuma alteração pendente detectada nos dotfiles."
        cd - > /dev/null
        return 0
    fi

    echo -e "\n--> 📤 Fazendo commit e push..."
    git add .
    git commit -m "chore(auto): backup dos dotfiles em $(date +'%Y-%m-%d %H:%M')"
    git push

    echo -e "\n==> ✨ Dotfiles sincronizados com o GitHub com sucesso!"
    cd - > /dev/null
}
