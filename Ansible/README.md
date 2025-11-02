## K3s Agent Automation with Ansible

This repository contains Ansible playbooks to **automate setup and maintenance of K3s agent nodes**. Tasks include:

* Syncing system time.
* Installing NFS for persistent storage.
* Deploying cluster status monitoring scripts.
* Configuring a private container registry.
* Provisioning new worker nodes.

Targets are defined in `inventory.ini` under `k3s_agents`, allowing consistent management of multiple nodes with minimal manual effort.

---

### 🕒 Ansible Playbook: Ensure System Time Synchronization on k3s Agents

**Filename:** `fix_clock.yml`

This Ansible playbook ensures accurate system time synchronization across all `k3s_agents` hosts using **systemd-timesyncd**.

**What it does:**

- Installs `systemd-timesyncd` if it's not already present.
- Enables and starts the `systemd-timesyncd` service to maintain time sync.
- Activates NTP synchronization via `timedatectl`.

This helps maintain consistent and reliable timestamps across your Kubernetes (k3s) agent nodes, which is crucial for logs, certificates, and cluster coordination.

---

### 📦 Ansible Playbook: Install and Verify NFS Support on k3s Agents

**Filename:** `install-nfs-common.yml`

This Ansible playbook installs and configures **NFS (Network File System)** utilities on all `k3s_agents` hosts to enable shared storage capabilities within your Kubernetes (k3s) cluster.

**What it does:**

- Updates the system’s package cache.
- Installs the `nfs-common` package (client utilities for NFS).
- Ensures the `nfs-common` service is enabled and running.
- Verifies the installation and displays a success message per host.
- Checks for NFS tool availability using `showmount`.

This setup is essential for enabling **persistent volumes** or **shared directories** across k3s nodes using NFS storage.

---

### 🩺 Ansible Playbook: Set Up Cluster Status Monitoring on k3s Agents

**Filename:** `notify-on-reboot.yml`
This Ansible playbook automates the deployment of a **cluster status monitoring script** across all `k3s_agents` nodes. It ensures that each node can report its status (e.g., to a Discord webhook) automatically on boot.

**What it does:**

- Copies a local monitoring script (`send-status.sh`) to `/usr/local/bin` on each k3s agent.
- Creates and installs a custom **systemd service** (`send-status.service`) to execute the script at boot.
- Reloads systemd and enables the service to ensure it runs automatically.
- Optionally supports scheduling the script to run hourly via cron (commented out for now).
- Tests the script execution and displays the result for verification.

This setup provides automated cluster health or status notifications — ideal for keeping track of node availability and startup events in lightweight Kubernetes (k3s) environments.

---

### 🐳 Ansible Playbook: Configure K3s Container Registry on Agent Nodes

**Filename:** `update-k3s-agent-registries.yml`
This playbook updates the **container registry configuration** for all `k3s_agents` by deploying a `registries.yaml` file.

**What it does:**

- Ensures the `/etc/rancher/k3s` directory exists with proper permissions.
- Deploys a `registries.yaml` file that configures a custom, insecure local registry at `192.168.2.3:5000`.
- Sets up both registry mirrors and TLS options to allow agents to pull images from the local registry without verification.

This is useful for environments using a **private container registry** to speed up image pulls or operate in air-gapped setups.

---

### ⚙️ Ansible Playbook: Set Up a Newly Added K3s Worker Node

**Filename:** `worker_setup.yml`
This Ansible playbook automates the setup of a newly added **K3s worker node** in your cluster. It prepares the system environment, applies visual customizations, and joins the node to the K3s control plane.

**What it does:**

- Defines node-specific variables such as hostname color and name formatting.
- Ensures key system directories (like `/boot/firmware`) exist and fixes kernel permissions automatically.
- Customizes the terminal prompt (`.bashrc`) to display the node’s name in color for easier identification.
- Updates the package cache and installs required dependencies (`fuse-overlayfs`).
- Sets the timezone to **Europe/Athens**.
- Downloads and installs the **K3s agent**, connecting it to the cluster via `K3S_URL` and `K3S_TOKEN`.
- Prints a completion message once setup is finished.

This playbook provides a **hands-free provisioning process** for new worker nodes, ensuring consistent configuration and seamless integration into your K3s cluster.
