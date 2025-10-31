# Installation of Kubernetes Orchestration Software – K3s

The installation of **K3s** is straightforward, but our setup requires certain configurations to ensure compatibility with the storage system and container runtime environment.

---

## 1. Background

When **K3s** (or Kubernetes) runs a container, it uses the **container runtime** `containerd`, which relies on **overlay filesystems** (such as `overlayfs`) to manage container layers.

However, **NFS does not fully support `overlayfs`** requirements.

---

## 2. The Solution: `fuse-overlayfs`

`fuse-overlayfs` is a **userspace implementation** of the Linux **OverlayFS** filesystem.  
It provides the same functionality as the kernel’s OverlayFS but runs **in user space** using **FUSE (Filesystem in Userspace)**.

This makes it possible for `containerd` to function correctly on top of NFS or other filesystems that don’t natively support OverlayFS.

---

## 3. Installation of `fuse-overlayfs`

`fuse-overlayfs` must be installed on **all devices running K3s**, including both **worker** and **master** nodes.

### Manual Installation

```bash
sudo apt install fuse-overlayfs
```

### Automated Installation (Using Ansible)

Installation on all worker nodes has been automated using **Ansible** with the `install-fuse.yml` playbook.

Run the following command:

```bash
ansible-playbook -i inventory.ini install-fuse.yml
```

---

## 4. Installing K3s on the Master Node

The installation of K3s on the master node is straightforward using the official installation script provided by Rancher:

```bash
curl -sfL https://get.k3s.io | sh -s - server --snapshotter=fuse-overlayfs
```

- `server` → Specifies that this node is the **K3s master (control plane)**
- `--snapshotter=fuse-overlayfs` → Configures K3s to use **fuse-overlayfs** as the container snapshotter

---

## 5. installing K3s on Client Nodes

Here’s your content formatted as a clean, professional **Markdown (`.md`) file**:

````markdown
# Installing K3s on Client Nodes

To install **K3s** on the client (worker) nodes, a token generated during the **initial installation of the K3s master node** is required.

---

## 1. Retrieve the K3s Node Token

The token is created automatically on the **K3s server** during installation.  
You can obtain it using the following command:

```bash
sudo cat /var/lib/rancher/k3s/server/node-token
```
````

## 2. Configure Environment Variables

Before running the installation script on each client node, set the following environment variables.

### Environment Variables

| Variable                                 | Description                                                            |
| ---------------------------------------- | ---------------------------------------------------------------------- |
| `K3S_NODE_NAME={{ inventory_hostname }}` | Sets the node name to the Ansible inventory hostname                   |
| `K3S_URL={{ k3s_url }}`                  | Points to the K3s server API endpoint, e.g. `https://192.168.2.2:6443` |
| `K3S_TOKEN={{ k3s_token }}`              | Authentication token used to join the cluster                          |
| `INSTALL_K3S_EXEC="..."`                 | Additional K3s options (see below)                                     |
| `INSTALL_K3S_SKIP_SSL_VERIFY=true`       | Skips SSL certificate verification (useful for internal or lab setups) |

---

```bash
INSTALL_K3S_EXEC="--snapshotter=fuse-overlayfs \
--kubelet-arg=runtime-request-timeout=5m \
--kubelet-arg=node-status-update-frequency=10s"
```

- `--snapshotter=fuse-overlayfs` → Use FUSE-based overlay filesystem
- `--kubelet-arg=runtime-request-timeout=5m` → Extend timeout for container runtime requests
- `--kubelet-arg=node-status-update-frequency=10s` → Set how often node status updates occur

---

## 3. Run the Installation Script

Once all variables are set, run the installation script:

```bash
./install-k3s.sh
```

This will install and configure **K3s agent** on the client node, joining it to the existing cluster using the provided token and server URL.
