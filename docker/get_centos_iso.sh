#!/bin/bash

CENTOS_ISO=http/boot.iso
CENTOS_HTTP=http://mirrors.ukfast.co.uk/sites/ftp.centos.org/7/os/x86_64/images/boot.iso

if [ ! -f $CENTOS_ISO ]; then
	cd http
	wget $CENTOS_HTTP
	cd ..
fi
