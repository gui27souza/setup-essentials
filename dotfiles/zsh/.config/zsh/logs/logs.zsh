# ZSH_DESC - Módulo especial com comandos de logs coloridos

log_success() {
    echo -e "${L_BOLD}${L_GREEN}${*}${L_RESET}"
}

log_warn() {
    echo -e "${L_BOLD}${L_YELLOW}${*}${L_RESET}"
}

log_error() {
    echo -e "${L_BOLD}${L_RED}${*}${L_RESET}"
}

log_obs() {
    echo -e "${L_BOLD}${L_BLUE}${*}${L_RESET}"
}

log_step() {
    echo -e "${L_BOLD}${L_MAGENTA}${*}${L_RESET}"
}

log_neutral() {
    echo -e "${L_BOLD}${L_WHITE}${*}${L_RESET}"
}

log_info() {
    echo -e "${L_BOLD}${L_CYAN}${*}${L_RESET}"
}

logs() {
    echo -e "\n${L_BOLD}=== DEMO DOS HELPERS DE LOG ===${L_RESET}\n"

    log_success "[SUCCESS] Pacotes sincronizados com sucesso."
    log_warn    "[WARN] Existem 3 atualizações pendentes no AUR."
    log_error   "[ERROR] Falha ao conectar no repositório."
    log_obs     "[OBS] A variável SETUP_ESSENTIALS_DIR está ativa."
    log_step    "[STEP] Iniciando validação do Quality Gate..."
    log_info    "[INFO] Rodando em Arch Linux (Kernel $(uname -r))."
    log_neutral "[NEUTRAL] Mensagem padrão sem destaque especial."

    echo -e "\n--------------------------------------------------\n"
}
