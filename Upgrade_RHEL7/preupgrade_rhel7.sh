#!/bin/bash

##
### VARIABLES
##

rhel_script=/Upgrade_RHEL7/rhel7_inplace.sh
rhel_scriptname=rhel7_inplace.sh

##
### MAIN
##

main() {

read -p "Copy to one or many servers? ( 1 | 2 ): " server_count
choose_servers
}


##
### FUNCTIONS
##

choose_servers() {

if [ "$server_count" -eq 1 ];then
        cp_execute_single
elif [ "$server_count" -eq 2 ]; then
        cp_execute_multiple
else
        echo "Invalid option proceeding to terminate program"
        exit 1
fi
}

cp_execute_single() {

        echo "Please type in single server to copy to: "
        read server_single
        scp $rhel_script root@$server_single:/
        ssh root@$server_single 'chmod +x $rhel_scriptname ; . /$rhel_scriptname ; rm /$rhel_scriptname '
}

cp_execute_multiple() {

echo "Please type servers you want to copy to (delimited by spacebar): "
read -a server_array
for i in ${server_array[@]}
        do
#                echo "$i"
        scp $rhel_script root@$i:/
        ssh root@$i 'chmod +x $rhel_scriptname ; . /$rhel_scriptname ; rm /$rhel_scriptname '
        done
}

main
