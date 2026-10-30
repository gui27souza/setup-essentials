# ZSH_DESC - Verifica data de último sync das configs do KDE e alerta se houver mais de 5 dias sem backup

check_kde_status() {
    if command -v konsave &> /dev/null; then
        local SECONDS_PER_DAY=86400
        local MAX_DAYS_WITHOUT_SYNC=5
        local MAX_SYNC_AGE_SEC=$(( MAX_DAYS_WITHOUT_SYNC * SECONDS_PER_DAY ))

        log_neutral "🎨 KDE Plasma Profile"

        local knsv_path="$SETUP_ESSENTIALS_DIR/kde/plasma-gui.knsv"

        if [ -f "$knsv_path" ]; then
            local last_mod=$(date -r "$knsv_path" "+%d/%m/%Y às %H:%M")
            local last_mod_ts=$(date -r "$knsv_path" +%s)
            local now_ts=$(date +%s)
            local diff_sec=$(( now_ts - last_mod_ts ))

            if (( diff_sec > MAX_SYNC_AGE_SEC )); then
                local days_passed=$(( diff_sec / SECONDS_PER_DAY ))
                log_warn "\nÚltimo backup do KDE no repo: $last_mod"
                log_warn "\n⚠️ Atenção: O último backup do KDE foi há $days_passed dias!"
                log_obs "💡 Rode 'sync_kde' para atualizar o repositório."
            else
                log_success "\n✅ Último backup do KDE no repo: $last_mod"
            fi
        else
            log_error "$knsv_path não encontrado."
        fi
    fi
}