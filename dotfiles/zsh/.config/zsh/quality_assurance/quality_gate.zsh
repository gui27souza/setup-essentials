# ZSH_DESC - Executa validações de qualidade e consistência nos scripts zsh e dotfiles

quality_gate() {

    local base_dir="${SETUP_ESSENTIALS_DIR:-$HOME/.config/zsh/../../../..}"
    local zsh_dir="$HOME/.config/zsh"
    local errors=0
    local warnings=0

    log_neutral "🛡️ Iniciando Quality Gate do setup-essentials...\n"

    # ---------------------------------------------------------
    # 1. Validação dos Módulos ZSH (~/.config/zsh)
    # ---------------------------------------------------------
    if [[ -d "$zsh_dir" ]]; then
        for file in "$zsh_dir"/**/*.zsh(N); do
            local filename="$(basename "$file")"
            local expected_cmd="${filename%.zsh}"
            local relative_path="${file#$zsh_dir/}"

            # A) Checa Sintaxe do arquivo Zsh
            if ! zsh -n "$file" 2>/dev/null; then
                log_error "❌ [SINTAXE] Erro de sintaxe detectado em: $relative_path"
                ((errors++))
                continue
            fi

            # B) Checa se possui a tag # ZSH_DESC -
            if ! grep -q '^# ZSH_DESC -' "$file"; then
                log_warn "⚠️  [DESC] Ausente ou fora do padrão em: $relative_path"
                ((warnings++))
            else
                local desc=$(grep '^# ZSH_DESC -' "$file" | sed 's/# ZSH_DESC - //g' | xargs)
                if [[ -z "$desc" ]]; then
                    log_warn "⚠️  [DESC VAZIA] Preencha a descrição em: $relative_path"
                    ((warnings++))
                fi
            fi

            # C) Checa se a função declarada bate com o nome do arquivo
            if ! grep -qE "^\s*(function\s+)?${expected_cmd}\s*\(\)" "$file" && ! grep -qE "^\s*function\s+${expected_cmd}\b" "$file"; then
                log_error "❌ [NOME] A função no arquivo '$relative_path' não corresponde ao nome '$expected_cmd()'"
                ((errors++))
            fi
        done
    fi

    # ---------------------------------------------------------
    # 2. Guardrail do Stow: Symlinks Quebrados na Home
    # ---------------------------------------------------------
    local broken_links=($(find "$HOME" -maxdepth 4 -xtype l -lname "*setup-essentials*" 2>/dev/null))
    if (( ${#broken_links} > 0 )); then
        for link in $broken_links; do
            log_error "❌ [STOW] Symlink quebrado em: ${link/#$HOME/~}"
            ((errors++))
        done
    fi

    # ---------------------------------------------------------
    # 3. Validação de Arquivos de Configuração JSON/JSONC
    # ---------------------------------------------------------
    if command -v jq &>/dev/null && [[ -d "$base_dir" ]]; then
        for json_file in "$base_dir"/**/*.json(N) "$base_dir"/**/*.jsonc(N); do
            [[ "$json_file" == *"/.git/"* ]] && continue
            if ! jq empty "$json_file" 2>/dev/null; then
                log_error "❌ [JSON] Erro de sintaxe em: ${json_file#$base_dir/}"
                ((errors++))
            fi
        done
    fi

    # ---------------------------------------------------------
    # 4. Shell Scripts Avulsos (.sh)
    # ---------------------------------------------------------
    if [[ -d "$base_dir" ]]; then
        for sh_file in "$base_dir"/**/*.sh(N); do
            [[ "$sh_file" == *"/.git/"* ]] && continue
            local rel_sh="${sh_file#$base_dir/}"

            if [[ ! -x "$sh_file" ]]; then
                log_warn "⚠️  [PERMISSÃO] Script sem permissão +x: $rel_sh"
                ((warnings++))
            fi

            if ! head -n 1 "$sh_file" | grep -q '^#!'; then
                log_warn "⚠️  [SHEBANG] Ausente na primeira linha de: $rel_sh"
                ((warnings++))
            fi
        done
    fi

    # ---------------------------------------------------------
    # Resumo Final
    # ---------------------------------------------------------
    if (( errors > 0 )); then
        log_error "💥 Quality Gate FALHOU! ($errors erro(s), $warnings aviso(s))"
        return 1
    elif (( warnings > 0 )); then
        log_warn "⚠️  Quality Gate PASSOU COM AVISOS ($warnings aviso(s))"
        return 0
    else
        log_success "✅ Quality Gate PASSOU PERFEITAMENTE! Tudo em ordem."
        return 0
    fi
}
