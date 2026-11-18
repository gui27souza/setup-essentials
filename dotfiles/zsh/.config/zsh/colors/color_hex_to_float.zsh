# ZSH_DESC - Converte uma entrada de cor "#RRGGBB" ou "RRGGBB" para "R.rrr, G.ggg, B.bbb"

color_hex_to_float() {
    local hex="$1"

    if ! [[ "$hex" =~ '^#?[0-9A-Fa-f]{6}$' ]]; then
        echo "Erro: cor hexadecimal inválida '${hex}'. Use '#RRGGBB' ou 'RRGGBB'." >&2
        return 1
    fi

    hex="${hex#\#}"

    local r=$(( 16#${hex:0:2} / 255.0 ))
    local g=$(( 16#${hex:2:2} / 255.0 ))
    local b=$(( 16#${hex:4:2} / 255.0 ))

    printf "%.3f, %.3f, %.3f\n" $r $g $b
}