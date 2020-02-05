#!/bin/bash

export https_proxy=http://proxy.man.ac.uk:3128
https_proxy=http://proxy.man.ac.uk:3128

export http_proxy=http://proxy.man.ac.uk:3128
http_proxy=http://proxy.man.ac.uk:3128

yum install unzip -y

wget "https://github.com/kubermatic/kubeone/releases/download/v0.10.0/kubeone_0.10.0_linux_amd64.zip"
unzip kubeone_0.10.0_linux_amd64.zip 
cp kubeone /usr/local/bin/.
mv kubeone /usr/local/sbin/.
kubeone completion bash > /etc/bash_completion.d/kubeone

wget https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip
unzip terraform_0.12.20_linux_amd64.zip 
cp terraform /usr/local/sbin/.
mv terraform /usr/local/bin/.

eval `ssh-agent`

mkdir /root/terraform
cd /root/terraform
wget https://raw.githubusercontent.com/timfur15/UoMImage_Jenkins/master/terraform-files/main.tf
wget https://raw.githubusercontent.com/timfur15/UoMImage_Jenkins/master/terraform-files/terraform.tfvars
wget https://raw.githubusercontent.com/timfur15/UoMImage_Jenkins/master/terraform-files/versions.tf
wget "https://raw.githubusercontent.com/timfur15/UoMImage_Jenkins/master/terraform-files/source.txt"
wget https://raw.githubusercontent.com/timfur15/UoMImage_Jenkins/master/terraform-files/variables.tf
wget https://raw.githubusercontent.com/timfur15/UoMImage_Jenkins/master/terraform-files/output.tf
wget https://raw.githubusercontent.com/timfur15/UoMImage_Jenkins/master/terraform-files/readme.txt

echo -e "\n\nNow add AWS credentials to the source.txt file and source it using..."
echo -e "\n. source.txt"
echo -e "\n\nAlso export AWS_SECRET_ACCESS_KEY and AWS_ACCESS_KEY_ID credentials."
echo -e "\n\n"
echo -e "\nThen run..."
echo -e "\nterraform init; terraform apply -auto-approve; kubeone config print > config.yaml; kubeone install config.yaml -t ."
echo -e "\n"
echo -e "\n...(the dot at the end is included and in the correct place!) and when finished, destroy it by..."
echo -e "\nkubeone reset config.yaml -t .; terraform destroy -auto-approve"
echo -e "\n"

# Requires id_rsa, id_rsa.pub and AWS credentials to already be on controlling terraform VM
