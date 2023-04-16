#!/bin/bash

# Define the group and user information
group_name="$1"
username="$2"

# Check if the group already exists
if getent group "$group_name" >/dev/null; then
    echo "Group '$group_name' already exists"
else
    # Create the group
    groupadd "$group_name"
    echo "Group '$group_name' created"
fi

# Check if the user already exists
if id -u "$username" >/dev/null 2>&1; then
    echo "User '$username' already exists"
else
    # Create the user
    useradd -m "$username"
    echo "User '$username' created"
fi

# Add the user to the group
usermod -aG "$group_name" "$username"

# Grant sudo privileges to the group if not already present
if grep -q "^%${group_name} ALL=(ALL) ALL$" /etc/sudoers; then
    echo "sudo entry for '$group_name' already exists in sudoers file"
else
    echo "%${group_name} ALL=(ALL) ALL" >> /etc/sudoers
    echo "sudo entry for '$group_name' added to sudoers file"
fi

echo "Finished with adding ${username} to sudoers"
