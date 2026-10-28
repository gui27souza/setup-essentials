# ZSH_DESC - Realiza o setup do tuigreet usando o greetd base

ensure_command "ensure_package_pacman"
ensure_command "ensure_package_yay"

setup_tuigreet() {

    ensure_package_pacman greetd
    ensure_package_yay greetd-tuigreet

    sudo mkdir -p /etc/greetd /etc/tuigreet

    sudo tee /etc/greetd/config.toml > /dev/null <<- 'EOF'
	[terminal]
	vt = 1

	[default_session]
	command = "tuigreet --config /etc/tuigreet/config.toml"
	user = "greeter"
	EOF

    sudo cp "${SETUP_ESSENTIALS_DIR}/dotfiles/zsh/.config/zsh/greetd/tuigreet/tuigreet_config.toml" /etc/tuigreet/config.toml

    local active_dm
    active_dm=$(systemctl status display-manager.service 2>/dev/null | grep -oP '(?<=/)\w+(?=\.service)' | head -n1)
    
    if [[ -n "$active_dm" && "$active_dm" != "greetd" ]]; then
        echo "Desativando o display manager atual: $active_dm"
        sudo systemctl disable "$active_dm"
    fi

    sudo systemctl enable greetd
}
