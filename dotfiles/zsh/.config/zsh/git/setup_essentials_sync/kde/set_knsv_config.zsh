#!/usr/bin/env zsh
# ZSH_DESC - Aplica manualmente o perfil do KDE Plasma salvo no repositório

set_knsv_config() {
    echo "🎨 Iniciando restauração do perfil do KDE Plasma..."

    if ! command -v konsave &> /dev/null; then
        echo "⚠️  Konsave não está instalado no sistema. Instale via AUR com: yay -S konsave"
        return 1
    fi

    # Determina o caminho base do repo
    local repo_dir="${SETUP_ESSENTIALS_DIR:-$HOME/projetos-git/setup-essentials}"
    local knsv_file="$repo_dir/kde/plasma-gui.knsv"

    if [ ! -f "$knsv_file" ]; then
        echo "❌ Arquivo do perfil não encontrado em: $knsv_file"
        return 1
    fi

    local profile_name="meu-plasma"

    echo "📦 Importando perfil '$profile_name' do arquivo .knsv..."
    # Importa o arquivo .knsv sobrescrevendo se já existir registro prévio no Konsave
    konsave -i "$knsv_file" 2>/dev/null || true

    echo "🚀 Aplicando perfil no KDE Plasma..."
    konsave -a "$profile_name" 2>/dev/null || konsave -a "$(konsave -l | awk 'NR>2 {print $2}' | head -n 1)"

    echo "✨ Perfil do KDE aplicado com sucesso!"
    echo "💡 Dica: Algumas alterações visuais/widgets podem exigir logout ou recarregar o Plasma."
}
