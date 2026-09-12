#!/usr/bin/env zsh
set -e

# CONFIG
THEME_NAME="actually-2077"
THEME_PATH="$HOME/projetos-git/setup-essentials/vscode/themes/$THEME_NAME"
SETTINGS_PATH="$HOME/.config/Code/User/settings.json"

# Checagem de Dependências
command -v node >/dev/null 2>&1 || { echo "NodeJS não encontrado!"; exit 1; }
command -v code >/dev/null 2>&1 || { echo "VS Code (code) não encontrado!"; exit 1; }

cd "$THEME_PATH"

echo "Empacotando tema..."
yes | npx -y @vscode/vsce package --no-dependencies --allow-missing-repository > /dev/null

VSIX_FILE=$(ls *.vsix | head -n 1)

echo "Instalando $VSIX_FILE..."
code --install-extension "$VSIX_FILE" --force

if [ -f "$SETTINGS_PATH" ] && command -v jq >/dev/null 2>&1; then
    echo "Atualizando settings.json..."
    tmp=$(mktemp)
    jq --arg theme "$THEME_NAME" '.["workbench.colorTheme"] = $theme' "$SETTINGS_PATH" > "$tmp" && mv "$tmp" "$SETTINGS_PATH"
fi

rm -f *.vsix

echo "Pronto! Tema instalado e ativado."
