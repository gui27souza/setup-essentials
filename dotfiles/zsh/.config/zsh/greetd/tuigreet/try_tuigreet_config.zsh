# ZSH_DESC - teste da configuração atual do tuigreet com mock (não seta o tuigreet)

try_tuigreet_config() {

    local config_path="${SETUP_ESSENTIALS_DIR}/dotfiles/zsh/.config/zsh/greetd/tuigreet/tuigreet_config.toml"

    tuigreet --config "$config_path" --mock
}
