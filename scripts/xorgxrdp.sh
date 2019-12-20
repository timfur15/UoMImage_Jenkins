#!/bin/bash
cd /tmp

#bootstrap
yum install -y xrdp xorgxrdp
systemctl enable xrdp
#edit /etc/xrdp/xrdi.ini file
#edit /et/skel/.Xclients

