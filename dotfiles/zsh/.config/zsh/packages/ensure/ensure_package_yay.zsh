# ZSH_DESC - Garante que dado pacote esteja instalado pelo yay, caso contrário, tenta instalar

ensure_package_yay() {

    local package="$1"

    if ! yay -Qi "$package" &> /dev/null; then
        echo "--> Pacote '$package' não encontrado. Instalando..."
        yay -S --noconfirm "$package"
    else
        echo "--> Pacote '$package' já está instalado."
    fi
}
