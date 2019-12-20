#!/bin/bash
export RROOT=/opt/apps/R
export RVER=3.4.1
export RDIR=$RROOT/$RVER
mkdir -p $RROOT
chown vagrant. $RROOT
cd $RROOT
mkdir $RVER archive build
cd archive
wget https://cran.rstudio.com/src/base/R-3/R-${RVER}.tar.gz
cd ../build
tar xzf ../archive/R-$RVER.tar.gz
cd R-$RVER
./configure --prefix=$RDIR --enable-R-shlib 2>&1 | tee ../config.el7.log
make 2>&1 | tee ../make.el7.log
make install 2>&1 | tee ../make.el7.log
chown -R vagrant. $RDIR
chmod -R og+rX $RDIR
chmod og+rX $RROOT
