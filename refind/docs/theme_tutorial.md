# Como colocar um tema no rEFInd do zero

1. Localizar partição do refind
    - O primeiro passo é identificar em qual partição da máquina o rEFInd está no dado dispoitivo
    - Possivelmente será necessário montar a partição pois geralmente ela se localiza de forma externa ao SO rodando

2. Acessar a pasta `refind`
    - Na partição reservada, é necessário encontrar a pasta específica do refind, que contém por exemplo, o arquivo central de configuração `refind.conf`
    - Ela deve ser parecer com algo do tipo:
    ```zsh
        ➜  refind tree -a -I "*.png" -I "*.svg"
        .
        ├── BOOT.CSV
        ├── icons
        │   └── svg
        ├── keys
        ├── refind.conf
        ├── refind_x64.efi
        └── vars
            ├── HiddenTags
            └── PreviousBoot

        5 directories, 5 files
        ➜  refind pwd
        /mnt/efi_interna/EFI/refind
        ➜  refind 
    ```

3. Criar uma pasta de temas em `refind/`
    ```zsh
        .
        ├── BOOT.CSV
        ├── icons
        │   └── svg
        ├── keys
        ├── refind.conf
        ├── refind_x64.efi
        ├── themes
        └── vars
            ├── HiddenTags
            └── PreviousBoot
    ```
