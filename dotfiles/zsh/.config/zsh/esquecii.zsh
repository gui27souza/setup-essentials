# ZSH_DESC - Mostra esse help

zsh_funcs="$HOME/projetos-git/setup-essentials/dotfiles/zsh/.config/zsh"

esquecii() {
    for entry in `ls $zsh_funcs`; do
        local description=$(grep "^# ZSH_DESC - " "$zsh_funcs/$entry")
        description=${description#\# ZSH_DESC - }
        echo "${entry%.*} - $description"
    done
}
