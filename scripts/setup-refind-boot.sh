#!/usr/bin/env bash
set -e

# ==============================================================================
# Setup rEFInd Bootloader no Disco Interno da Máquina
# Compatível com Arch Linux em SSD Externo (Multi-PC)
# ==============================================================================

if [ "$EUID" -ne 0 ]; then
    echo "[-] Erro: Este script precisa ser executado como root."
    echo "    Use: sudo $0"
    exit 1
fi

echo "==> 1. Verificando dependências..."
pacman -S --needed --noconfirm refind

echo "==> 2. Identificando discos e partições..."
ROOT_DEV=$(findmnt -n -o SOURCE / | sed 's/\[.*\]//')
ROOT_DISK=$(lsblk -no PKNAME "$ROOT_DEV" | head -n 1)

echo "    [*] SSD Externo (Root): $ROOT_DEV (Disco: /dev/$ROOT_DISK)"

INTERNAL_EFI=$(lsblk -lno NAME,FSTYPE,PKNAME | awk -v rdisk="$ROOT_DISK" '$2 == "vfat" && $3 != rdisk {print $1}' | head -n 1)

if [ -z "$INTERNAL_EFI" ]; then
    echo "[-] Erro: Nenhuma partição EFI (FAT32) interna encontrada em outros discos."
    exit 1
fi

echo "    [*] EFI Interna encontrada: /dev/$INTERNAL_EFI"

echo "==> 3. Configurando /boot/refind_linux.conf no SSD externo..."
ROOT_UUID=$(blkid -s UUID -o value "$ROOT_DEV")
if [ ! -f /boot/refind_linux.conf ]; then
    cat <<EOF > /boot/refind_linux.conf
"Boot Arch Linux (Padrão)"    "root=UUID=$ROOT_UUID rootflags=subvol=@ rw quiet splash"
"Boot Arch Linux (Fallback)"  "root=UUID=$ROOT_UUID rootflags=subvol=@ rw single"
EOF
    echo "    [+] /boot/refind_linux.conf criado com sucesso."
else
    echo "    [*] /boot/refind_linux.conf já existe. Mantendo configurações existentes."
fi

echo "==> 4. Montando EFI interna em /efi para instalação..."
mkdir -p /efi
if mountpoint -q /efi; then
    umount /efi
fi
mount "/dev/$INTERNAL_EFI" /efi

echo "==> 5. Instalando rEFInd na EFI interna (/dev/$INTERNAL_EFI)..."
refind-install --yes

REFIND_CONF="/efi/EFI/refind/refind.conf"
if [ -f "$REFIND_CONF" ]; then
    echo "==> 6. Ajustando opções no $REFIND_CONF..."
    
    # 1. Sem timeout: espera sua seleção sem contagem regressiva
    sed -i 's/^#\?timeout .*/timeout 0/' "$REFIND_CONF"
    
    # 2. Seleção inicial do cursor focada no Arch Linux se disponível, ou Windows
    if grep -q "^default_selection" "$REFIND_CONF"; then
        sed -i 's/^default_selection .*/default_selection "vmlinuz,Arch,bootmgfw,Microsoft"/' "$REFIND_CONF"
    else
        echo 'default_selection "vmlinuz,Arch,bootmgfw,Microsoft"' >> "$REFIND_CONF"
    fi

    # 3. Oculta entradas duplicadas/legadas do systemd-boot para menu limpo
    if ! grep -q "dont_scan_dirs.*EFI/systemd" "$REFIND_CONF"; then
        echo 'dont_scan_dirs "EFI/systemd,EFI/arch"' >> "$REFIND_CONF"
        echo 'dont_scan_files "systemd-bootx64.efi,systemd-boot-fallbackx64.efi"' >> "$REFIND_CONF"
    fi
fi

echo "==> 7. Desmontando /efi..."
umount /efi

echo ""
echo "=========================================================================="
echo " [OK] rEFInd instalado e configurado com sucesso na EFI interna!"
echo "=========================================================================="
echo " - Na BIOS desta máquina, a prioridade máxima agora é 'rEFInd Boot Manager'."
echo " - Sem timeout: a tela do rEFInd aguarda sua seleção com o cursor já pré-posicionado."
echo " - Entradas antigas do systemd-boot foram ocultadas para manter a interface limpa."
echo " - Execute este mesmo script caso queira habilitar o boot em outro PC."
echo "=========================================================================="
