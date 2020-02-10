#!/bin/bash

echo "proxy=http://proxy.man.ac.uk:3128" >> /etc/yum.conf

exec >> /tmp/docker-swarm.log
exec 2>&1

yum -y install docker iptables-services

systemctl stop firewalld
systemctl disable firewalld

systemctl enable docker
systemctl start docker

systemctl enable iptables
wget https://raw.githubusercontent.com/timfur15/UoMImage_Jenkins/master/terraform-files/swarm-iptables
mv iptables /etc/sysconfig/.
systemctl start iptables


