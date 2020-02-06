#!/bin/bash

http_proxy=http://proxy.man.ac.uk:3128
https_proxy=http://proxy.man.ac.uk:3128
export http_proxy=http://proxy.man.ac.uk:3128
export https_proxy=http://proxy.man.ac.uk:3128

systemctl stop firewalld
systemctl disable firewalld

sed -i '/.*proxy.*/d' /etc/yum.conf

sed -i "s/.*PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config
systemctl restart sshd

mkdir /root/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2JDsYtz5MuBX7LCb16rn4TNswhCIfJeqMEVoW+Vk9R0EZOX3RLXqhKc3zWApPnMvV5iMixPhSOeXvgYsuS0fwJyCemvn2pdB3tl/1tLfcJj39aEIGtmJ6pNxFswRDlvYAZthBXS5NGkQ3KyYee7sXm2lRB1QfLEiO/4lTQQsV45nDQses5n9I7phIoVWzf9/xeKTQO9gIlkr+LQ5SSVFnv43wkZSMsC24p1oTZ8L7bkHkNdq96GqIbsCxQQr+PNMzePHC2I5V9/BPQdBL54LjX670qdcamrxhTsnYfXtOC0tmPDRBUxuFFIt4yOzS/uJTgeNAxywgsozMxxR1d4Hl vagrant@ip-172-31-90-93" > /root/.ssh/authorized_keys

yum install iptables-services -y
systemctl enable iptables
wget https://raw.githubusercontent.com/timfur15/UoMImage_Jenkins/master/terraform-files/iptables
mv iptables /etc/sysconfig/.
systemctl start iptables

