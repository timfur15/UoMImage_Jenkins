#!/bin/bash

cd /root
wget -O paraview.tgz "https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v5.6&type=binary&os=Linux&downloadFile=ParaView-5.6.2-MPI-Linux-64bit.tar.gz"
tar -xvzf paraview.tgz

#/root/ParaView-5.6.2-MPI-Linux-64bit/bin/pvserver --force-offscreen-rendering
