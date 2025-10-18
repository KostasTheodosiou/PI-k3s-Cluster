#!/bin/bash

# Path to your public key
PUBKEY="/mnt/netboot_common/nfs/MLops_master/home/ubuntu/.ssh/id_ed25519.pub"

# Check that the key exists
if [ ! -f "$PUBKEY" ]; then
    echo "❌ Public key not found at $PUBKEY"
    exit 1
fi

# Define the target directories (edit as needed)
#DIRS=(
#	"/mnt/netboot_common/nfs/green1/home/ubuntu/.ssh"
#	"/mnt/netboot_common/nfs/green2/home/ubuntu/.ssh"
#	"/mnt/netboot_common/nfs/green3/home/ubuntu/.ssh"
#	"/mnt/netboot_common/nfs/green4/home/ubuntu/.ssh"
#	"/mnt/netboot_common/nfs/green5/home/ubuntu/.ssh"
#	"/mnt/netboot_common/nfs/green6/home/ubuntu/.ssh"
#	"/mnt/netboot_common/nfs/green7/home/ubuntu/.ssh"
#	"/mnt/netboot_common/nfs/green8/home/ubuntu/.ssh"
#	"/mnt/netboot_common/nfs/yellow1/home/ubuntu/.ssh"
#	"/mnt/netboot_common/nfs/yellow2/home/ubuntu/.ssh"
#	"/mnt/netboot_common/nfs/yellow3/home/ubuntu/.ssh"
#	"/mnt/netboot_common/nfs/yellow4/home/ubuntu/.ssh"
#	"/mnt/netboot_common/nfs/yellow5/home/ubuntu/.ssh"
#	"/mnt/netboot_common/nfs/yellow6/home/ubuntu/.ssh"
#	"/mnt/netboot_common/nfs/yellow7/home/ubuntu/.ssh"
#	"/mnt/netboot_common/nfs/yellow8/home/ubuntu/.ssh"
#)

DIRS=(
       "/mnt/netboot_common/nfs/green1/root/.ssh"
       "/mnt/netboot_common/nfs/green2/root/.ssh"
       "/mnt/netboot_common/nfs/green3/root/.ssh"
       "/mnt/netboot_common/nfs/green4/root/.ssh"
       "/mnt/netboot_common/nfs/green5/root/.ssh"
       "/mnt/netboot_common/nfs/green6/root/.ssh"
       "/mnt/netboot_common/nfs/green7/root/.ssh"
       "/mnt/netboot_common/nfs/green8/root/.ssh"
       "/mnt/netboot_common/nfs/yellow1/root/.ssh"
       "/mnt/netboot_common/nfs/yellow2/root/.ssh"
       "/mnt/netboot_common/nfs/yellow3/root/.ssh"
       "/mnt/netboot_common/nfs/yellow4/root/.ssh"
       "/mnt/netboot_common/nfs/yellow5/root/.ssh"
       "/mnt/netboot_common/nfs/yellow6/root/.ssh"
       "/mnt/netboot_common/nfs/yellow7/root/.ssh"
       "/mnt/netboot_common/nfs/yellow8/root/.ssh"
)

# Loop through each directory
for dir in "${DIRS[@]}"; do
    echo "🔧 Processing $dir"

    # Create .ssh directory if it doesn't exist
    if [ ! -d "$dir" ]; then
        echo "➕ Creating $dir"
        mkdir -p "$dir"
        chmod 700 "$dir"
    fi

    # Append the pubkey if not already present
    AUTH_KEYS="$dir/authorized_keys"
    if grep -q -f "$PUBKEY" "$AUTH_KEYS" 2>/dev/null; then
        echo "✅ Key already present in $AUTH_KEYS"
    else
        echo "➕ Adding key to $AUTH_KEYS"
        cat "$PUBKEY" >> "$AUTH_KEYS"
        chmod 600 "$AUTH_KEYS"
    fi
done

echo "🎉 Done!"

