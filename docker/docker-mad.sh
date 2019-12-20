#!/bin/bash

./docker/get_centos_iso.sh

MAIN_NAME=centos7-mad
MAIN_KS=$MAIN_NAME.ks
MAIN_ISO=$MAIN_NAME.iso
MAIN_ISO_FQ=/var/tmp/$MAIN_ISO
MAIN_LOG=$MAIN_NAME.log
MAIN_TAR=$MAIN_NAME.tar.xz
INPUT_KS=http/centos7.ks
SCRIPT_DIR=scripts
CENTOS_BOOT_ISO=http/boot.iso
SAVED_IMAGES=../saved_images/docker

echo -e "\nCreating Kickstart File $MAIN_KS"

sed '/\@core$/d' $INPUT_KS > $MAIN_KS
sed -i 's/\%packages.*/& --nocore/g' $MAIN_KS

sed -i '0,/\%end/s//bind-utils\nbash\nyum\nvim-minimal\ncentos-release\nless\n\-kernel\*\n\-\*firmware\n\-os\-prober\n\-gettext\*\n\-bind\-license\n\-freetype\niputils\niproute\nsystemd\nrootfiles\n\-libteam\n\-teamd\ntar\npasswd\n\%end/' $MAIN_KS

sed -i '$ d' $MAIN_KS

for i in base-nogui.sh anaconda.sh vagrant.sh R.sh MAD.sh;
do
	echo -e "\n\n###  Script $i  ###" >> $MAIN_KS
	tail -n +2 $SCRIPT_DIR/$i >> $MAIN_KS
done

echo "%end" >> $MAIN_KS

echo -e "\nRemove old version of ISO ($MAIN_ISO) due to be created?"
rm -i $MAIN_ISO_FQ

echo -e "\nStarting ISO creation"
livemedia-creator --make-iso --iso=$CENTOS_BOOT_ISO --ks=$MAIN_KS --image-name=$MAIN_ISO --logfile=$MAIN_LOG --keep-image

echo -e "\nCreating TAR file required for Docker import"
#virt-tar-out -a $MAIN_ISO_FQ / - | xz > $MAIN_TAR
virt-tar-out -a $MAIN_ISO_FQ / $MAIN_TAR

echo -e "\nDealing with Docker!"
docker rm `docker ps -a | grep $MAIN_NAME | cut -c1-12`
docker rmi $MAIN_NAME
cat $MAIN_TAR | docker import - $MAIN_NAME

echo -e "\nCleaning Up"
rm -f $MAIN_ISO_FQ
mkdir -p $SAVED_IMAGES
mv $MAIN_TAR $SAVED_IMAGES/.
