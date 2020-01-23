#!/bin/bash -x

echo "debug: Executing scripts/virtualbox.sh"

yum install -y elfutils-libelf elfutils-libelf-devel

uname -a

mount -o loop /home/vagrant/VBoxGuestAdditions.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
rc=$?
rc=0

umount /mnt
rm -rf /home/vagrant/VBoxGuestAdditions.iso

if [ $rc -ne 0 ]
then
    [ -f /var/log/VBoxGuestAdditions.log ] && cat /var/log/VBoxGuestAdditions.log
    exit $rc
else
    echo "Virtualbox guest addons have been installed successfully"
    exit 0
fi
