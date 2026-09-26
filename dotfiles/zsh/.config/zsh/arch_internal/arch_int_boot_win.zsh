# ZSH_DESC - Reinicia o PC Principal com boot no Windows

arch_int_boot_win() {
    read "reply?Tem certeza que deseja reiniciar no Windows? [S/n] "
    case "$reply" in
        [nN][oO]|[nN])
            echo "Operação cancelada."
            return 1
            ;;
        *)
            sudo efibootmgr -n 0000 && sudo reboot
            ;;
    esac
}
