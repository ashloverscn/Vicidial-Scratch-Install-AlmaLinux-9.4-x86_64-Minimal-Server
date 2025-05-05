#!/bin/bash

# Prompt for username and password
read -p "Enter new username: " newuser
read -s -p "Enter default password: " userpass
echo

# Create the user with home directory and bash shell
sudo useradd -m -s /bin/bash "$newuser"

# Set the user password
echo "$newuser:$userpass" | sudo chpasswd

# Determine if 'sudo' or 'wheel' group exists and add user to the group
if getent group sudo > /dev/null; then
    sudo usermod -aG sudo "$newuser"
    groupname="sudo"
elif getent group wheel > /dev/null; then
    sudo usermod -aG wheel "$newuser"
    groupname="wheel"
else
    echo "❌ Neither 'sudo' nor 'wheel' group found. Please add sudo privileges manually."
    exit 1
fi

# Grant passwordless sudo to this user
echo "$newuser ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/"$newuser" > /dev/null
sudo chmod 0440 /etc/sudoers.d/"$newuser"

# Confirm
echo "✅ User '$newuser' created and added to '$groupname' group with passwordless sudo access."
