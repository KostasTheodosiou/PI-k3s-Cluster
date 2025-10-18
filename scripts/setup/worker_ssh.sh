# Automated worker setup 
# This is essensially the worker_setup.sh script, renamed
# since it actually sets up only the ssh connection.
# The actual worker setup will actually occur through mlops_master's
# worker_setup.yml ansible playbook (We'll see, it might prove to be impractical)

PI_NAME=$1

IP=$(grep -E "^$PI_NAME" "pi_info.txt" | awk '{print $4}')

# Remove old pi configuration from known hosts
ssh-keygen -f '/home/ubuntu/.ssh/known_hosts' -R "$IP"

# Accept new ssh host
ssh -o StrictHostKeyChecking=accept-new $PI_NAME""

# Add Login Node public ssh key to worker->authorized_keys
cat /home/ubuntu/.ssh/id_*.pub > /mnt/netboot_common/nfs/${PI_NAME}/home/ubuntu/.ssh/authorized_keys
cat /mnt/netboot_common/nfs/MLops_master/home/ubuntu/.ssh/id_*.pub >> /mnt/netboot_common/nfs/${PI_NAME}/home/ubuntu/.ssh/authorized_keys
sudo cat /mnt/netboot_common/nfs/MLops_master/home/ubuntu/.ssh/id_*.pub | sudo tee -a /mnt/netboot_common/nfs/yellow8/root/.ssh/authorized_keys > /dev/null

# Set ssh port to 22
#sed -i 's/^#\?Port 2222$/Port 22/' /mnt/netboot_common/nfs/${PI_NAME}/etc/ssh/sshd_config 
