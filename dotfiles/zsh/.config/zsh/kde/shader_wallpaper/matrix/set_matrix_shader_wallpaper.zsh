# ZSH_DESC - Define o MatrixCustom com a cor informada como shader wallpaper

set_matrix_shader_wallpaper() {

    local plugin_ui_dir="$HOME/.local/share/plasma/wallpapers/online.knowmad.shaderwallpaper/contents/ui"
    local shader_file="$SETUP_ESSENTIALS_DIR/kde/shaders/MatrixCustom.frag"

    # Lista de opções pre-existentes - azul, ciano, vermelho, verde, verde-agua, roxo, ambar, branco

    # Recebe valores em hex ou 3 valores (floats de 0 a 1; ou ints de 0 a 255)

    # Faz as devidas conversões se necessário

    # Com os valores convertidos, identificar a linha a ser alterada no MatrixCustom.frag

    local expectedPattern="#define RAIN_COLOR vec3"
    local tempColor="${1:-"1.0, .53, 0"}"

    echo $(grep -m 1 -i "#define RAIN_COLOR vec3(" $shader_file)
    sed -i "s/^$expectedPattern.*/$expectedPattern($tempColor)/" "$shader_file"

    # Atualizar wallpaper
    reload_current_shader_wallpaper
}
