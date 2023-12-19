#!/bin/bash

# Filename for the CSV output
output_file="users_and_groups.csv"

# Write the header to the CSV file
echo "Username,Groups" > "$output_file"

# Loop through each user in the system
getent passwd | cut -d: -f1 | while read -r user; do
    # Get groups for the current user
    groups_list=$(id -nG "$user" | tr ' ' ',')

    # Write the user and their groups to the CSV file
    echo "$user,$groups_list" >> "$output_file"
done

echo "CSV file created: $output_file"
