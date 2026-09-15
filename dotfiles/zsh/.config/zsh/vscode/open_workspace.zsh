# ZSH_DESC - Abre dado workspace no vscode em uma nova janela


repo_dir="$SETUP_ESSENTIALS_DIR"
vs_workspaces="$repo_dir/vscode/workspaces"

open_workspace() {

    if [ -z "$1" ]; then
        echo "Uso: open_workspace <nome_do_workspace>"
        return 1
    fi

    local workspace_path="$vs_workspaces/$1.code-workspace"

  if [ -f "$workspace_path" ]; then
    code -n "$workspace_path"
  else
    echo "Workspace '$1' não encontrado em $vs_workspaces"
    return 1
  fi
}

_open_workspace_autocomplete() {
    local -a opcoes

    for file in $vs_workspaces/**/*.code-workspace(N); do
        opcoes+=( "${${file%.*}##*/}" )
    done

    _describe 'comando' opcoes
}

compdef _open_workspace_autocomplete open_workspace
