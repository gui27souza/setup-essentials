# ZSH_DESC - Converte uma entrada de cor "R, G, B" (floats 0.0 a 1.0) para "#RRGGBB"

color_float_to_hex() {
    local input="$1"

    local cleaned="${input// /}"
    local -a parts=("${(@s:,:)cleaned}")

    if (( ${#parts[@]} != 3 )); then
        echo "Erro: formato inválido '${input}'. Use 'R, G, B' com 3 valores." >&2
        return 1
    fi

    local -a hex_channels=()
    local val

    for val in "${parts[@]}"; do
        if ! [[ "$val" =~ '^([01](\.[0-9]+)?|\.[0-9]+)$' ]] || (( val < 0.0 || val > 1.0 )); then
            echo "Erro: canal '${val}' fora do intervalo [0.0, 1.0]." >&2
            return 1
        fi

        hex_channels+=("$(printf "%02X" "$(printf "%.0f" $(( val * 255.0 )))")")
    done

    printf "#%s%s%s\n" "${hex_channels[1]}" "${hex_channels[2]}" "${hex_channels[3]}"
}