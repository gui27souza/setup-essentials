# ZSH_DESC - Checagem detalhada de atualizações de pacotes (Oficiais e AUR)

check_updates() {

    if ! command -v checkupdates &> /dev/null; then
        log_warn "⚠️ Instale 'pacman-contrib' para usar essa checagem: sudo pacman -S pacman-contrib"
        return 1
    fi

    log_neutral "📦 Iniciando checagem de atualizações de pacotes..."

    # Coleta as linhas de update (formato: "pacote versao_antiga -> versao_nova")
    local repo_lines=("${(@f)$(checkupdates 2>/dev/null)}")
    [[ -z "${repo_lines[1]}" ]] && repo_lines=()

    local aur_lines=()
    if command -v yay &> /dev/null; then
        aur_lines=("${(@f)$(yay -Qua 2>/dev/null)}")
        [[ -z "${aur_lines[1]}" ]] && aur_lines=()
    fi

    local repo_updates=${#repo_lines}
    local aur_updates=${#aur_lines}
    local total_updates=$(( repo_updates + aur_updates ))

    if (( total_updates == 0 )); then
        echo ""
        log_success "✅ Sistema totalmente atualizado!"
        return 0
    fi

    # Extrai os nomes de todos os pacotes pendentes para consulta em lote (O(1) subprocesso)
    local all_pkgs=() line
    for line in "${repo_lines[@]}" "${aur_lines[@]}"; do
        all_pkgs+=("${line%% *}")
    done

    # Mapa de pacotes instalados explicitamente pelo usuário (Ciano vs Branco para dependências)
    typeset -A explicit_map
    local exp_pkg
    for exp_pkg in "${(@f)$(pacman -Qqe 2>/dev/null)}"; do
        [[ -n "$exp_pkg" ]] && explicit_map[$exp_pkg]=1
    done

    # Mapa de descrições extraídas em uma única chamada ao pacman -Qi
    typeset -A desc_map
    local pkg_key pkg_desc
    while IFS=$'\t' read -r pkg_key pkg_desc; do
        [[ -n "$pkg_key" ]] && desc_map[$pkg_key]="$pkg_desc"
    done < <(
        pacman -Qi "${all_pkgs[@]}" 2>/dev/null | awk '
            /^(Name|Nome)[[:space:]]*:/ {
                line = $0
                sub(/^[^:]+:[[:space:]]*/, "", line)
                name = line
            }
            /^(Description|Descrição)[[:space:]]*:/ {
                line = $0
                sub(/^[^:]+:[[:space:]]*/, "", line)
                if (name != "") print name "\t" line
            }
        '
    )

    # Carrega lista de pacotes críticos do arquivo pkglist-critical.txt (O(1) lookup)
    local repo_dir="${SETUP_ESSENTIALS_DIR:-$HOME/.config/zsh/../../../..}"
    local pkg_critical="$repo_dir/pkglist-critical.txt"
    typeset -A critical_map
    if [[ -f "$pkg_critical" ]]; then
        local crit_line
        for crit_line in "${(@f)$(<"$pkg_critical")}"; do
            crit_line="${crit_line//[[:space:]]/}"
            [[ -n "$crit_line" && "$crit_line" != \#* ]] && critical_map[$crit_line]=1
        done
    fi
    local critical_count=0

    _render_update_group() {
        local group_title="$1"
        shift
        local lines=("$@")
        local item pkg old_ver arrow new_ver name_color crit_badge desc

        echo -e "\n${L_BOLD}${L_MAGENTA}=== ${group_title} (${#lines}) ===${L_RESET}"

        for item in "${lines[@]}"; do
            read -r pkg old_ver arrow new_ver <<< "$item"

            # Cor do nome: Ciano Negrito (explícito) vs Branco (dependência)
            if [[ -n "${explicit_map[$pkg]}" ]]; then
                name_color="${L_BOLD}${L_CYAN}"
            else
                name_color="${L_WHITE}"
            fi

            # Badge de pacote crítico consultando o hash map carregado do txt
            crit_badge=""
            if [[ -n "${critical_map[$pkg]}" ]]; then
                crit_badge=" ${L_BOLD}${L_RED}⚡ [CRÍTICO]${L_RESET}"
                (( critical_count++ ))
            fi

            desc="${desc_map[$pkg]:-Sem descrição local disponível}"

            echo -e "\n  • ${name_color}${pkg}${L_RESET}${crit_badge} (${L_YELLOW}${old_ver}${L_RESET} -> ${L_BOLD}${L_GREEN}${new_ver}${L_RESET})"
            echo -e "    ${L_WHITE}└─ ${desc}${L_RESET}"
        done
    }

    {
        (( repo_updates > 0 )) && _render_update_group "Oficiais (Pacman)" "${repo_lines[@]}"
        (( aur_updates > 0 ))  && _render_update_group "AUR (Yay)" "${aur_lines[@]}"
    } always {
        unfunction _render_update_group 2>/dev/null
    }

    echo ""
    log_obs "💡 Cores: ${L_BOLD}${L_CYAN}Ciano${L_RESET} = pacote explícito | ${L_WHITE}Branco${L_RESET} = dependência"
    log_warn "⚠️  $total_updates atualizações pendentes ($repo_updates oficial, $aur_updates AUR)."

    if (( critical_count > 0 )); then
        log_error "🚨 Atenção: $critical_count pacote(s) crítico(s) na fila (recomendado reboot após atualizar)."
    fi
}