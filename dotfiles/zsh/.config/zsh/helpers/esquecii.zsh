# ZSH_DESC - Mostra esse help

zsh_funcs="$HOME/.config/zsh"

esquecii() {

    # Imprime a entrada formatada com indentação baseada na profundidade
    _print_entry() {
        local file=$1
        local depth=$2
        local indent=$(printf '  %.0s' $(seq 1 $depth))

        local description=$(grep "^# ZSH_DESC - " "$file")
        description=${description#\# ZSH_DESC - }

        echo "${indent}${${file%.*}##*/} - $description"
    }

    # Varre recursivamente um diretório, exibindo cabeçalhos de grupo e arquivos
    _recursive_scan() {
        local dir=$1
        local depth=${2:-0}
        local indent=$(printf '  %.0s' $(seq 1 $depth))

        # Arquivos .zsh direto neste nível
        for file in "$dir"/*.zsh(N); do
            _print_entry "$file" $depth
        done

        # Sub-diretórios
        for sub in "$dir"/*(N/); do
            echo "\n${indent}= ${sub##*/} ==="
            _recursive_scan "$sub" $(( depth + 1 ))
            echo "${indent}=="
        done
    }

    # Arquivos .zsh na raiz
    for file in "$zsh_funcs"/*.zsh(N); do
        echo
        _print_entry "$file" 0
    done

    # Diretórios na raiz
    for dir in "$zsh_funcs"/*(N/); do
        echo "\n= ${dir##*/} ====="
        _recursive_scan "$dir" 1
        echo "==="
    done

    echo
}
