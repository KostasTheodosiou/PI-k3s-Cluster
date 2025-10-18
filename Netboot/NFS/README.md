# NFS Server Setup

The network file share that the Raspberry Pis use to mount is provided by the NFS server.

## Installation

Install the NFS server with:

```bash
sudo apt install nfs-kernel-server
```

# NFS Directory Export for Raspberry Pis

In order for the Pis to finish booting, they need to mount both the **root directory** and the **/boot folder**.  
We can therefore expose these directories over NFS for every Pi.

## Configuration File

The configuration is done inside:

### `/etc/exports`

### Example

/mnt/netboot_common/nfs/red1 _(rw,sync,no_subtree_check,no_root_squash)
/mnt/netboot_common/nfs/red1/boot _(rw,sync,no_subtree_check,no_root_squash)

### Option Explanations

- `rw` → Read/write access
- `sync` → Synchronous writes
- `no_subtree_check` → Disables subtree checking for performance
- `no_root_squash` → Allows root on client to act as root on server
