# ZSH_DESC - Alterna a configuração de monitores no Hyprland ou KDE (primary|secondary|dual)

display_mode() {
    local MODE="$1"

    # Saídas identificadas via kscreen-doctor / hyprctl
    local MON_MAIN="DP-3"
    local MON_SEC="DP-2"

    # Perfis de resolução e taxa de atualização
    local RES_MAIN="2560x1440@180Hz"
    local RES_SEC="1920x1080@165Hz"

    if [[ -z "$MODE" ]]; then
        echo "Uso: display_mode [primary|secondary|dual]"
        return 1
    fi

    if [[ "$XDG_CURRENT_DESKTOP" == "Hyprland" ]]; then
        case "$MODE" in
            primary)
                hyprctl keyword monitor "$MON_MAIN, $RES_MAIN, 0x0, 1.25" > /dev/null
                hyprctl keyword monitor "$MON_SEC, disable" > /dev/null
                ;;
            secondary)
                hyprctl keyword monitor "$MON_MAIN, disable" > /dev/null
                hyprctl keyword monitor "$MON_SEC, $RES_SEC, 0x0, 1" > /dev/null
                ;;
            dual)
                hyprctl keyword monitor "$MON_SEC, $RES_SEC, 0x362, 1" > /dev/null
                hyprctl keyword monitor "$MON_MAIN, $RES_MAIN, 1920x0, 1.25" > /dev/null
                ;;
            *)
                echo "Modo inválido: $MODE. Use primary, secondary ou dual."
                return 1
                ;;
        esac
    elif [[ "$XDG_CURRENT_DESKTOP" == "KDE" ]]; then
        case "$MODE" in
            primary)
                kscreen-doctor output.$MON_MAIN.enable output.$MON_MAIN.mode.6 output.$MON_SEC.disable > /dev/null
                ;;
            secondary)
                kscreen-doctor output.$MON_MAIN.disable output.$MON_SEC.enable output.$MON_SEC.mode.54 > /dev/null
                ;;
            dual)
                kscreen-doctor output.$MON_SEC.enable output.$MON_SEC.mode.54 output.$MON_SEC.scale.1 output.$MON_SEC.position.0,362 \
                               output.$MON_MAIN.enable output.$MON_MAIN.mode.6 output.$MON_MAIN.scale.1.25 output.$MON_MAIN.position.1920,0 > /dev/null
                ;;
            *)
                echo "Modo inválido: $MODE. Use primary, secondary ou dual."
                return 1
                ;;
        esac
    else
        echo "Ambiente $XDG_CURRENT_DESKTOP não suportado pelo script."
        return 1
    fi
}

_display_mode() {
    local -a comandos
    comandos=(
        'primary:Ativa apenas o monitor principal (2K 180Hz)'
        'secondary:Ativa apenas o monitor secundário (1080p 165Hz)'
        'dual:Ativa ambos os monitores lado a lado'
    )
    _describe -t commands 'modos de exibição' comandos
}

compdef _display_mode display_mode