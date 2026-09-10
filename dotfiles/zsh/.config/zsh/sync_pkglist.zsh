sync_pkglist() {
    local repo_dir="$HOME/projetos-git/setup-essentials"
    local pkg_official="$repo_dir/pkglist.txt"
    local pkg_aur="$repo_dir/pkglist-aur.txt"
    local pkg_ignore="$repo_dir/pkglist-ignore.txt"

    # Cria os arquivos caso não existam
    touch "$pkg_official" "$pkg_aur" "$pkg_ignore"

    echo "==> 🔍 Verificando novos pacotes instalados no sistema..."

    # Captura pacotes instalados explicitamente (exclui dependências automáticas)
    local installed_official=($(pacman -Qnetq))
    local installed_aur=($(pacman - Qmeq 2>/dev/null || yay -Qemq 2>/dev/null))

    # Função interna para processar cada categoria (Oficial / AUR)
    process_packages() {
        local type_label="$1"
        local target_file="$2"
        shift 2
        local pkgs=("$@")

        for pkg in "${pkgs[@]}"; do
            [ -z "$pkg" ] && continue

            # Se já está na pkglist ou na ignore-list, pula
            if grep -qxB 0 "^${pkg}$" "$target_file" 2>/dev/null || grep -qxB 0 "^${pkg}$" "$pkg_ignore" 2>/dev/null; then
                continue
            fi

            echo -e "\n📦 Pacote novo ($type_label): \033[1;33m$pkg\033[0m"
            echo -n "Deseja adicionar ao $type_label [a], ignorar pra sempre [i], ou pular por enquanto [s]? (a/i/s): "
            read -r choice < /dev/tty

            case "$choice" in
                a|A)
                    echo "$pkg" >> "$target_file"
                    echo "  ✅ Adicionado ao $target_file"
                    ;;
                i|I)
                    echo "$pkg" >> "$pkg_ignore"
                    echo "  🚫 Adicionado ao $pkg_ignore"
                    ;;
                *)
                    echo "  ⏭️  Pulado."
                    ;;
            esac
        done
    }

    # Processa oficiais e AUR
    process_packages "Oficial" "$pkg_official" "${installed_official[@]}"
    process_packages "AUR" "$pkg_aur" "${installed_aur[@]}"

    # Ordena e remove duplicatas dos arquivos para manter tudo limpo
    sort -u "$pkg_official" -o "$pkg_official"
    sort -u "$pkg_aur" -o "$pkg_aur"
    sort -u "$pkg_ignore" -o "$pkg_ignore"

    echo -e "\n✨ Listas de pacotes atualizadas com sucesso!"
}