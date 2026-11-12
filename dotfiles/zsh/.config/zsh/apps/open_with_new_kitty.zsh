# ZSH_DESC - Abre o programa especificado em uma nova janela do kitty

open_with_new_kitty() {
    kitty -e $1 &|
}
