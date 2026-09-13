# 🎨 kde-plasma

Gerenciamento e preservação do perfil de interface, atalhos e layout do **KDE Plasma** através do [Konsave](https://github.com/Prayag2/konsave).

---

### 📂 Estrutura

* **`plasma-gui.knsv`**: Arquivo compactado contendo o backup completo das configurações visuais, atalhos do KWin, painéis, widgets e esquemas de cores.

---

### 🛠️ Comandos Relacionados (Zsh)

Todas as operações são gerenciadas via funções do terminal:

| Comando | Descrição |
| :--- | :--- |
| **`sync_kde`** | Exporta as configurações atuais do Plasma sobrescrevendo o perfil no repositório. |
| **`check_kde_status`** | Exibe a data e hora da última exportação do perfil salva no repositório. |
| **`checar_geral`** | Roda a verificação do sistema e inclui o status do backup do KDE. |
| **`sync_dotfile`** | Faz um commit automatizado geral do repositório, usar para salvar a config de forma rápida. |

---

### 🚀 Aplicação Manual

Para aplicar o perfil salvo em uma nova instalação sem rodar o `install.sh` completo:

```bash
set_knsv_config.zsh
```