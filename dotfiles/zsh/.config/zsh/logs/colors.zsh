# ZSH_DESC - Módulo especial de Cores como envs para logs em scripts

# Carrega o módulo nativo de cores do Zsh
autoload -U colors && colors

# --------------------------------------------------------
#  Variáveis de Cores Curta (Para inline quando precisar)
# --------------------------------------------------------
L_RESET="${reset_color}"
L_BOLD="${bold_color}"
L_GREEN="${fg[green]}"
L_YELLOW="${fg[yellow]}"
L_RED="${fg[red]}"
L_BLUE="${fg[blue]}"
L_CYAN="${fg[cyan]}"

# ZSH_DESC - Módulo especial de Cores como envs para logs em scripts

# Carrega o módulo nativo de cores do Zsh
autoload -U colors && colors

# --------------------------------------------------------
#  Variáveis de Cores Curta (Para inline quando precisar)
# --------------------------------------------------------
L_RESET="${reset_color}"
L_BOLD="${bold_color}"
L_GREEN="${fg[green]}"
L_YELLOW="${fg[yellow]}"
L_RED="${fg[red]}"
L_BLUE="${fg[blue]}"
L_CYAN="${fg[cyan]}"

colors() {
    echo -e "\n${L_BOLD}=== DEMO DE CORES ZSH ===${L_RESET}\n"

    # Cores Base
    echo -e "${L_GREEN}■ Verde (L_GREEN)${L_RESET}"
    echo -e "${L_YELLOW}■ Amarelo (L_YELLOW)${L_RESET}"
    echo -e "${L_RED}■ Vermelho (L_RED)${L_RESET}"
    echo -e "${L_BLUE}■ Azul (L_BLUE)${L_RESET}"
    echo -e "${L_CYAN}■ Ciano (L_CYAN)${L_RESET}"

    echo -e "\n--------------------------------------------------"
    echo -e "${L_BOLD}Variações em Negrito (L_BOLD):${L_RESET}\n"

    # Cores em Negrito
    echo -e "${L_BOLD}${L_GREEN}■ Verde Bold${L_RESET}"
    echo -e "${L_BOLD}${L_YELLOW}■ Amarelo Bold${L_RESET}"
    echo -e "${L_BOLD}${L_RED}■ Vermelho Bold${L_RESET}"
    echo -e "${L_BOLD}${L_BLUE}■ Azul Bold${L_RESET}"
    echo -e "${L_BOLD}${L_CYAN}■ Ciano Bold${L_RESET}"

    echo -e "\n--------------------------------------------------\n"
}