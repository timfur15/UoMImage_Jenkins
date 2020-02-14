#!/bin/bash

export https_proxy=http://proxy.man.ac.uk:3128
https_proxy=http://proxy.man.ac.uk:3128

exec >> /tmp/docker-swarm.log
exec 2>&1

yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine -y

yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

yum install docker-ce docker-ce-cli containerd.io -y

dm=docker-machine-$(uname -s)-$(uname -m)
wget https://github.com/docker/machine/releases/download/v0.14.0/$dm
mv $dm /usr/local/bin/docker-machine
chmod 755 /usr/local/bin/docker-machine
ln -s /usr/local/bin/docker-machine /usr/local/sbin/docker-machine

yum -y install iptables-services

systemctl stop firewalld
systemctl disable firewalld

systemctl enable docker
systemctl start docker

yum -y install iptables-services
systemctl enable iptables
wget https://raw.githubusercontent.com/timfur15/UoMImage_Jenkins/master/terraform-files/swarm-iptables
mv iptables /etc/sysconfig/.
systemctl start iptables

mkdir /root/swarm
cd /root/swarm
wget https://raw.githubusercontent.com/timfur15/UoMImage_Jenkins/master/terraform-files/swarm-create
mv swarm-create swarm-create.sh
chmod 755 swarm-create.sh

unset https_proxy
