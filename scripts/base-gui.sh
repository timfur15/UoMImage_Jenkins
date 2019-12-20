#!/bin/bash

exec >> /tmp/base-gui.log
exec 2>&1

echo "debug: Expanding disk"
echo "Expanding disk"

lvextend -l+100%FREE /dev/VolGroup/lv_root
resize2fs /dev/VolGroup/lv_root

echo "debug: Installing base packages"
echo "Installing base packages"

sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
yum -y install gcc make gcc-c++ kernel-devel-`uname -r` perl grub2-tools net-tools
yum -y install epel-release.noarch
rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
yum -y install puppet
gem install hiera-eyaml hiera-eyaml-kms

echo "debug: Installing GUI packages"
echo "Installing GUI packages"

yum groupinstall "X Window System" -y
yum groupinstall "Server with GUI" -y
yum -y install gnome-classic-session gnome-terminal nautilus-open-terminal control-center liberation-mono-fonts
yum groupinstall "MATE Desktop" -y
unlink /etc/systemd/system/default.target
ln -sf /lib/systemd/system/graphical.target /etc/systemd/system/default.target
yum -y install wget

echo "debug: Installing Xfce"
echo "Installing Xfce"

yum groupinstall -y "Xfce"
echo "/bin/xfce4-session" > ~/.Xclients

echo "debug: Installing Xrdp"
echo "Installing Xrdp"

yum -y install xrdp xorgxrdp
systemctl enable xrdp
systemctl start xrdp
