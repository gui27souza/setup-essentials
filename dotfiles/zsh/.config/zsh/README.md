# 🐚 Configuração e Funções Modulares do Zsh

Esta pasta concentra todas as automações, atalhos e rotinas do terminal divididas por responsabilidade. Todas as funções dentro deste diretório são carregadas dinamicamente pelo `.zshrc`.

---

### 📂 Estrutura de Diretórios

* **`apps/`**: Atalhos e inicializadores de aplicações de terminal.
* **`git/`**: Scripts de sincronização e validação dos dotfiles com o repositório remoto.
* **`helpers/`**: Comandos de auxílio, help interativo e utilitários rápidos.
* **`system/`**: Rotinas essenciais de manutenção do Arch Linux e gestão de pacotes.

---

### 🪄 O Padrão `esquecii`

Para manter o help do terminal sempre atualizado de forma automática, todas as funções seguem a convenção do comentário no cabeçalho:

```zsh
# ZSH_DESC - Descrição curta do que este comando faz
```

Ao executar `esquecii` no terminal, o script varre todas as subpastas, lê essa tag e monta o índice categorizado dinamicamente.

---

### ➕ Como Adicionar um Novo Comando

> [!IMPORTANT]
> **A Regra de Ouro (1 comando por arquivo)**: O nome do arquivo `.zsh` deve ser **estritamente idêntico ao nome da função** (ex: `open_konsole.zsh` deve declarar `open_konsole()`). Isso é essencial para que o `esquecii` documente o nome exato que o usuário vai digitar no terminal.

1. Escolha ou crie a pasta da categoria apropriada (ex: `apps/`, `system/`, etc.).
2. Crie o arquivo `<nome_do_comando>.zsh`.
3. Adicione o cabeçalho descritivo na primeira linha e declare a função com o mesmo nome:
   ```zsh
   # ZSH_DESC - Minha nova automação incrível

   nome_do_comando() {
       echo "Executando..."
   }
   ```
4. Abra um novo terminal ou rode `exec zsh` para carregar a função.
