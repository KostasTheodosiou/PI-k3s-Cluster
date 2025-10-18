#!/bin/bash

# A script that power cycles selected Pi(s)

declare -A name_id_map

# Map content
name_id_map[yellow1]=33
name_id_map[yellow2]=35
name_id_map[yellow3]=37
name_id_map[yellow4]=39
name_id_map[yellow5]=41
name_id_map[yellow6]=43
name_id_map[yellow7]=45
name_id_map[yellow8]=47

name_id_map[green1]=34
name_id_map[green2]=36
name_id_map[green3]=38
name_id_map[green4]=40
name_id_map[green5]=42
name_id_map[green6]=44
name_id_map[green7]=46
name_id_map[green8]=48

name_id_map[login]=15
name_id_map[backup]=9
name_id_map[mlops_master]=11

# Literally just a single command
# But hey, you don't have to remember it!

if [ "$#" -ne 1 ]; then
    echo "Error: Give PI name"
    exit 1
fi

Pi_name=$1

# Ask for confirmation
    read -p "Are you sure you want to restart "$Pi_name"? (y/n) " -n 1 -r
    echo    # move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
    fi


# Check if name is valid
if [[ -z "${name_id_map[$Pi_name]}" ]]; then 
    if [ "$Pi_name" = "yellow" ]; then
		Pi_num=1
		Pi_ID=33 
		for ((i=1; i<=8; i++)); do	
			echo "Restarting yellow"$Pi_num" ("$Pi_ID")" 
			# echo "swctrl poe restart id $Pi_ID"
 			sshpass -p 'fkXUuqr6OP50jwqQ' ssh ubnt@192.168.2.254 "swctrl poe restart id $Pi_ID" &
			((Pi_num++))
			((Pi_ID += 2))
  			wait
			sleep 5  # Wait for 5 seconds
		done

    elif [ "$Pi_name" = "green" ]; then
 		Pi_num=1
		Pi_ID=34 
		for ((i=1; i<=8; i++)); do
			#echo "swctrl poe restart id $Pi_ID"
			echo "Restarting green"$Pi_num" ("$Pi_ID")" 
 			sshpass -p 'fkXUuqr6OP50jwqQ' ssh ubnt@192.168.2.254 "swctrl poe restart id $Pi_ID" &
			((Pi_num++))
			((Pi_ID += 2))
  			wait
			sleep 5  # Wait for 5 seconds
		done

    elif [ "$Pi_name" = "all" ]; then
		Pi_ID=${name_id_map[login]}
        echo "Restarting $node ($Pi_ID)"
        sshpass -p 'fkXUuqr6OP50jwqQ' ssh ubnt@192.168.2.254 "swctrl poe restart id $Pi_ID" &
        wait
        sleep 10
		Pi_ID=${name_id_map[mlops_master]}
        echo "Restarting $node ($Pi_ID)"
        sshpass -p 'fkXUuqr6OP50jwqQ' ssh ubnt@192.168.2.254 "swctrl poe restart id $Pi_ID" &
        wait
        sleep 5
        for node in "${!name_id_map[@]}"; do
            if [ "$node" != "backup" ] && [ "$node" != "login" ] && [ "$node" != "mlops_master" ]; then
                Pi_ID=${name_id_map[$node]}
                echo "Restarting $node ($Pi_ID)"
                sshpass -p 'fkXUuqr6OP50jwqQ' ssh ubnt@192.168.2.254 "swctrl poe restart id $Pi_ID" &
                wait
                sleep 5
            fi
        done 

    else
    	echo "Error: Invalid name"
    	exit 1
    fi

else 

    # Print Pi ID (debug) 
    # echo "${name_id_map[$Pi_name]}" 

    # Print command for debug
    # echo "swctrl poe restart id ${name_id_map[$Pi_name]}"

    sshpass -p 'fkXUuqr6OP50jwqQ' ssh ubnt@192.168.2.254 "swctrl poe restart id ${name_id_map[$Pi_name]}"
fi
