### 1. **SSH Key Distribution Script**

**Filename:** `copy_ssh_keys.sh`
**Description:**
Copies a central public SSH key to multiple worker nodes’ `authorized_keys` for both `ubuntu` and `root` users.

- Checks if the `.ssh` directories exist and creates them if needed.
- Avoids duplicating keys in `authorized_keys`.
- Sets correct permissions for `.ssh` directories and files.

---

### 2. **Custom Prompt Script**

**Filename:** `fancy_names.sh`
**Description:**
Updates the `.bashrc` of a given worker node to use a custom colored command prompt.

- Validates input node name (`green1..green8` or `yellow1..yellow8`).
- Assigns 256-color ANSI sequences based on node color.
- Removes old definitions before adding the new one.

---

### 3. **Automated Worker SSH Setup**

**Filename:** `worker_ssh.sh`
**Description:**
Prepares a worker node for SSH access from the master node.

- Reads the worker IP from `pi_info.txt`.
- Removes old SSH host keys and accepts the new host key.
- Adds the master node’s public key to the worker’s `authorized_keys`.
- Optional: Adjusts SSH port settings.

---

### 4. **Kernel Permissions Fix Script**

**Filename:** `zzz-chmod-vmlinuz.sh`
**Description:**
Automates fixing permissions for kernel images on multiple worker nodes.

- Loops through all worker nodes (`green1..green8` and `yellow1..yellow8`).
- Creates a `postinst` hook script `zzz-chmod-vmlinuz` if it does not exist.
- Sets `/boot/vmlinuz-*` files to `0644` after kernel installation.

---

### 5. Νotify discord in reboot

**Filename:** `send-status.sh`
**Description:**

sends a notification to a specified Discord webhook after a system reboot. It gathers basic system information — hostname, IP address, and current time — and formats it into a Discord embed message. The script includes retry logic (up to 3 attempts with 10-second delays) to ensure the message is successfully delivered even if the first attempts fail.
