# ZSH_DESC - Sincroniza estado do repositório local commitando no remoto

sync_dotfiles() {
    local DOTFILES_DIR="$HOME/projetos-git/setup-essentials"
    echo "==> 🚀 Sincronizando dotfiles..."

    echo "--> Atualizando listas do Pacman/AUR..."
    pacman -Qent | awk '{print $1}' > "$DOTFILES_DIR/pkglist.txt"
    pacman -Qm | awk '{print $1}' > "$DOTFILES_DIR/pkglist-aur.txt"

    cd "$DOTFILES_DIR" || return

    if [ -z "$(git status --porcelain)" ]; then
        echo "Nenhuma alteração detectada nos dotfiles."
        cd - > /dev/null
        return
    fi

    echo "--> Fazendo commit e push..."
    git add .
    git commit -m "chore(auto): backup dos dotfiles em $(date +'%Y-%m-%d %H:%M')"
    git push

    echo "==> ✨ Dotfiles sincronizados com o GitHub!"
    cd - > /dev/null
}