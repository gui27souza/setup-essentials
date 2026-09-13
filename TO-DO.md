### Super Pkg Lists

- Refinar pkglist
    - Criar tipos de listas: obrigatorias, opcionais, etc
    - Melhorar experiência do script, escolher oq baixar


### Superpoderes de Git & Repositórios

- git-clone-sync (O Clonador Interativo com gh + fzf)
    - O que faz: Um comando que conecta na sua conta do GitHub via gh, lista todos os seus repositórios do perfil e abre um menu interativo com fzf.
    - Recursos:
        - Filtro com TAB para selecionar vários repos de uma vez e clonar em lote para ~/projetos-git/.
        - Flag --last-month: lista apenas repos onde houve commit no último mês.
    - Por que vale a pena: Em 10 segundos você restaura todos os seus projetos ativos em qualquer lugar.

- git/status_geral.zsh (O Radar de Projetos)
    - O que faz: Varre todas as pastas dentro de ~/projetos-git/ e avisa se você esqueceu alterações não commitadas ou commits locais que não foram empurrados para o GitHub em algum
    projeto.
    - Por que vale a pena: Nunca mais passar pela raiva de ir pro outro PC e perceber que deixou código não commitado no PC anterior!


### A Blindagem Suprema: Rollback com Btrfs & Snapper
Como o seu SSD externo está formatado em Btrfs (com subvolumes @, @home), você tem em mãos a arma mais poderosa do Linux: Snapshots Instantâneos.
- system/snapshot_pre_update.zsh (ou hook automático no dar_uma_geral):
    - Antes de atualizar pacotes, cria um snapshot do subvolume @ em menos de 1 segundo (sem gastar espaço extra de disco).
    - Se um dia uma atualização do Arch quebrar o driver de vídeo ou o KDE, você dá rollback para o estado de 5 minutos atrás e o sistema volta a funcionar como se nada tivesse acontecido.
    - O rEFInd pode até ser configurado para listar esses snapshots direto na tela de boot!


### Consciência Multi-PC (Detecção Inteligente de Hardware)

Como você usa o mesmo Arch em 2 computadores diferentes:
- system/detect_host.zsh (Script de Perfil da Máquina)
    - Lê o hardware atual via /sys/class/dmi/id/product_name ou GPU ativa.
    - Aplicações práticas:
        - Monitores & Escala: Se o PC 1 usa monitor 1080p (escala 100%) e o PC 2 usa monitor 4K (escala 125%/150%), um script pode ajustar a escala do KDE ou comandos de display automaticamente ao logar.
        - Áudio Padrão: Define a saída de áudio correta automaticamente para cada computador (ex: caixa de som USB no PC 1 vs saída da placa no PC 2).


### Novos Comandos de Produtividade para o esquecii

- apps/open_project.zsh (Fuzzy Project Launcher)
    - Você digita open_project (ou cria um alias p), o terminal abre uma busca fuzzy (fzf) com todas as pastas de ~/projetos-git/.
    - Ao dar Enter, ele abre o projeto no VS Code e navega o terminal para a pasta na hora.
- system/saude_ssd.zsh (Guardião do SSD Externo)
    - Como o sistema vive num SSD USB, a saúde do disco e a integridade da conexão são vitais.
    - Executa um smartctl rápido para monitorar temperatura, vida útil do SSD e roda um btrfs scrub passivo para garantir que nenhum bloco de dados foi corrompido por desconexões
    acidentais.
- system/limpar_lixo.zsh
    - Limpa caches de navegadores, lixeira, logs do sistema com mais de 7 dias (journalctl --vacuum-time=7d) e limpa caches temporários de pacotes.


### Expandindo o GNU Stow para outros Dotfiles

- Hoje o Stow cuida de forma brilhante do zsh/. Você pode criar novos pacotes dentro de dotfiles/:
    - dotfiles/git/: Seu .gitconfig (seus aliases do git, suas configurações de commit, seu nome e email).
    - dotfiles/kitty/ ou dotfiles/konsole/: Suas preferências de fonte, cores, transparência e atalhos de terminal.
    - dotfiles/lazygit/: Suas configurações personalizadas do Lazygit (config.yml).
    - dotfiles/plasma/: Atalhos de teclado personalizados do KDE Plasma (para nunca mais ter que remapear teclas na mão se formatar).


### Tema Cyberpunk no rEFInd (Estética 2077)

- Já que você tem o tema actually-2077 no VS Code:
    - O rEFInd suporta temas gráficos completos (ícones estilizados, fontes customizadas, fundo escuro/neon minimalista).
    - Você pode adicionar uma pasta scripts/boot/themes/ e aplicar um tema Cyberpunk no rEFInd para quando você ligar qualquer um dos seus dois PCs, a tela de boot já ter a sua identidade visual!
