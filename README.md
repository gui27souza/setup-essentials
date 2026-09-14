# 🛠️ setup-essentials

Ambiente **Arch Linux portátil, modular e reproduzível** para uso multi-máquina via SSD externo.

---

### 🎯 Filosofia & Propósito

* **Portabilidade Real**: O sistema operacional vive no SSD externo e roda nativamente em múltiplos computadores, sem tocar no sistema operacional nativo dos PCs e sem perder a prioridade de boot na BIOS.
* **Restauração Pós-Desastre**: Recuperação completa do ambiente — pacotes oficiais, AUR, dotfiles e automações — com uma única execução do script de instalação.
* **Governança de Pacotes**: Controle ativo entre softwares essenciais e dependências temporárias através de listas sincronizadas (`pkglist.txt`) e deny-list (`pkglist-ignore.txt`).
* **Modularidade**: Configurações desacopladas via GNU Stow e rotinas modulares organizadas por domínio.
* **Descoberta Dinâmica**: Nada de comandos esquecidos ou documentações pesadas no README. No terminal, basta digitar:
  ```bash
  esquecii
  ```

---

### 🚀 Instalação Rápida

#### 1. Restaurar Dotfiles e Pacotes (Máquina Nova ou Reparo)
```bash
git clone https://github.com/gui27souza/setup-essentials.git
cd setup-essentials
chmod +x install.sh
./install.sh
```

#### 2. Configurar Bootloader na Máquina Hospedeira (Opcional / Por PC)
Para habilitar o boot limpo via rEFInd na partição interna de um novo computador sem perder a ordem da BIOS:
```bash
sudo ./scripts/boot/setup-refind-boot.sh
```

---

### 📂 Estrutura do Repositório

| Módulo | Descrição |
| :--- | :--- |
| [**`dotfiles/`**](dotfiles/DOTFILES.md) | Dotfiles gerenciados via GNU Stow — guia completo de como adicionar e vincular configs. |
| [**`kde/`**](kde/README.md) | Backup das configs do KDE geradas via konsole. |
| [**`scripts/boot/`**](scripts/boot/README.md) | Automação do rEFInd para inicialização portátil em máquinas hospedeiras. |
| [**`vscode/`**](vscode/README.md) | Tema e customizações de interface para o VS Code. |
| [**`manual_instalations.md`**](manual_instalations.md) | Registro de ferramentas instaladas fora dos gerenciadores de pacote. |
| [**`TO-DO.md`**](TO-DO.md) | Backlog de ideias e melhorias para o ambiente. |

---

### 📌 Pré-requisitos

```bash
sudo pacman -S --needed pacman-contrib yay flatpak git stow
```
