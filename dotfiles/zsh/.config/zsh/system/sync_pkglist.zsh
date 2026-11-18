# ZSH_DESC - Sincroniza pkglist com o estado atual da máquina

sync_pkglist() {
    local repo_dir="${SETUP_ESSENTIALS_DIR:?Variável SETUP_ESSENTIALS_DIR não definida}"
    local pkg_official="$repo_dir/pkglist.txt"
    local pkg_aur="$repo_dir/pkglist-aur.txt"
    local pkg_ignore="$repo_dir/pkglist-ignore.txt"
    local pkg_critical="$repo_dir/pkglist-critical.txt"

    # Cria os arquivos caso não existam
    touch "$pkg_official" "$pkg_aur" "$pkg_ignore" "$pkg_critical"

    log_neutral "🔍 Verificando pacotes instalados no sistema..."

    # Carrega listas existentes em hash maps na memória (O(1), sem grep no loop)
    typeset -A map_official map_aur map_ignore map_critical
    local line
    for line in ${(f)"$(<"$pkg_official")"}; do [[ -n "$line" ]] && map_official[$line]=1; done
    for line in ${(f)"$(<"$pkg_aur")"}; do [[ -n "$line" ]] && map_aur[$line]=1; done
    for line in ${(f)"$(<"$pkg_ignore")"}; do [[ -n "$line" ]] && map_ignore[$line]=1; done
    for line in ${(f)"$(<"$pkg_critical")"}; do
        line="${line//[[:space:]]/}"
        [[ -n "$line" && "$line" != \#* ]] && map_critical[$line]=1
    done

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

    # Heurística educativa ("Faro Linux") para sugerir se o pacote merece ir para pkglist-critical.txt
    _get_critical_hint() {
        local p_name="$1"
        local p_desc="${2:l}"

        if [[ "$p_name" =~ ^(linux|.*-ucode|mkinitcpio|dracut|fwupd) ]] || [[ "$p_desc" =~ (kernel|microcode|firmware|initramfs) ]]; then
            print "Kernel, Firmware ou Boot initramfs — falhas aqui impedem o boot"
        elif [[ "$p_name" =~ ^(refind|grub|efibootmgr|btrfs-progs|snapper|dosfstools|cryptsetup) ]] || [[ "$p_desc" =~ (bootloader|efi|btrfs|filesystem) ]]; then
            print "Bootloader ou Sistema de Arquivos — vital para o SSD externo e snapshots"
        elif [[ "$p_name" =~ ^(mesa|lib32-mesa|vulkan-|xf86-video-|rocm-|ollama-rocm|libva-) ]] || [[ "$p_desc" =~ (vulkan|opengl|mesa|radeon|amdgpu|va-api) ]]; then
            print "Driver Gráfico / GPU AMD — afeta renderização, jogos e aceleração de hardware"
        elif [[ "$p_name" =~ ^(wayland|hypr|plasma-|kwin|sddm|greetd|xdg-desktop-portal|qt6-wayland|qt5-wayland|xorg-xwayland) ]] || [[ "$p_desc" =~ (wayland|compositor|window manager|display manager|plasma) ]]; then
            print "Interface Gráfica / Wayland / Sessão — se quebrar, a interface não sobe"
        elif [[ "$p_name" =~ ^(systemd|glibc|dbus|polkit|pam|pipewire|wireplumber|networkmanager|iwd|bluez) ]] || [[ "$p_desc" =~ (systemd|system and service manager|pipewire|network manager|bluetooth) ]]; then
            print "Serviço Base de Sistema, Áudio ou Rede — afeta conectividade ou sessão"
        fi
    }

    local current=0
    _process_packages() {
        local type_label="$1"
        local target_file="$2"
        shift 2
        local pkgs=("$@")
        local choice desc crit_reason

        for pkg in "${pkgs[@]}"; do
            (( current++ ))

            # Extrai a descrição curta do pacote local
            desc=$(pacman -Qi "$pkg" 2>/dev/null | awk -F': ' '/^Description|^Descrição/ {print $2; exit}')
            crit_reason=$(_get_critical_hint "$pkg" "$desc")

            print ""
            log_info "[$current/$total_new] 📦 ($type_label): \033[1;33m$pkg\033[0m"
            [[ -n "$desc" ]] && log_neutral "   └─ $desc"
            if [[ -n "$crit_reason" ]]; then
                log_warn "   💡 [Recomendado Crítico]: $crit_reason"
            fi
            printf "   Adicionar ao %s [a], Adicionar + Crítico [c], ignorar [i], ou pular [S]? (a/c/i/S): " "$type_label" > /dev/tty
            read -r choice < /dev/tty

            case "${choice:l}" in
                a)
                    print -r -- "$pkg" >> "$target_file"
                    log_success "   ✅ Adicionado ao ${target_file:t}"
                    ;;
                c)
                    print -r -- "$pkg" >> "$target_file"
                    if [[ -z "${map_critical[$pkg]}" ]]; then
                        print -r -- "$pkg" >> "$pkg_critical"
                        map_critical[$pkg]=1
                    fi
                    log_success "   ⚡ Adicionado ao ${target_file:t} e marcado como CRÍTICO em ${pkg_critical:t}"
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
        unfunction _get_critical_hint 2>/dev/null

        local file
        for file in "$pkg_official" "$pkg_aur" "$pkg_ignore"; do
            sort -u "$file" | sed '/^$/d' > "${file}.tmp" && mv "${file}.tmp" "$file"
        done
    }

    log_success "\n✅ Listas de pacotes atualizadas com sucesso!"
}