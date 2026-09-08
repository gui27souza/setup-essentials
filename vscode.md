# Fedora

```
# Importa a chave de segurança da Microsoft
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

# Adiciona o repositório do VS Code ao DNF
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo' 

# Atualiza o cache do DNF e instala o VS Code
sudo dnf check-update
sudo dnf install -y code
```
