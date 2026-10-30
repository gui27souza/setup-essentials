# ZSH_DESC - Garante que dado pacote esteja instalado pelo pacman, caso contrário, tenta instalar

ensure_package_pacman() {

    local package="$1"

    if ! pacman -Qi "$package" &> /dev/null; then
        echo "--> Pacote '$package' não encontrado no pacman. Instalando..."
        sudo pacman -S --noconfirm "$package"
    else
        echo "--> Pacote '$package' já está instalado no pacman."
    fi
}
