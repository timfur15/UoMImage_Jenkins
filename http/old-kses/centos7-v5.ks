# This is a minimal CentOS kickstart designed for docker. 
# It will not produce a bootable system 
# To use this kickstart, run the following command
# livemedia-creator --make-tar \
#   --iso=/path/to/boot.iso  \
#   --ks=centos-7.ks \
#   --image-name=centos-root.tar.xz
#
# Once the image has been generated, it can be imported into docker
# by using: cat centos-root.tar.xz | docker import -i imagename

# Basic setup information
url --url="http://mirrors.kernel.org/centos/7/os/x86_64/"
install
lang en_GB.UTF-8
keyboard uk
#network --onboot yes --device eth0 --bootproto dhcp --noipv6
#network --bootproto=dhcp --device=link --activate --onboot=on --noipv6
network --bootproto=dhcp --device=ens3 --activate --onboot=on --noipv6
rootpw --plaintext vagrant
authconfig --enableshadow --passalgo=sha512
selinux --permissive
timezone Europe/London
bootloader --location=mbr --driveorder=sda --append="crashkernel=128M rhgb"
eula --agreed
repo --name="CentOS" --baseurl=http://mirror.centos.org/centos/$releasever/os/$basearch/ --cost=100
repo --name="Updates" --baseurl=http://mirror.centos.org/centos/$releasever/updates/$basearch/ --cost=100
#text
skipx
zerombr

ignoredisk --only-use=sda
clearpart --all --initlabel --drives=sda
bootloader --location=mbr
part /boot/efi --fstype=efi --grow --maxsize=50 --size=50 --ondisk=sda
part /boot --fstype ext4 --size=500 --ondisk=sda
part pv.01 --size=30720 --grow --ondisk=sda
volgroup VolGroup --pesize=32768 pv.01
logvol / --vgname=VolGroup --fstype ext4 --size=20480 --name=lv_root
#logvol /local --vgname=VolGroup --fstype ext4 --size=16384 --grow --name=lv_local
logvol swap --vgname=VolGroup --fstype swap --name=lv_swap --hibernation --recommended

auth --useshadow --enablemd5
firstboot --disabled
reboot

%packages --ignoremissing
@core
bzip2
kernel-devel
kernel-headers
-ipw2100-firmware
-ipw2200-firmware
-ivtv-firmware
wget
emacs
curl
rsync
%end

%post
/usr/bin/yum -y update
/usr/bin/yum -y install sudo
/usr/sbin/groupadd -g 501 vagrant
/usr/sbin/useradd vagrant -u 501 -g vagrant -G wheel
echo "vagrant"|passwd --stdin vagrant
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/vagrant
echo "Defaults:vagrant !requiretty"                 >> /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant
%end
