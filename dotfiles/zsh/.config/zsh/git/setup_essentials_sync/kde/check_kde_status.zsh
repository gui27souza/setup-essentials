# ZSH_DESC - Verifica data de último sync das configs do KDE (não é diff real)

check_kde_status() {

    if command -v konsave &> /dev/null; then

        echo -e "\n--------------------------------------------------"
        echo -e "🎨 KDE Plasma Profile"

        local knsv_path="$SETUP_ESSENTIALS_DIR/kde/plasma-gui.knsv"

        if [ -f "$knsv_path" ]; then
            local last_mod=$(date -r "$knsv_path" "+%d/%m/%Y às %H:%M")
            echo -e "Último backup do KDE no repo: $last_mod"
            echo -e "💡 Rode 'sync_kde' para atualizar o repositório."
        else
            echo "$knsv_path não encontrado."
        fi
    fi
}
