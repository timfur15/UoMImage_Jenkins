#!/bin/bash

echo "proxy=http://proxy.man.ac.uk:3128" >> /etc/yum.conf

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

