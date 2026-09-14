# 📦 Gerenciando Dotfiles com GNU Stow

> Guia de referência para adicionar, vincular e manter configs de qualquer app neste repositório.

---

## 🧠 Como o Stow funciona aqui

O GNU Stow cria **symlinks** do seu home (`~`) para os arquivos neste repositório.
A lógica é simples: a estrutura de pastas dentro de cada módulo em `dotfiles/` **espelha** o caminho real no sistema, a partir do `~`.

```
dotfiles/
└── <app>/                        ← nome do módulo stow
    └── .config/
        └── <app>/
            └── config.conf       ← arquivo real no repo

# Stow cria o symlink:
~/.config/<app>/config.conf  →  dotfiles/<app>/.config/<app>/config.conf
```

---

## ➕ Adicionando um novo app (ex: kitty, waybar)

### Passo 1 — Criar a estrutura de pastas no repo

O caminho dentro do módulo deve espelhar exatamente onde o arquivo vive no sistema:

```bash
# Exemplo: kitty → ~/.config/kitty/kitty.conf
mkdir -p dotfiles/kitty/.config/kitty

# Exemplo: waybar → ~/.config/waybar/config.jsonc
mkdir -p dotfiles/waybar/.config/waybar
```

### Passo 2 — Mover ou copiar o arquivo de config atual para o repo

> ⚠️ **Importante**: se o arquivo já existe no sistema, mova-o para o repo — não copie — para evitar conflitos no próximo passo.

```bash
# kitty
mv ~/.config/kitty/kitty.conf dotfiles/kitty/.config/kitty/

# waybar (mova todos os arquivos do app de uma vez se precisar)
mv ~/.config/waybar/config.jsonc dotfiles/waybar/.config/waybar/
mv ~/.config/waybar/style.css    dotfiles/waybar/.config/waybar/
```

### Passo 3 — Aplicar o stow

```bash
cd dotfiles

stow -t ~ kitty
stow -t ~ waybar
```

### Passo 4 — Verificar o symlink

```bash
ls -la ~/.config/kitty/kitty.conf
# Esperado:
# lrwxrwxrwx ... kitty.conf -> ../../../projetos-git/setup-essentials/dotfiles/kitty/.config/kitty/kitty.conf
```

---

## 🔁 Fluxo de uso no dia a dia

| Ação | O que fazer |
| :--- | :--- |
| Editar a config de um app | Edite normalmente em `~/.config/<app>/` — você já está editando o arquivo do repo via symlink |
| Commitar mudanças | `git add` + `git commit` + `git push` normalmente |
| Aplicar mudanças no app | Depende do app (ver seção abaixo) |
| Restaurar em nova máquina | `./install.sh` — o stow cuida de tudo automaticamente |

---

## 🛠️ Corrigindo um arquivo real que virou conflito com o stow

Quando o stow encontra um **arquivo real** (não symlink) no destino, ele recusa criar o link e exibe erro. Para resolver:

```bash
# 1. Verifique se é symlink ou arquivo real
ls -la ~/.config/<app>/config.conf

# 2. Se for arquivo real (-rw-), compare com o do repo antes de remover
diff ~/.config/<app>/config.conf dotfiles/<app>/.config/<app>/config.conf

# 3. Faça backup e remova o arquivo real
cp ~/.config/<app>/config.conf ~/.config/<app>/config.conf.bak
rm ~/.config/<app>/config.conf

# 4. Aplique o stow
cd dotfiles
stow -t ~ <app>
```

---

## 💡 Dicas

- **Múltiplos arquivos por app**: coloque todos dentro da mesma pasta de módulo — o stow vincula recursivamente.
- **Forçar re-vinculação**: use `stow -R -t ~ <app>` para desinstalar e reinstalar o módulo de uma vez.
- **Ver o que o stow faria sem executar**: use `stow -n -v -t ~ <app>` (dry run com verbose).
- **Remover vínculos de um módulo**: `stow -D -t ~ <app>`.
