# ZSH_DESC - Garante que um comando ou função modular do zsh esteja carregado

ensure_command() {
    local cmd="$1"

    # Se o parâmetro for vazio, não faz nada
    [[ -z "$cmd" ]] && return 1

    # Se o comando ou função já existir, retorna sucesso imediatamente
    (( $+functions[$cmd] )) || command -v "$cmd" &>/dev/null && return 0

    # Caminho do arquivo baseado na estrutura ~/.config/zsh
    local file="$HOME/.config/zsh/$cmd.zsh"

    # Se o arquivo não estiver diretamente na raiz de zsh, faz uma busca recursiva
    if [[ ! -f "$file" ]]; then
        file=("$HOME/.config/zsh"/**/"$cmd.zsh"(N[1]))
    fi

    # Carrega o arquivo se ele existir e for legível
    if [[ -n "$file" && -r "$file" ]]; then
        source "$file"
    else
        echo "ensure_command: Arquivo para o comando '$cmd' não foi encontrado em ~/.config/zsh" >&2
        return 1
    fi
}
