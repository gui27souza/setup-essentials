# ZSH_DESC - Abre o programa especificado em uma nova janela do konsole

open_with_new_konsole() {
    konsole -e $1 &|
}
