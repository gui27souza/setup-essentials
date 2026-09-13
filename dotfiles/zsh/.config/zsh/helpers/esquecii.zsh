# ZSH_DESC - Mostra esse help

zsh_funcs="$HOME/.config/zsh"

esquecii() {

    _formulate_entry() {
        local entry=$1
        local sub_dir=$2
        
        local description=$(grep "^# ZSH_DESC - " "$entry")
        description=${description#\# ZSH_DESC - }
        
        if [[ "$sub_dir" == "true" ]]; then
            echo "  ${${entry%.*}##*/} - $description"
        else
            echo "${${entry%.*}##*/} - $description"
        fi
    }

    for entry in `ls $zsh_funcs`; do

        # Se dir
        if [ -d "$zsh_funcs/$entry" ]; then
            echo "\n$entry"
            local sub_dir="$zsh_funcs/$entry"
            for sub_entry in $(find "$sub_dir" -name "*.zsh"); do
                _formulate_entry "$sub_entry" "true"
            done
        
        # Se file
        elif [ -f "$zsh_funcs/$entry" ]; then
            echo
            _formulate_entry "$zsh_funcs/$entry" "false"
        fi
        
    done

    echo
}
