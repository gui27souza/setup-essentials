# 🐚 Configuração e Funções Modulares do Zsh

Esta pasta concentra todas as automações, atalhos e rotinas do terminal divididas por responsabilidade. Todas as funções dentro deste diretório são carregadas dinamicamente pelo `.zshrc`.

---

### 📂 Estrutura de Diretórios

* **`apps/`**: Atalhos e inicializadores de aplicações de terminal (`open_agy`, `open_lazygit`).
* **`git/`**: Scripts de sincronização e validação dos dotfiles com o repositório remoto (`sync_dotfiles`, `check_dotfiles`).
* **`helpers/`**: Comandos de auxílio, help interativo e utilitários rápidos (`esquecii`).
* **`system/`**: Rotinas essenciais de manutenção do Arch Linux e gestão de pacotes (`dar_uma_geral`, `checar_geral`, `sync_pkglist`).

---

### 🪄 O Padrão `esquecii`

Para manter o help do terminal sempre atualizado de forma automática, todas as funções seguem a convenção do comentário no cabeçalho:

```zsh
# ZSH_DESC - Descrição curta do que este comando faz
```

Ao executar `esquecii` no terminal, o script varre todas as subpastas, lê essa tag e monta o índice categorizado dinamicamente.

---

### ➕ Como Adicionar um Novo Comando

1. Escolha ou crie a pasta da categoria apropriada (ex: `apps/`, `system/`, etc.).
2. Crie o arquivo `<nome_do_comando>.zsh`.
3. Adicione o cabeçalho descritivo na primeira linha:
   ```zsh
   # ZSH_DESC - Minha nova automação incrível

   minha_funcao() {
       echo "Executando..."
   }
   ```
4. Abra um novo terminal ou rode `exec zsh` para carregar a função.
