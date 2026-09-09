#!/bin/bash
# Script para sincronizar o Kernel atualizado com a EFI interna da máquina ativa

# 1. Tenta montar a EFI do NVMe interno se ela não estiver montada
EFI_MOUNT="/mnt/efi_windows"
mkdir -p "$EFI_MOUNT"

# Procura por partições EFI/FAT32 conhecidas no NVMe da máquina atual
if ! mountpoint -q "$EFI_MOUNT"; then
    INTERNAL_EFI=$(lsblk -lno NAME,FSTYPE,PARTLABEL | grep -iE 'vfat|fat32|system_drv' | grep -i 'nvme' | head -n 1 | awk '{print $1}')
    if [ -n "$INTERNAL_EFI" ]; then
        mount "/dev/$INTERNAL_EFI" "$EFI_MOUNT" 2>/dev/null
    fi
fi

# 2. Se a EFI estiver montada e tiver a pasta do Arch, sincroniza os arquivos
if mountpoint -q "$EFI_MOUNT" && [ -d "$EFI_MOUNT/EFI/arch" ]; then
    echo "==> Sincronizando Kernel atualizado para a EFI interna ($EFI_MOUNT)..."
    cp -f /boot/vmlinuz-linux "$EFI_MOUNT/EFI/arch/"
    cp -f /boot/initramfs-linux.img "$EFI_MOUNT/EFI/arch/"
    [ -f /boot/intel-ucode.img ] && cp -f /boot/intel-ucode.img "$EFI_MOUNT/EFI/arch/" 2>/dev/null
    [ -f /boot/amd-ucode.img ] && cp -f /boot/amd-ucode.img "$EFI_MOUNT/EFI/arch/" 2>/dev/null
    echo "==> Kernel da EFI interna atualizado com sucesso!"
    umount "$EFI_MOUNT" 2>/dev/null
fi
