#!/usr/bin/env bash
set -e

# ==============================================================================
# Setup rEFInd Bootloader no Disco Interno da Máquina Hospedeira
# Compatível com Arch Linux em SSD Externo (Multi-PC)
# ==============================================================================

if [ "$EUID" -ne 0 ]; then
    echo "[-] Erro: Este script precisa ser executado como root."
    echo "    Use: sudo $0"
    exit 1
fi

# Descobre o diretório raiz do repositório para salvar configs
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_REFIND_CONFIGS="${SETUP_ESSENTIALS_DIR:-$SCRIPT_DIR/..}/refind/configs"

echo "==> 1. Verificando dependências..."
pacman -S --needed --noconfirm refind

echo "==> 2. Configuração de Timeout..."
read -rp "    [?] Digite o timeout em segundos (0 para sem timeout, [10] padrão): " INPUT_TIMEOUT
TIMEOUT=${INPUT_TIMEOUT:-10}

echo "==> 3. Identificando discos e partições..."
ROOT_DEV=$(findmnt -n -o SOURCE / | sed 's/\[.*\]//')
ROOT_DISK=$(lsblk -no PKNAME "$ROOT_DEV" | head -n 1)

echo "    [*] SSD Externo (Root): $ROOT_DEV (Disco: /dev/$ROOT_DISK)"

INTERNAL_EFI=$(lsblk -lno NAME,FSTYPE,PKNAME | awk -v rdisk="$ROOT_DISK" '$2 == "vfat" && $3 != rdisk {print $1}' | head -n 1)

if [ -z "$INTERNAL_EFI" ]; then
    echo "[-] Erro: Nenhuma partição EFI (FAT32) interna encontrada em outros discos."
    exit 1
fi

echo "    [*] EFI Interna encontrada: /dev/$INTERNAL_EFI"

echo "==> 4. Verificando parâmetros de kernel no SSD externo..."
ROOT_UUID=$(blkid -s UUID -o value "$ROOT_DEV")
if [ ! -f /boot/refind_linux.conf ]; then
    cat <<EOF > /boot/refind_linux.conf
"Boot Arch Linux (Padrão)"    "root=UUID=$ROOT_UUID rootflags=subvol=@ rw quiet splash"
"Boot Arch Linux (Fallback)"  "root=UUID=$ROOT_UUID rootflags=subvol=@ rw single"
EOF
    echo "    [+] /boot/refind_linux.conf criado na raiz do SSD externo."
else
    echo "    [*] /boot/refind_linux.conf preservado sem alterações."
fi

echo "==> 5. Montando EFI interna temporariamente..."
MOUNT_POINT="/mnt/efi_target_temp"
mkdir -p "$MOUNT_POINT"
if mountpoint -q "$MOUNT_POINT"; then
    umount "$MOUNT_POINT"
fi
mount "/dev/$INTERNAL_EFI" "$MOUNT_POINT"

echo "==> 6. Instalando rEFInd na EFI interna..."
refind-install --usedefault "/dev/$INTERNAL_EFI" --alldrivers || refind-install --yes

REFIND_CONF="$MOUNT_POINT/EFI/refind/refind.conf"

if [ -f "$REFIND_CONF" ]; then
    echo "==> 7. Ajustando opções no $REFIND_CONF..."
    
    # Aplica o timeout escolhido
    sed -i "s/^#\?timeout .*/timeout $TIMEOUT/" "$REFIND_CONF"

    # Resolução padrão
    if ! grep -q "^resolution" "$REFIND_CONF"; then
        echo "resolution 1920 1080" >> "$REFIND_CONF"
    fi

    # Garante a busca interna e externa
    if ! grep -q "^scanfor" "$REFIND_CONF"; then
        echo "scanfor internal,external" >> "$REFIND_CONF"
    fi

    # Oculta o rEFInd do SSD externo (/EFI/refind) para evitar duplicação (ícone da lupa)
    if grep -q "^dont_scan_dirs" "$REFIND_CONF"; then
        sed -i 's|^dont_scan_dirs .*|dont_scan_dirs /EFI/boot, /EFI/systemd, /EFI/arch, /EFI/refind|' "$REFIND_CONF"
    else
        echo 'dont_scan_dirs /EFI/boot, /EFI/systemd, /EFI/arch, /EFI/refind' >> "$REFIND_CONF"
    fi

    if grep -q "^dont_scan_files" "$REFIND_CONF"; then
        sed -i 's|^dont_scan_files .*|dont_scan_files bootx64.efi, systemd-bootx64.efi, initramfs-linux-fallback.img|' "$REFIND_CONF"
    else
        echo 'dont_scan_files bootx64.efi, systemd-bootx64.efi, initramfs-linux-fallback.img' >> "$REFIND_CONF"
    fi

    # Salva a versão no repositório
    echo ""
    read -rp "    [?] Deseja registrar um backup desse .conf no repo? Informe o nome do perfil (ex: desktop) [Deixe em branco para pular]: " PROFILE_NAME

    if [ -n "$PROFILE_NAME" ]; then
        if [ -d "$REPO_REFIND_CONFIGS" ]; then
            TARGET_FILE="$REPO_REFIND_CONFIGS/${PROFILE_NAME}-refind.conf"
            cp "$REFIND_CONF" "$TARGET_FILE"

            # Se executado via sudo, ajusta a permissão do arquivo salvo para o usuário normal do git
            if [ -n "$SUDO_USER" ]; then
                chown "$SUDO_USER:" "$TARGET_FILE"
            fi
            echo "    [+] Configuração registrada em: $TARGET_FILE"
        else
            echo "    [!] Pasta de destino $REPO_REFIND_CONFIGS não encontrada. Backup ignorado."
        fi
    fi
fi

echo "==> 8. Desmontando partição temporária..."
umount "$MOUNT_POINT"
rmdir "$MOUNT_POINT"

echo ""
echo "=========================================================================="
echo " [OK] rEFInd instalado e configurado com sucesso na EFI interna!"
echo "=========================================================================="
echo " - Timeout configurado para: ${TIMEOUT}s."
echo " - Ocultado /EFI/refind externo para evitar o rEFInd duplicado (lupa)."
echo " - Entradas antigas do systemd-boot ignoradas."
echo "=========================================================================="
