# ZSH_DESC - Sincroniza pkglist com o estado atual da máquina

sync_pkglist() {
    local repo_dir="${SETUP_ESSENTIALS_DIR:?Variável SETUP_ESSENTIALS_DIR não definida}"
    local pkg_official="$repo_dir/pkglist.txt"
    local pkg_aur="$repo_dir/pkglist-aur.txt"
    local pkg_ignore="$repo_dir/pkglist-ignore.txt"

    # Cria os arquivos caso não existam
    touch "$pkg_official" "$pkg_aur" "$pkg_ignore"

    log_neutral "🔍 Verificando pacotes instalados no sistema..."

    # Carrega listas existentes em hash maps na memória (O(1), sem grep no loop)
    typeset -A map_official map_aur map_ignore
    local line
    for line in ${(f)"$(<"$pkg_official")"}; do [[ -n "$line" ]] && map_official[$line]=1; done
    for line in ${(f)"$(<"$pkg_aur")"}; do [[ -n "$line" ]] && map_aur[$line]=1; done
    for line in ${(f)"$(<"$pkg_ignore")"}; do [[ -n "$line" ]] && map_ignore[$line]=1; done

    # Filtra apenas os pacotes realmente novos antes de começar a interação
    local new_official=() new_aur=() pkg
    for pkg in ${(f)"$(pacman -Qnetq)"}; do
        [[ -n "$pkg" && -z "${map_official[$pkg]}" && -z "${map_ignore[$pkg]}" ]] && new_official+=("$pkg")
    done
    for pkg in ${(f)"$(pacman -Qmeq)"}; do
        [[ -n "$pkg" && -z "${map_aur[$pkg]}" && -z "${map_ignore[$pkg]}" ]] && new_aur+=("$pkg")
    done

    local total_new=$(( ${#new_official} + ${#new_aur} ))

    if (( total_new == 0 )); then
        log_success "\n✅ Nenhum pacote novo encontrado. Tudo sincronizado!"
        return 0
    fi

    log_info "📋 Encontrados \033[1;33m$total_new\033[0m pacote(s) novo(s)."

    local current=0
    _process_packages() {
        local type_label="$1"
        local target_file="$2"
        shift 2
        local pkgs=("$@")
        local choice desc

        for pkg in "${pkgs[@]}"; do
            (( current++ ))

            # Extrai a descrição curta do pacote local
            desc=$(pacman -Qi "$pkg" 2>/dev/null | awk -F': ' '/^Description|^Descrição/ {print $2; exit}')

            print ""
            log_info "[$current/$total_new] 📦 ($type_label): \033[1;33m$pkg\033[0m"
            [[ -n "$desc" ]] && log_neutral "   └─ $desc"
            printf "   Adicionar ao %s [a], ignorar [i], ou pular [S]? (a/i/S): " "$type_label" > /dev/tty
            read -r choice < /dev/tty

            case "${choice:l}" in
                a)
                    print -r -- "$pkg" >> "$target_file"
                    log_success "   ✅ Adicionado ao ${target_file:t}"
                    ;;
                i)
                    print -r -- "$pkg" >> "$pkg_ignore"
                    log_error "   🚫 Adicionado ao ${pkg_ignore:t}"
                    ;;
                *)
                    log_step "   ⏭️  Pulado."
                    ;;
            esac
        done
    }

    # Bloco 'always' garante ordenação e limpeza mesmo se der Ctrl+C no meio
    {
        _process_packages "Oficial" "$pkg_official" "${new_official[@]}"
        _process_packages "AUR" "$pkg_aur" "${new_aur[@]}"
    } always {
        unfunction _process_packages 2>/dev/null

        local file
        for file in "$pkg_official" "$pkg_aur" "$pkg_ignore"; do
            sort -u "$file" | sed '/^$/d' > "${file}.tmp" && mv "${file}.tmp" "$file"
        done
    }

    log_success "\n✅ Listas de pacotes atualizadas com sucesso!"
}