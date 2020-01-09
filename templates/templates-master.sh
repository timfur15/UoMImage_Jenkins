#!/bin/bash

TMPDIR=/data/tmp/packer

export http_proxy="http://proxy.man.ac.uk:3128"
http_proxy="http://proxy.man.ac.uk:3128"

#MASTERURL="http://mirrors.ukfast.co.uk/sites/ftp.centos.org/7/isos/x86_64"
MASTERURL="http://ftp.pbone.net/pub/centos/7/isos/x86_64"

echo -e "\nPlease select which image to create...\n"
echo -e "\n1) Juan with GUI (Code Aster & Code Saturn)"
echo -e "\n2) MAD with GUI (Mongo DB, Apache Spark and Django)"
echo -e "\n3) R with GUI "
echo -e "\n4) Base with GUI "
echo -e "\n5) Juan no GUI (Code Aster & Code Saturn)"
echo -e "\n6) MAD no GUI (Mongo DB, Apache Spark and Django)"
echo -e "\n7) R no GUI "
echo -e "\n8) Base no GUI "
echo -e "\n9) Minimal "
echo -e ""

if [ ! -z "$1" ]
then
        selection=$1
else
        read -p "Selection: " selection
fi

case "$selection" in
	1)
		BOX_NAME="juan-w-GUI"
#		PACKAGES="base-nogui.sh anaconda.sh vagrant.sh juan.sh cleanup.sh virtualbox.sh"
		PACKAGES="base-gui.sh vagrant.sh juan.sh virtualbox.sh"
		;;
	2)
		BOX_NAME="mad-w-GUI"
#		PACKAGES="base-nogui.sh anaconda.sh vagrant.sh MAD.sh cleanup.sh virtualbox.sh"
		PACKAGES="base-gui.sh vagrant.sh MAD-templates.sh virtualbox.sh"
		;;
	3)
		BOX_NAME="r-w-GUI"
		PACKAGES="base-gui.sh anaconda.sh vagrant.sh R.sh virtualbox.sh"
		;;
	4)
		BOX_NAME="base-w-GUI"
#		PACKAGES="base-nogui.sh anaconda.sh vagrant.sh tigervnc.sh virtualbox.sh"
		PACKAGES="base-gui.sh vagrant.sh virtualbox.sh"
		;;
	5)
		BOX_NAME="juan-no-GUI"
		PACKAGES="base-nogui.sh vagrant.sh juan.sh virtualbox.sh"
		;;
	6)
		BOX_NAME="mad-no-GUI"
		PACKAGES="base-nogui.sh vagrant.sh MAD-templates.sh virtualbox.sh"
		;;
	7)
		BOX_NAME="r-no-GUI"
		PACKAGES="base-nogui.sh anaconda.sh vagrant.sh R.sh virtualbox.sh"
		;;
	8)
		BOX_NAME="base-no-GUI"
		PACKAGES="base-nogui.sh vagrant.sh virtualbox.sh"
		;;
	9)
		BOX_NAME="Minimal"
		PACKAGES="minimal.sh"
		;;
	esac

OUTFILE="./templates/other/template-$BOX_NAME.json"

cat ./templates/other/template-top.json > $OUTFILE
SIZE=0; for i in $PACKAGES; do SIZE=$((SIZE+1)); done
COUNT=0
for i in $PACKAGES
do
	COUNT=$((COUNT+1))
	if [ ! $COUNT -eq $SIZE ]
	then 
		echo "            \"scripts\/$i\"," >> $OUTFILE
	else
		echo "            \"scripts\/$i\"" >> $OUTFILE
	fi
done
cat ./templates/other/template-middle.json >> $OUTFILE
echo -e "          \"output\": \"centos7-$BOX_NAME.box\"" >> $OUTFILE
cat ./templates/other/template-nearbottom.json >> $OUTFILE

export http_proxy="http://proxy.man.ac.uk:3128"
#wget $MASTERURL/sha256sum.txt -P /tmp

#CHECKSUM=`grep Minimal /tmp/sha256sum.txt | grep iso | cut -d' ' -f1`
#ISOURL=`grep Minimal /tmp/sha256sum.txt | grep iso | cut -d' ' -f3`

#echo -e "      \"iso_checksum\": \"$CHECKSUM\"," >> $OUTFILE
#echo -e "      \"iso_url\": \"$MASTERURL/$ISOURL\"," >> $OUTFILE

echo -e "      \"iso_checksum\": \"9a2c47d97b9975452f7d582264e9fc16d108ed8252ac6816239a3b58cef5c53d\"," >> $OUTFILE
echo -e "      \"iso_url\": \"file:///data/isos/CentOS-7-x86_64-Minimal-1908.iso\"," >> $OUTFILE

cat ./templates/other/template-bottom.json >> $OUTFILE

packer build $OUTFILE

rm -rf /data/tmp/$BOX_NAME
mkdir /data/tmp/$BOX_NAME
mv centos7-$BOX_NAME.box /data/tmp/$BOX_NAME/.
cd /data/tmp/$BOX_NAME
tar -xvzf centos7-$BOX_NAME.box
sed -i "s/end/  config.ssh.password = 'vagrant'\nend/g" Vagrantfile
tar -cvzf centos7-$BOX_NAME-v2.box Vagrantfile metadata.json box.ovf packer-virtualbox-iso-*.vmdk

mv centos7-$BOX_NAME-v2.box /data/saved_images/templates/centos7-$BOX_NAME.box
