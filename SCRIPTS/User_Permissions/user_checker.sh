#!/bin/bash
if [ "$1" = "-g" ]; then
	echo -e "[root]=\"root\"
[daemon]=\"daemon\"
[bin]=\"bin\"
[sys]=\"sys\"
[sync]=\"nogroup\"
[games]=\"games\"
[man]=\"man\"
[lp]=\"lp\"
[mail]=\"mail\"
[news]=\"news\"
[uucp]=\"uucp\"
[proxy]=\"proxy\"
[www-data]=\"www-data\"
[backup]=\"backup\"
[list]=\"list\"
[irc]=\"irc\"
[gnats]=\"gnats\"
[nobody]=\"nogroup\"
[_apt]=\"nogroup\"
[systemd-network]=\"systemd-network\"
[systemd-resolve]=\"systemd-resolve\"
[messagebus]=\"messagebus\"
[systemd-timesync]=\"systemd-timesync\"
[pollinate]=\"daemon\"
[sshd]=\"nogroup\"
[syslog]=\"syslog adm\"
[uuidd]=\"uuidd\"
[tcpdump]=\"tcpdump\"
[tss]=\"tss\"
[landscape]=\"landscape\"
[fwupd-refresh]=\"fwupd-refresh\"
[usbmux]=\"plugdev\"
[lxd]=\"users\"" > valid_users.txt
echo "valid_users.txt created"
fi

if [ "$1" = "-a" ]; then
	echo "[$2]= \"$(groups $2 | cut -d: -f2)\"" >> valid_users.txt
	echo "added [$2]= \"$(groups $2 | cut -d: -f2)\""
fi
	
# Filename for the CSV output
output_file="users_and_groups.csv"

# Write the header to the CSV file
echo "Username,Groups" > "$output_file"

# Loop through each user in the system and generate CSV
getent passwd | cut -d: -f1 | while read -r user; do
    # Get groups for the current user
    groups_list=$(id -nG "$user" | tr ' ' ',')

    # Write the user and their groups to the CSV file
    echo "$user,$groups_list" >> "$output_file"
done

echo "CSV file created: $output_file"
echo ""
echo "Invalid Users and Groups"

# Define valid user groups from the 'users' file
declare -A valid_user_groups
while IFS='=' read -r key value; do
    user=$(echo "$key" | tr -d '[]')
    groups=$(echo "$value" | tr -d '"')
    valid_user_groups[$user]="$groups"
done < "valid_users.txt"

# Initialize counters
invalid_user_count=0
invalid_group_count=0

# Function to parse CSV and compare
parse_and_compare() {
    while IFS=, read -r user group other_groups
    do
        # Skip header
        if [[ $user == "Username" ]]; then
            continue
        fi

        valid_groups=${valid_user_groups[$user]}
        IFS=' ' read -ra valid_groups_array <<< "$valid_groups"
        IFS=',' read -ra user_groups_array <<< "$group,$other_groups"

        if [[ -z "$valid_groups" ]]; then
            echo "$user - added user"
            groups $user
	    echo ""
	    ((invalid_user_count++))
        else
            for grp in "${user_groups_array[@]}"; do
                if [[ ! " ${valid_groups_array[*]} " =~ " $grp " ]]; then
                    echo "$user - added group $grp"
		    groups $user
		    echo ""
		    local op="$1"
		    if [ "$op" = "-fg" ]; then
			    sudo gpasswd -d "$user" "$grp"
			    echo "Removed $user from $grp"
		    fi
                    ((invalid_group_count++))
                    break
                fi
            done
        fi
    done < "$output_file"
}

# Parse and compare
parse_and_compare $1

# Print results
echo -e "\nInvalid Users Count: $invalid_user_count"
echo -e "Invalid Groups Count: $invalid_group_count"
echo ""
echo "run $0 -fg to fix group issues. this will auto remove useres from groups"
echo "run $0 -g to create valid_users.txt"
echo "run $0 -a username to add a user and groups to valid_users.txt"
echo "example: $0 -a username"
