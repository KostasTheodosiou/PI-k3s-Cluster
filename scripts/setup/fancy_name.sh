#!/bin/bash

# Check input
if [[ ! $1 =~ ^(yellow|green)[1-8]$ ]]; then
  echo "Usage: $0 {yellow1..yellow8|green1..green8}"
  exit 1
fi

NAME="$1"
COLOR="${NAME%%[1-8]*}"
TARGET_PATH="/mnt/netboot_common/nfs/$NAME/home/ubuntu/.bashrc"

# Validate file
if [ ! -f "$TARGET_PATH" ]; then
  echo "❌ .bashrc not found at $TARGET_PATH"
  exit 2
fi

# Assign 256-color codes
case "$COLOR" in
  yellow) COLOR_CODE="38;5;226" ;;  # Bright Yellow
  green)  COLOR_CODE="38;5;46"  ;;  # Bright Green
  *) echo "❌ Unknown color"; exit 3 ;;
esac

# Build colored hostname using real ANSI sequences
COLORED_NAME=""
COLORED_NAME+="\[\e[${COLOR_CODE}m\]${NAME}\[\e[0m\]"

# Final prompt line
PS1_LINE="PS1='\\[\\e[1;37m\\]\\u\\[\\e[0m\\]@${COLORED_NAME}\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\$ '"

# Remove old PS1
sed -i  "s/^PS1=.*//" "$TARGET_PATH"
sed -i "s/^# Custom PS1 prompt for $NAME*//" "$TARGET_PATH"

echo -e "\n# Custom PS1 prompt for $NAME" >> "$TARGET_PATH"
echo "$PS1_LINE" >> "$TARGET_PATH"

echo "✅ .bashrc updated for $NAME"

