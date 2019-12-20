#!/bin/bash

MASTERURL="http://mirrors.ukfast.co.uk/sites/ftp.centos.org/7/isos/x86_64"
#MASTERURL="http://ftp.pbone.net/pub/centos/7/isos/x86_64/"

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

#export http_proxy="http://proxy.man.ac.uk:3128"
wget $MASTERURL/sha256sum.txt -P /tmp

CHECKSUM=`grep Minimal /tmp/sha256sum.txt | grep iso | cut -d' ' -f1`
ISOURL=`grep Minimal /tmp/sha256sum.txt | grep iso | cut -d' ' -f3`

echo -e "      \"iso_checksum\": \"$CHECKSUM\"," >> $OUTFILE
echo -e "      \"iso_url\": \"$MASTERURL/$ISOURL\"," >> $OUTFILE
cat ./templates/other/template-bottom.json >> $OUTFILE

/usr/local/bin/packer build $OUTFILE
