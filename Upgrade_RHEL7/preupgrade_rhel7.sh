#!/bin/bash

##
### SCRIPT BY EXTRO
##

##
### LAST CHANGED 08.05.2024
##

##
### VARIABLES
##

rhel_scriptname=rhel7_inplace.sh
update_scriptname=update_servers.sh
truth_var="y"
false_var="n"

##
### MAIN
##

main() {

read -p "Execute on one or many servers? ( 1 | 2 ): " server_count
update_question
}


##
### FUNCTIONS
##

update_question() {
read -p "Do you want to run updates (This will restart the system)? ( y/n ): " answer_update
if [ "$answer_update" == "$truth_var" ] && [ "$server_count" -eq 1 ];then
        update_exec_single
elif [ "$answer_update"  == "$truth_var" ] && [ "$server_count" -eq 2 ];then
        update_exec_multiple
elif [ "$answer_update" == "$false_var" ];then
        choose_servers
else
        echo "invalid option proceeding to terminate program"
        exit 1
fi
}

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

update_exec_single() {
        echo "Please type in single server to update: "
        read update_single
        scp $update_scriptname root@$update_single:/
        ssh root@$update_scriptname "chmod +x /$update_scriptname ; . /$update_scriptname "
}

update_exec_multiple() {
        echo "Please type in multiple servers to update: "
        read -a update_array
for u in ${update_array[@]}
        do
                scp $update_scriptname root@$u:/
                ssh root@$u "chmod +x /$update_scriptname ; . /$update_scriptname "
        done
}

cp_execute_single() {

        echo "Please type in single server to copy to: "
        read server_single
        scp $rhel_scriptname root@$server_single:/
        ssh root@$server_single "chmod +x /$rhel_scriptname ; . /$rhel_scriptname ; rm /$rhel_scriptname "

}

cp_execute_multiple() {

echo "Please type servers you want to copy to (delimited by spacebar): "
read -a server_array
for i in ${server_array[@]}
        do
#                echo "$i"
        scp $rhel_scriptname root@$i:/
        ssh root@$i 'chmod +x /$rhel_scriptname ; . /$rhel_scriptname ; rm /$rhel_scriptname '
        done
}

main
