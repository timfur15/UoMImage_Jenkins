#!/bin/bash

export HTTPS_PROXY=http://proxy.man.ac.uk:3128
HTTPS_PROXY=http://proxy.man.ac.uk:3128

wget https://github.com/kubermatic/kubeone/releases/download/v0.9.2/kubeone_0.9.2_linux_amd64.zip
https://github.com/kubermatic/kubeone/releases/download/v0.10.0/kubeone_0.10.0_linux_amd64.zip
unzip kubeone_0.10.0_linux_amd64.zip 
mv kubeone /usr/local/bin/.
kubeone completion bash > /etc/bash_completion.d/kubeone

wget https://releases.hashicorp.com/terraform/0.12.9/terraform_0.12.9_linux_amd64.zip
unzip terraform_0.12.9_linux_amd64.zip 
mv terraform /usr/local/bin/.

eval `ssh-agent`

mkdir /root/terraform
cd /root/terraform
wget https://raw.githubusercontent.com/timfur15/UoMImage_Jenkins/master/terraform-files/main.tf
wget https://raw.githubusercontent.com/timfur15/UoMImage_Jenkins/master/terraform-files/terraform.tfvars
wget https://raw.githubusercontent.com/timfur15/UoMImage_Jenkins/master/terraform-files/versions.tf
wget "https://raw.githubusercontent.com/timfur15/UoMImage_Jenkins/master/terraform-files/source.txt"
wget https://raw.githubusercontent.com/timfur15/UoMImage_Jenkins/master/terraform-files/variables.tf

echo -e "\n\nNow add AWS credentials to the source.txt file and source it using..."
echo -e "\n. source.txt"
echo -e "\n\n"

# Requires id_rsa, id_rsa.pub and AWS credentials to already be on controlling terraform VM
