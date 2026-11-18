# ZSH_DESC - Mostra esse help (aceita filtro opcional: esquecii <termo>)

zsh_funcs="${zsh_funcs:-$HOME/.config/zsh}"

esquecii() {
    local filter="${1:l}"
    local found_any=0

    # Verifica se um arquivo .zsh bate com o filtro (caminho/categoria, nome do comando ou descrição)
    _matches_filter() {
        [[ -z "$filter" ]] && return 0

        local file="$1"
        local desc="$2"
        local cmd_name="${${file%.*}##*/}"
        local rel_path="${file#$zsh_funcs/}"

        [[ "${rel_path:l}" == *"$filter"* || "${cmd_name:l}" == *"$filter"* || "${desc:l}" == *"$filter"* ]]
    }

    # Imprime a entrada formatada com indentação baseada na profundidade
    _print_entry() {
        local file=$1
        local depth=$2
        local indent=$(printf '  %.0s' $(seq 1 $depth))
        local cmd_name="${${file%.*}##*/}"

        local description=$(grep "^# ZSH_DESC - " "$file")
        description=${description#\# ZSH_DESC - }

        if _matches_filter "$file" "$description"; then
            echo -e "${indent}${L_BOLD}${L_CYAN}${cmd_name}${L_RESET} - ${L_WHITE}${description}${L_RESET}"
            return 0
        fi
        return 1
    }

    # Varre recursivamente um diretório, exibindo cabeçalhos de grupo e arquivos
    _recursive_scan() {
        local dir=$1
        local depth=${2:-0}
        local indent=$(printf '  %.0s' $(seq 1 $depth))
        local has_content=0
        local file sub sub_out

        # Arquivos .zsh direto neste nível
        for file in "$dir"/*.zsh(N); do
            if _print_entry "$file" $depth; then
                has_content=1
            fi
        done

        # Sub-diretórios (só renderiza o bloco se houver match dentro dele)
        for sub in "$dir"/*(N/); do
            sub_out="$(_recursive_scan "$sub" $(( depth + 1 )))"
            if [[ -n "$sub_out" ]]; then
                has_content=1
                echo -e "\n${indent}${L_BOLD}${L_MAGENTA}= ${sub##*/} ===${L_RESET}"
                echo -e "$sub_out"
                echo -e "${indent}${L_BOLD}${L_MAGENTA}==${L_RESET}"
            fi
        done

        (( has_content )) && return 0 || return 1
    }

    local file root_entry dir dir_out
    {
        # Arquivos .zsh na raiz
        for file in "$zsh_funcs"/*.zsh(N); do
            if root_entry="$(_print_entry "$file" 0)"; then
                echo ""
                echo -e "$root_entry"
                found_any=1
            fi
        done

        # Diretórios na raiz (só renderiza o bloco se houver match dentro dele)
        for dir in "$zsh_funcs"/*(N/); do
            dir_out="$(_recursive_scan "$dir" 1)"
            if [[ -n "$dir_out" ]]; then
                found_any=1
                echo -e "\n${L_BOLD}${L_MAGENTA}= ${dir##*/} =====${L_RESET}"
                echo -e "$dir_out"
                echo -e "${L_BOLD}${L_MAGENTA}===${L_RESET}"
            fi
        done
    } always {
        unfunction _matches_filter _print_entry _recursive_scan 2>/dev/null
    }

    if (( ! found_any )); then
        echo ""
        log_warn "⚠️  Nenhum comando ou categoria encontrado para: '$1'"
    fi

    echo ""
}

# Autocomplete no <TAB> para sugerir categorias/pastas e nomes de comandos no esquecii
_esquecii_completion() {
    local target_dir="${zsh_funcs:-$HOME/.config/zsh}"
    [[ -d "$target_dir" ]] || return 0

    local dirs=("$target_dir"/**/*(N/:t))
    local cmds=("$target_dir"/**/*.zsh(N:t:r))
    compadd -a dirs cmds
}
(( $+functions[compdef] )) && compdef _esquecii_completion esquecii
