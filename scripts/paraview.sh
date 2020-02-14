#!/bin/bash

export https_proxy=http://proxy.man.ac.uk:3128
https_proxy=http://proxy.man.ac.uk:3128

cd /root
wget -O paraview.tgz "https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v5.6&type=binary&os=Linux&downloadFile=ParaView-5.6.2-MPI-Linux-64bit.tar.gz"
tar -xvzf paraview.tgz

#/root/ParaView-5.6.2-MPI-Linux-64bit/bin/pvserver --force-offscreen-rendering

unset https_proxy
