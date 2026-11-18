# ZSH_DESC - Converte uma entrada de cor "R, G, B" (ints 0 a 255) para "R.rrr, G.ggg, B.bbb"

color_int_to_float() {
    local input="$1"

    local cleaned="${input// /}"
    local -a parts=("${(@s:,:)cleaned}")

    if (( ${#parts[@]} != 3 )); then
        echo "Erro: formato inválido '${input}'. Use 'R, G, B' com 3 valores." >&2
        return 1
    fi

    local -a float_channels=()
    local val

    for val in "${parts[@]}"; do
        if ! [[ "$val" =~ '^[0-9]+$' ]] || (( val < 0 || val > 255 )); then
            echo "Erro: canal '${val}' fora do intervalo inteiro [0, 255]." >&2
            return 1
        fi

        float_channels+=("$(( val / 255.0 ))")
    done

    printf "%.3f, %.3f, %.3f\n" "${float_channels[1]}" "${float_channels[2]}" "${float_channels[3]}"
}
