# ZSH_DESC - Exporta as configurações atuais do KDE Plasma via Konsave para o repositório

sync_kde() {
    if ! command -v konsave &> /dev/null; then
        echo "⚠️  Konsave não está instalado. Instale com: yay -S konsave"
        return 1
    fi

    # Caminho do repositório
    local repo_dir="$SETUP_ESSENTIALS_DIR"
    local target_file="$repo_dir/kde"

    if [ ! -d "$repo_dir/kde" ]; then
        mkdir -p "$repo_dir/kde"
    fi

    echo "🎨 Exportando perfil atual do KDE Plasma..."

    # Sobrescreve/Cria o perfil interno no Konsave e exporta para o repo
    konsave -s plasma-gui -f 2>/dev/null || konsave -s plasma-gui
    konsave -e plasma-gui -d "$target_file" -f 2>/dev/null || konsave -e plasma-gui -d "$target_file"

    echo "✅ Perfil atualizado com sucesso em: $target_file"
}