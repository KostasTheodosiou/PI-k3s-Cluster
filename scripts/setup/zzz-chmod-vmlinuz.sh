#!/bin/bash

NAMES=(
       "green1"
       "green2"
       "green3"
       "green4"
       "green5"
       "green6"
       "green7"
       "green8"
       "yellow1"
       "yellow2"
       "yellow3"
       "yellow4"
       "yellow5"
       "yellow6"
       "yellow7"
       "yellow8"
)

# Loop through each directory
for pi in "${NAMES[@]}"; do
        echo "proccessing $pi"
        TARGET_DIR="/mnt/netboot_common/nfs/$pi/etc/kernel/postinst.d"
	SCRIPT_PATH="/deb/null"
	if [ -f "$TARGET_DIR/zzz-chmod-vmlinuz" ]; then 
		echo "zzz-chmod-vmlinuz already exitsts."
		continue
	else
		SCRIPT_PATH="$TARGET_DIR/zzz-chmod-vmlinuz"
		echo "creating zzz-chmod-vmlinuz"
	fi
	cat > "$SCRIPT_PATH" << 'EOF'
#!/bin/sh -e
chmod 0644 /boot/vmlinuz-*
EOF
	chmod +x "$SCRIPT_PATH"
	
done

echo "Done."
