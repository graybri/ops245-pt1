#!/usr/bin/env bash

# Test for sudo
user=$(whoami)
if [ $user != "root" ]
then
    echo "You must run this script with root privileges. Please use sudo" >&2
    exit 1
fi

# Remove users
for account in $(grep ":x:100[1-9]:" /etc/passwd | cut -d: -f1)
do
    userdel -r $account > /dev/null 2>&1
done


# Restore files
cp /root/backups/ops245.bashrc ~ops245/.bashrc
chown ops245:ops245 ~ops245/.bashrc


# Restart interface 
# This adds the static IPv4 config
# When the starttest script runs it will return the interface to manual
ifdown enp1s0
cp /root/backups/interfaces.dhcp /etc/network/interfaces
ifup enp1s0

# Restore vsftpd
systemctl enable --now vsftpd

# Remove micro xclip
apt -y remove micro xclip

# Install cowsay
apt -y install cowsay

# Remove lmarbles

rm -rf /usr/local/share/lmarbles
rm /usr/local/bin/lmarbles

#  Attempt to remove source tree for lmarbles

find /home -type d -iname 'lmarbles*' -exec rm -rf {} \;

# End message
echo "Test Reset"
echo "Shutdown the VM"
echo "Start the VM at the start of the test"



