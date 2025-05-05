#!/bin/bash

# Prompt for username to remove
read -p "Enter the username to remove: " targetuser

# Remove passwordless sudo privileges
if [ -f "/etc/sudoers.d/$targetuser" ]; then
    sudo rm -f "/etc/sudoers.d/$targetuser"
    echo "🧹 Removed sudoers entry for $targetuser."
else
    echo "⚠️ No sudoers entry found for $targetuser."
fi

# Delete the user and their home directory
if id "$targetuser" &>/dev/null; then
    sudo userdel -r "$targetuser"
    echo "🗑️ User '$targetuser' and home directory removed."
else
    echo "❌ User '$targetuser' does not exist."
fi
