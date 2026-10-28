# ZSH_DESC - Módulo especial com comandos de logs coloridos

log_info() {
    echo -e "${L_BOLD}${L_GREEN}${*}${L_RESET}"
}

log_warn() {
    echo -e "${L_BOLD}${L_YELLOW}${*}${L_RESET}"
}

log_error() {
    echo -e "${L_BOLD}${L_RED}${*}${L_RESET}"
}

log_step() {
    echo -e "${L_BOLD}${L_CYAN}${*}${L_RESET}"
}

logs() {
    echo -e "\n${L_BOLD}=== DEMO DOS HELPERS DE LOG ===${L_RESET}\n"

    log_info  "✨ [INFO]  Operação concluída com sucesso ou estado positivo."
    log_warn  "⚠️  [WARN]  Alerta de pendência, atualização necessária ou aviso."
    log_error "❌ [ERROR] Falha crítica, comando não encontrado ou erro de execução."
    log_step  "➜  [STEP]  Passo a passo, progresso ou etapa atual do script."

    echo -e "\n--------------------------------------------------"
    echo -e "${L_BOLD}Exemplo de fluxo em script:${L_RESET}\n"

    log_step "Verificando dependências do sistema..."
    log_info "Pacote 'pacman-contrib' encontrado."
    log_warn "Existem 5 atualizações pendentes no AUR."
    log_error "Falha ao sincronizar o repositório X."

    echo -e "\n--------------------------------------------------\n"
}
