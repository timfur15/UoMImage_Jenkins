#!/bin/bash

TMP_ASTER="/tmp/code-aster"
TMP_SATURNE="/tmp/code-saturne"
MASTER_ASTER="/opt/aster"
HOME_ASTER="/opt/aster"

URL_SATURNE="http://code-saturne.org/cms/sites/default/files/releases"
FILE_SATURNE="code_saturne-5.0.10.tar.gz"

URL_ASTER="https://www.code-aster.org/FICHIERS"
VERSION_ASTER_STABLE="aster-full-src-13.6.0"
VERSION_ASTER_DEV="aster-full-src-14.2.0"

FILE_ASTER_STABLE="$VERSION_ASTER_STABLE-1.noarch.tar.gz"
FILE_ASTER_DEV="$VERSION_ASTER_DEV-1.noarch.tar.gz"

yum install xterm pyqt4 pyqt4-devel libxml2-devel wget gcc gcc-gfortran -y

rm -rf $TMP_SATURNE $TMP_ASTER $MASTER_ASTER

echo -e "#!/bin/bash\n\n" > /root/path.sh
echo -e "export PATH=/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin" >> /root/path.sh
echo -e "export TFELHOME=/opt/aster/public/tfel-3.1.1" >> /root/path.sh

mkdir $TMP_SATURNE
cd $TMP_SATURNE
wget $URL_SATURNE/$FILE_SATURNE
tar -xvzf $FILE_SATURNE
cd code_saturne*
./configure
make
make install
rm -rf $TMP_SATURNE

. /root/path.sh
PATH=/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin

yum install cmake python-devel python2-numpy tk bison flex lapack-devel blas-devel boost-python boost-devel zlib blas-static lapack-static gcc-c++ -y

mkdir $TMP_ASTER
cd $TMP_ASTER
wget $URL_ASTER/$FILE_ASTER_STABLE
tar -xvzf $FILE_ASTER_STABLE
cd $VERSION_ASTER_STABLE

for i in astk gmsh grace hdf5 homard med metis mumps scotch;
do
	python ./setup.py install $i --noprompt
done

cd $TMP_ASTER
wget $URL_ASTER/$FILE_ASTER_DEV
tar -xvzf $FILE_ASTER_DEV
cd $VERSION_ASTER_DEV
python ./setup.py install tfel --noprompt

. /root/path.sh
PATH=/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin

ASTER_PUBLIC=$MASTER_ASTER/public
ASTER_LD=/etc/ld.so.conf.d/aster.conf
echo "$ASTER_PUBLIC/gmsh-3.0.6-Linux64/lib" > $ASTER_LD
echo "$ASTER_PUBLIC/hdf5-1.8.14/lib" >> $ASTER_LD
echo "$ASTER_PUBLIC/homard-11.10/lib" >> $ASTER_LD
echo "$ASTER_PUBLIC/med-3.3.1/lib" >> $ASTER_LD
echo "$ASTER_PUBLIC/metis-5.1.0/lib" >> $ASTER_LD
echo "$ASTER_PUBLIC/mumps-5.1.1/lib" >> $ASTER_LD
echo "$ASTER_PUBLIC/scotch-6.0.4/lib" >> $ASTER_LD
echo "$ASTER_PUBLIC/tfel-3.1.1/lib" >> $ASTER_LD
/sbin/ldconfig

TFELHOME=$ASTER_PUBLIC/tfel-3.1.1
HOME_METIS=$ASTER_PUBLIC/metis-5.1.0
cd $TMP_ASTER/$VERSION_ASTER_STABLE
python ./setup.py install aster --noprompt

rm -rf $TMP_ASTER

. /root/path.sh
