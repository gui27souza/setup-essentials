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


### Novos Comandos de Produtividade para o esquecii

- system/saude_ssd.zsh (Guardião do SSD Externo)
    - Como o sistema vive num SSD USB, a saúde do disco e a integridade da conexão são vitais.
    - Executa um smartctl rápido para monitorar temperatura, vida útil do SSD e roda um btrfs scrub passivo para garantir que nenhum bloco de dados foi corrompido por desconexões
    acidentais.
