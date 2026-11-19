# ZSH_DESC - Define o MatrixCustom com a cor informada como shader wallpaper

set_matrix_shader_wallpaper() {

    local shader_base="$SETUP_ESSENTIALS_DIR/kde/shaders/MatrixCustom.base.frag"
    local shader_file="$SETUP_ESSENTIALS_DIR/kde/shaders/MatrixCustom.frag"
    [[ -f "$shader_file" ]] || cp "$shader_base" "$shader_file"

    local inputColor="$1"

    local cleaned="${inputColor// /}"
    local -a parts=("${(@s:,:)cleaned}")

    if (( ${#parts[@]} != 3 )); then
        echo "Erro: formato inválido '${inputColor}'. Use 'R, G, B' com 3 valores." >&2
        return 1
    fi

    # TODO - Lista de opções pre-existentes - azul, ciano, vermelho, verde, verde-agua, roxo, ambar, branco

    # TODO - Recebe valores em hex ou 3 valores (floats de 0 a 1; ou ints de 0 a 255)
    # Faz as devidas conversões se necessário

    # Com os valores convertidos, identificar a linha a ser alterada no MatrixCustom.frag
    local expectedPattern="#define RAIN_COLOR vec3"
    sed -i "s/^$expectedPattern.*/$expectedPattern($inputColor)/" "$shader_file"

    # Atualizar wallpaper
    reload_current_shader_wallpaper

    local hex_color
    hex_color="$(color_float_to_hex "$inputColor")" || return 1

    plasma-apply-colorscheme --accent-color "$hex_color" BreezeDark > /dev/null
    sleep 0.1
    dbus-send --session --type=signal /KGlobalSettings org.kde.KGlobalSettings.notifyChange int32:0 int32:0
}
