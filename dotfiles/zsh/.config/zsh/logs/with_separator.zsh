# ZSH_DESC - Roda dado comando com um separador visual, preservando os argumentos

with_separator() {
    echo -e "\n==="
    echo -e "\n--------------------------------------------------"
    "$@"
    echo "--------------------------------------------------"
}
