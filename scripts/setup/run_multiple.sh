#!/bin/bash

# Path to the input file
INPUT_FILE="pi_info.txt"
# Path to the script to be called
SCRIPT_TO_CALL="./pi_boot.sh"
SCRIPT_TO_CALL_2="./worker_setup.sh"

# Command-line arguments
BASE_PATTERN="$1"
START_NUM="$2"
END_NUM="$3"

if [[ -z "$BASE_PATTERN" || -z "$START_NUM" || -z "$END_NUM" ]]; then
    echo "Usage: $0 <base_pattern> <start_num> <end_num>"
    exit 1
fi

# Read the file line by line
while read -r name mac id ip; do
    # Remove any parentheses from the name
    clean_name=$(echo "$name" | sed 's/([^)]*)//g')

    # Use regex to extract the base name and number
    if [[ "$clean_name" =~ ^([A-Za-z]+)([0-9]+)$ ]]; then
        base="${BASH_REMATCH[1]}"
        num="${BASH_REMATCH[2]}"
        
        # Match base pattern and number range
        if [[ "$base" == "$BASE_PATTERN" && "$num" -ge "$START_NUM" && "$num" -le "$END_NUM" ]]; then
            echo "Running $SCRIPT_TO_CALL with: $clean_name $mac $id $ip"
            "$SCRIPT_TO_CALL" "$clean_name"
	    #echo "Running $SCRIPT_TO_CALL_2 with: $clean_name"
	    #"$SCRIPT_TO_CALL_2" "$clean_name" 
        fi
    fi
done < "$INPUT_FILE"

