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
	chmod +rx /mnt/netboot_common/nfs/$pi/boot/vmlinuz-*
done

echo "Done."

