# 🛠️ setup-essentials

Gerenciador de dotfiles, scripts de manutenção do sistema e automações para **Arch Linux**.

Para listagem de comandos, utilize:
```
esquecii
```

---

### 📂 Estrutura do Repositório

* **dotfiles/zsh/**: Configurações do Zsh (`.zshrc`) e funções modulares.
* **scripts/**: Automações do sistema, como atualização do Kernel na partição EFI.
* **system/pacman-hooks/**: Hooks do Pacman para execução automática pós-atualização.
* **pkglist.txt / pkglist-aur.txt**: Listas de pacotes oficiais e do AUR sincronizados.
* **pkglist-ignore.txt**: Deny-list de pacotes e dependências ignorados nas verificações.
* **manual_instalations.md**: Guia de softwares e ferramentas instalados fora dos gerenciadores.

---

### ⚡ Funções Principais

#### 1. `checar_geral`
Checagem passiva e rápida do sistema. Verifica atualizações pendentes no Pacman e AUR sem alterar pacotes, roda a verificação do `sync_pkglist` e exibe o status dos dotfiles.

#### 2. `dar_uma_geral`
Rotina completa de manutenção do Arch Linux. Realiza as seguintes etapas:
* Atualização completa dos pacotes oficiais via Pacman.
* Atualização dos pacotes do AUR via Yay.
* Atualização e remoção de Flatpaks não utilizados.
* Detecção e remoção limpa de pacotes órfãos.
* Limpeza de caches mantendo versões atuais para rollback de emergência.

#### 3. `sync_pkglist`
Módulo interativo de sincronização de pacotes. Detecta softwares novos instalados no sistema e permite decidir interativamente se devem ir para o repositório (`pkglist.txt`), para a deny-list (`pkglist-ignore.txt`) ou se serão pulados.

#### 4. `sync_dotfiles`
Sincroniza automaticamente as listas de pacotes e empurra as alterações locais dos dotfiles para o repositório Git remoto com timestamp no commit.

#### 5. `check_dotfiles_status`
Valida se existem alterações pendentes no repositório local em relação ao remoto.

---

### 🛠️ Instalação e Uso

Para clonar e aplicar os symlinks de configuração na sua máquina:

```
git clone https://github.com/gui27souza/setup-essentials.git
cd setup-essentials
chmod +x install.sh
./install.sh
```

---

### 📌 Pré-requisitos

Para suporte completo a todos os recursos das rotinas, certifique-se de ter instalado:

```
sudo pacman -S pacman-contrib yay flatpak git
```
