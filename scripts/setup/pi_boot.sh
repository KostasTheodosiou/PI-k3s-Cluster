#!/bin/bash

#Aυτόματο netboot config 

# Έλεγχος παραμέτρων
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <PI_NAME> <MAC_ADDRESS> <SERIAL_NUMBER>"
    exit 1
fi

# Μεταβλητές
PI_NAME=$1
MAC_ADDRESS=$2
PI_SERIAL=$3
SERVER_IP="192.168.2.1"
IMG_PATH="/mnt/netboot_common/ubuntu_server.img"
NETBOOT_DIR="/mnt/netboot_common"
NFS_DIR="${NETBOOT_DIR}/nfs"
BOOTMNT="${NETBOOT_DIR}/bootmnt"
ROOTMNT="${NETBOOT_DIR}/rootmnt"
LOOP_DEVICE="/dev/mapper/loop2"

# Προετοιμασία image
cd $NETBOOT_DIR || exit
kpartx -a -v $IMG_PATH

# Δημιουργία directories
mkdir -p $BOOTMNT
mkdir -p $ROOTMNT

# Mount partitions
mount "${LOOP_DEVICE}p1" $BOOTMNT
mount "${LOOP_DEVICE}p2" $ROOTMNT

# Δημιουργία του NFS directory για το νέο Pi
mkdir -p $NFS_DIR/${PI_NAME}
cp -a $ROOTMNT/* $NFS_DIR/${PI_NAME}
cp -a $BOOTMNT/* $NFS_DIR/${PI_NAME}/boot

# Καθαρισμός παλιών αρχείων
#cd $NFS_DIR/${PI_NAME}/boot || exit
#rm -f issue.txt
#rm -rf overlays

# Αντιγραφή του overlays από το αρχικό bootmnt
cp -r $BOOTMNT/overlays .

# Unmount των partitions
umount $BOOTMNT
umount $ROOTMNT

# Ενημέρωση του fstab
FSTAB_FILE="${NFS_DIR}/${PI_NAME}/etc/fstab"
echo "${SERVER_IP}:$NFS_DIR/${PI_NAME} /boot nfs defaults,vers=3 0 0" >> $FSTAB_FILE

# Ενημέρωση του cmdline.txt
CMDLINE_FILE="${NFS_DIR}/${PI_NAME}/boot/cmdline.txt"
echo "console=serial0,115200 console=tty1 root=/dev/nfs nfsroot=${SERVER_IP}:/mnt/netboot_common/nfs/${PI_NAME},vers=3 rw ip=dhcp rootwait elevator=deadline" > $CMDLINE_FILE

# Ενημέρωση του /etc/exports στο server
EXPORTS_FILE="/etc/exports"
if ! grep -q "${NFS_DIR}/${PI_NAME}" $EXPORTS_FILE; then
    echo "${NFS_DIR}/${PI_NAME} *(rw,sync,no_subtree_check,no_root_squash)" >> $EXPORTS_FILE
    echo "${NFS_DIR}/${PI_NAME}/boot *(rw,sync,no_subtree_check,no_root_squash)" >> $EXPORTS_FILE
fi

# Δημιουργία symbolic link για το TFTP
cd $NFS_DIR || exit
ln -s ${PI_NAME}/boot ${PI_SERIAL}

# Επανεκκίνηση για εφαρμογή των αλλαγών
# reboot

