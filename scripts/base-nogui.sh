#!/bin/bash


exec >> /tmp/base-nogui.log
exec 2>&1

lvextend -l+100%FREE /dev/VolGroup/lv_root
resize2fs /dev/VolGroup/lv_root

sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
yum -y install gcc make gcc-c++ kernel-devel-`uname -r` perl grub2-tools net-tools
yum -y install epel-release.noarch
