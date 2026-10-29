# ZSH_DESC - Módulo especial de Cores como envs para logs em scripts

# Carrega o módulo nativo de cores do Zsh
autoload -U colors && colors

# --------------------------------------------------------
#  Variáveis de Modificadores e Formatação
# --------------------------------------------------------
L_RESET="${reset_color}"
L_BOLD="${bold_color}"

# --------------------------------------------------------
#  Variáveis de Cores de Texto (8 Cores ANSI Nativas)
# --------------------------------------------------------
L_BLACK="${fg[black]}"
L_RED="${fg[red]}"
L_GREEN="${fg[green]}"
L_YELLOW="${fg[yellow]}"
L_BLUE="${fg[blue]}"
L_MAGENTA="${fg[magenta]}"
L_CYAN="${fg[cyan]}"
L_WHITE="${fg[white]}"

colors() {
    echo -e "\n${L_BOLD}=== DEMO COMPLETA DE CORES E FORMATOS ZSH ===${L_RESET}\n"

    # Cores Base
    echo -e "${L_GREEN}■ Verde (L_GREEN)${L_RESET}"
    echo -e "${L_YELLOW}■ Amarelo (L_YELLOW)${L_RESET}"
    echo -e "${L_RED}■ Vermelho (L_RED)${L_RESET}"
    echo -e "${L_BLUE}■ Azul (L_BLUE)${L_RESET}"
    echo -e "${L_MAGENTA}■ Magenta/Roxo (L_MAGENTA)${L_RESET}"
    echo -e "${L_CYAN}■ Ciano (L_CYAN)${L_RESET}"
    echo -e "${L_WHITE}■ Branco/Cinza (L_WHITE)${L_RESET}"

    echo -e "\n--------------------------------------------------"
    echo -e "${L_BOLD}Variações em Negrito (L_BOLD):${L_RESET}\n"

    # Cores em Negrito
    echo -e "${L_BOLD}${L_GREEN}■ Verde Bold${L_RESET}"
    echo -e "${L_BOLD}${L_YELLOW}■ Amarelo Bold${L_RESET}"
    echo -e "${L_BOLD}${L_RED}■ Vermelho Bold${L_RESET}"
    echo -e "${L_BOLD}${L_BLUE}■ Azul Bold${L_RESET}"
    echo -e "${L_BOLD}${L_MAGENTA}■ Magenta Bold${L_RESET}"
    echo -e "${L_BOLD}${L_CYAN}■ Ciano Bold${L_RESET}"
    echo -e "${L_BOLD}${L_WHITE}■ Branco/Cinza${L_RESET}"

    echo -e "\n--------------------------------------------------\n"
}
