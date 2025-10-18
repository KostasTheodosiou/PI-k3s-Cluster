# Automated OS Image Creation for Client Nodes

The process of creating OS images for the client nodes has been automated using shell (`.sh`) scripts.

---

## Process Overview

We start with a Linux image. In this example, we selected `ubuntu_server.img`. We use **kpartx** on this `.img` file to access its partitions.

### What is `kpartx`?

`kpartx` is a Linux command-line tool used to create device mappings for the partitions inside a disk image file or a block device.  
It allows Linux to treat the partitions inside a single image file as individual drives (e.g., `/dev/sda1`, `/dev/sda2`).

---

## Step 1: Apply `kpartx` to the Image

```bash
kpartx -a -v ubuntu_server.img
```

# Mounting and Configuring OS Image Partitions

After using `kpartx` on the image, the result is usually something like:

add map loop0p1 (253:0): 0 204800 linear 7:0 2048
add map loop0p2 (253:1): 0 1847296 linear 7:0 206848


---

## Step 2: Mount the Partitions

Mount the two mapped devices:

```bash
mount /dev/mapper/loop2p1 ./bootmnt/
mount /dev/mapper/loop2p2 ./rootmnt/
```

# NFS Network Boot Setup Guide

This guide covers the process of setting up a Raspberry Pi to boot over NFS (Network File System) from a network server.

## Copying Root Filesystem

Copy the contents of the root and boot filesystems to the NFS server at the correct locations:

```bash
cp -a ./rootmnt/* ./nfs/${PI_NAME}
cp -a ./bootmnt/* ./nfs/${PI_NAME}/boot
```

These commands recursively copy all files while preserving permissions and timestamps from the mounted directories to their corresponding NFS locations.

## Configuration Updates

Two critical files must be updated to enable NFS booting:

### Update /etc/fstab

Add an entry to the fstab file to mount the boot folder via NFS:

```bash
FSTAB_FILE="./etc/fstab"
echo "$192.169.2.1:/mnt/netboot_common/${PI_NAME} /boot nfs defaults,vers=3 0 0" >> $FSTAB_FILE
```

This configures the system to mount the boot partition from the NFS server at startup.

### Update /boot/commandline.txt

Configure the kernel boot parameters to enable NFS root filesystem mounting:

```bash
CMDLINE_FILE="/boot/cmdline.txt"
echo "console=serial0,115200 console=tty1 root=/dev/nfs nfsroot=192.168.1.100:/srv/netboot/pi-client,vers=3 rw ip=dhcp rootwait elevator=deadline" > $CMDLINE_FILE
```

## Kernel Boot Parameters Explained

The `commandline.txt` file contains several important kernel parameters that control the NFS boot process:

- **`root=/dev/nfs`** - Instructs the kernel to use NFS as the root filesystem instead of a local device.

- **`nfsroot=192.168.1.100:/srv/netboot/pi-client,vers=3`** - Specifies the NFS server IP address, the path to the client's root filesystem on the server, and the NFS protocol version to use.

- **`ip=dhcp`** - Configures the system to obtain its IP address dynamically via DHCP during the boot process.

- **`rw`** - Mounts the root filesystem as read-write, allowing the system to write to the filesystem during operation.

- **`console=serial0,115200 console=tty1`** - Enables serial console output at 115200 baud rate and enables text-mode console output for debugging and system messages.

- **`rootwait`** - Instructs the kernel to wait for the root device to become available before attempting to mount it, allowing time for network initialization.

- **`elevator=deadline`** - Sets the I/O scheduler to deadline mode, which can improve performance for NFS-based root filesystems by optimizing disk I/O request handling.