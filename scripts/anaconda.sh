#!/bin/bash

export http_proxy="http://proxy.man.ac.uk:3128"
http_proxy="http://proxy.man.ac.uk:3128"

export https_proxy="http://proxy.man.ac.uk:3128"
https_proxy="http://proxy.man.ac.uk:3128"

# download and install
wget --quiet "https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh" -O "/tmp/anaconda.sh"
BASE=/opt/apps
mkdir -p $BASE
bash /tmp/anaconda.sh -b -p $BASE/anaconda
rm /tmp/anaconda.sh
export PATH=$BASE/anaconda/bin:$PATH # add to PATH
echo 'export PATH=$BASE/anaconda/bin:$PATH' >> /etc/bashrc
hash -r

export HTTP_PROXY="http://proxy.man.ac.uk:3128"
HTTP_PROXY="http://proxy.man.ac.uk:3128"

conda config --set proxy_servers.http http://proxy.man.ac.uk:3128

# some configuration to make it easy to install things
conda config --set always_yes yes --set changeps1 no
conda update -q conda

# add channels to look for packages
conda config --add channels r # for backward compatibility with old r packages
conda config --add channels defaults
conda config --add channels conda-forge # additional common tools
conda config --add channels bioconda # useful bioinformatics

conda install -n root _license

# display info
conda info -a
sync
