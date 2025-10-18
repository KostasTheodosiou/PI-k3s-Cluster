# Cluster Network Configuration

## Overview

The cluster uses a **DHCP server** to allow Raspberry Pis (PIs) to join the local network and receive directions for network booting.  
Since all hardware is identical, **static IP assignments** by MAC address are used for consistency and control.

---

## IP Address Assignments

### Core Nodes

| Role         | Hostname       | IP Address    |
| ------------ | -------------- | ------------- |
| Login Node   | `login-node`   | `192.168.2.1` |
| MLOps Master | `mlops_master` | `192.168.2.2` |
| Backup Node  | `backup-node`  | `192.168.2.3` |

---

### MLOps Workers

| Group     | Host Range          | IP Range                      |
| --------- | ------------------- | ----------------------------- |
| Green1–8  | `green1`–`green8`   | `192.168.2.20`–`192.168.2.27` |
| Yellow1–8 | `yellow1`–`yellow8` | `192.168.2.28`–`192.168.2.35` |

---

### HPC Workers

| Group   | Host Range      | IP Range                        |
| ------- | --------------- | ------------------------------- |
| Red1–8  | `red1`–`red8`   | `192.168.2.101`–`192.168.2.108` |
| Blue1–8 | `blue1`–`blue8` | `192.168.2.109`–`192.168.2.116` |

---

# ISC DHCP Server Configuration

We use **isc-dhcp-server** as our DHCP server.

## Installation

Install the DHCP server with:

````bash
sudo apt install isc-dhcp-server

## Global DHCP Settings

```conf
authoritative;          # This DHCP server is the official one for the network
default-lease-time 600; # Default lease duration: 600 seconds (10 minutes)
max-lease-time 7200;    # Maximum lease duration: 7200 seconds (2 hours)
allow bootp;            # Enable BOOTP for PXE/network booting
allow booting;          # Allow network clients to boot from this server
````

# DHCP Host Configuration Options

Each host on the network requires the following three options:

- **hardware ethernet**: The MAC address of the device
- **fixed-address**: The statically assigned IP address
- **option tftp-server-name**: Specifies the TFTP server to use for PXE boot

