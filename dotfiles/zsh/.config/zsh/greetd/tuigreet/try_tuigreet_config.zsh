# ZSH_DESC - teste da configuração atual do tuigreet com mock (não seta o tuigreet)

try_tuigreet_config() {
    local config_path="${SETUP_ESSENTIALS_DIR}/dotfiles/zsh/.config/zsh/greetd/tuigreet/tuigreet_config.toml"

    # Escolha uma cor ANSI (ex: 40=Preto, 41=Vermelho, 42=Verde, 44=Azul, 45=Roxo, 46=Ciano)
    # Ou use códigos de 256 cores: \e[48;5;<COLOR_CODE>m
    local bg_color="\e[48;5;234m" # 234 é um cinza/grafite bem escuro elegante
    local reset="\e[0m"

    # Aplica a cor de fundo e limpa o terminal todo com ela
    printf "${bg_color}"
    clear

    # Roda a simulação
    tuigreet --config "$config_path" --mock

    # Restaura as cores padrão do terminal ao sair do mock
    printf "${reset}"
    clear
}