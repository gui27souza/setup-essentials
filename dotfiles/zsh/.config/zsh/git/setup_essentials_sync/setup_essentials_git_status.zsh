# ZSH_DESC - Git Status do repositório seutp-essentials

setup_essentials_git_status() {
    local previous_path="$PWD"
    cd "$SETUP_ESSENTIALS_DIR" || return
    git_quick_status
    cd "$previous_path"
}
