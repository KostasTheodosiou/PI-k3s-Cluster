# TFTP Server Setup

After the Raspberry Pis join the network with their assigned IPs, they look for the TFTP server that provides them with the necessary files to boot.

We use **tftp-hpa** as the TFTP server.

## Installation

Install the TFTP server with:

```bash
sudo apt install tftp-hpa
```

the configurations for the tftp server are inside /etc/default/tftp
in the server configurations, we assign a root directory, inside /mnt/netboot_common/nfs
