#!/bin/bash

yum install libmpc-devel mpfr-devel gmp-devel tcl-devel tcl libXScrnSaver-devel -y

cd /root
wget https://www.code-aster.org/FICHIERS/Salome-Meca-2017.0.1-LGPL-1.tgz
tar -xvzf Salome-Meca-2017.0.1-LGPL-1.tgz

wget https://iweb.dl.sourceforge.net/project/ramonelinux/Rel_0.99/releases/x86_64/packages/gcc-libstdc++-4.9.1-1.ram0.99.x86_64.rpm
rpm2cpio gcc-libstdc++-4.9.1-1.ram0.99.x86_64.rpm | cpio -idmv
mv usr/lib64/libstdc++.so.6.0.20 /usr/local/lib64/.

./Salome-Meca-2017.0.1-LGPL-1.run -t /root/salome_meca -l English
ln -s /usr/local/lib64/libstdc++.so.6.0.20 /root/salome_meca/V2017/prerequisites/debianForSalome/lib/libstdc++.so.6

